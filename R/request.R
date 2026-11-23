# Core HTTP transport and jsonlite/base R parsing helpers

huer_user_agent <- function() {
  ver <- tryCatch(
    as.character(utils::packageVersion("huer")),
    error = function(e) "0.1.0"
  )
  paste0("huer/", ver, " (R; httr2)")
}

apply_tls_options <- function(req, verify_ssl = TRUE, ca_cert = NULL) {
  if (!is.null(ca_cert)) {
    req <- httr2::req_options(req, cainfo = ca_cert)
  } else if (!isTRUE(verify_ssl)) {
    req <- httr2::req_options(req, ssl_verifypeer = 0L, ssl_verifyhost = 0L)
  }
  req
}

hue_req_base <- function(bridge, path, method = "GET", body = NULL) {
  req <- httr2::request(bridge$base_url) |>
    httr2::req_url_path_append(path) |>
    httr2::req_method(method) |>
    httr2::req_headers(
      `hue-application-key` = bridge$app_key,
      Accept = "application/json",
      .redact = "hue-application-key"
    ) |>
    httr2::req_user_agent(huer_user_agent()) |>
    httr2::req_timeout(bridge$timeout) |>
    httr2::req_error(body = hue_error_body)

  req <- apply_tls_options(
    req,
    verify_ssl = bridge$verify_ssl,
    ca_cert = bridge$ca_cert
  )

  if (!is.null(body)) {
    req <- httr2::req_body_json(req, data = body, auto_unbox = TRUE)
  }

  req
}

hue_error_body <- function(resp) {
  body_txt <- tryCatch(
    httr2::resp_body_string(resp),
    error = function(e) ""
  )
  if (!nzchar(body_txt)) {
    return(NULL)
  }

  parsed <- tryCatch(
    jsonlite::fromJSON(body_txt, simplifyVector = FALSE),
    error = function(e) NULL
  )
  if (is.null(parsed) || is.null(parsed$errors) || length(parsed$errors) == 0L) {
    return(body_txt)
  }

  msgs <- vapply(
    parsed$errors,
    function(err) {
      if (is.list(err) && !is.null(err$description)) {
        as.character(err$description)
      } else {
        as.character(err)
      }
    },
    character(1L)
  )

  c(
    "Philips Hue CLIP API v2 returned error(s):",
    stats::setNames(msgs, rep("x", length(msgs)))
  )
}

hue_perform <- function(bridge,
                        path,
                        method = "GET",
                        body = NULL,
                        tidy = TRUE,
                        call = rlang::caller_env()) {
  validate_scalar_lgl(tidy, "tidy", call = call)
  req <- hue_req_base(bridge = bridge, path = path, method = method, body = body)
  resp <- httr2::req_perform(req)
  body_txt <- httr2::resp_body_string(resp)

  # Surface non-fatal API warnings (e.g., HTTP 207 Multi-Status partial errors)
  parsed_meta <- tryCatch(
    jsonlite::fromJSON(body_txt, simplifyVector = FALSE),
    error = function(e) NULL
  )
  if (is.list(parsed_meta) && length(parsed_meta$errors) > 0L) {
    warn_msgs <- vapply(
      parsed_meta$errors,
      function(err) as.character(err$description %||% err),
      character(1L)
    )
    cli::cli_warn(c(
      "Philips Hue CLIP API v2 reported partial error(s):",
      stats::setNames(warn_msgs, rep("!", length(warn_msgs)))
    ))
  }

  hue_parse_response(body_txt, tidy = tidy)
}

#' Parse a Philips Hue CLIP API v2 JSON Response
#'
#' Parses a standard Philips Hue CLIP API v2 JSON envelope
#' (`{"errors": [...], "data": [...]}`) into a tidy `tibble` using `jsonlite`
#' and base R, automatically flattening scalar and nested object properties
#' into dot-separated columns while preserving nested JSON arrays (such as
#' `children` or `services`) as list-columns for inspection or expansion with
#' [hue_unnest_array()].
#'
#' @param json Character scalar containing a JSON string, or a parsed R list
#'   containing a `data` element.
#' @param tidy Logical scalar. If `TRUE` (default), returns a flattened
#'   `tibble`. If `FALSE`, returns the raw parsed R list.
#'
#' @return A `tibble` (`tbl_df`, `tbl`, `data.frame`) when `tidy = TRUE`, or a
#'   named list when `tidy = FALSE`.
#' @seealso [hue_unnest_array()], [hue_get_resources()]
#' @export
#' @examples
#' sample_json <- paste0(
#'   '{"errors":[],"data":[',
#'   '{"id":"1111","type":"light","metadata":{"name":"Desk Lamp"},',
#'   '"on":{"on":true},"dimming":{"brightness":75.0}}]}'
#' )
#' res <- hue_parse_response(sample_json)
#' res
hue_parse_response <- function(json, tidy = TRUE) {
  validate_scalar_lgl(tidy, "tidy")

  if (is.list(json)) {
    if (!tidy) {
      return(json)
    }
    parsed <- json
  } else {
    validate_scalar_chr(json, "json")
    parsed <- jsonlite::fromJSON(json, simplifyVector = FALSE)
    if (!tidy) {
      return(parsed)
    }
  }

  if (!is.list(parsed) || is.null(parsed$data)) {
    cli::cli_abort(
      "JSON payload does not contain a top-level {.field data} array."
    )
  }

  records_to_tibble(parsed$data)
}

hue_parse_array <- function(json) {
  validate_scalar_chr(json, "json")
  parsed <- jsonlite::fromJSON(json, simplifyVector = FALSE)
  records_to_tibble(parsed)
}

#' Unnest a Nested JSON Array Column from a Hue Response
#'
#' Expands a nested JSON array list-column (such as `"children"`,
#' `"services"`, `"actions"`, `"channels"`, or `"locations"`) from a `tibble`
#' returned by `huer`, repeating parent rows and flattening each element's
#' fields into columns.
#'
#' @param x A `data.frame` or `tibble` returned by [hue_parse_response()] or
#'   any `hue_get_*()` function with `tidy = TRUE`.
#' @param col Character scalar. Name of the nested JSON array list-column to
#'   expand (e.g., `"children"` or `"services"`).
#'
#' @return A `tibble` with one row per element of the nested array, preserving
#'   parent columns and spreading nested element fields.
#' @seealso [hue_parse_response()]
#' @export
#' @examples
#' room_json <- paste0(
#'   '{"errors":[],"data":[{"id":"room-1","type":"room",',
#'   '"metadata":{"name":"Living Room"},',
#'   '"children":[{"rid":"dev-1","rtype":"device"},',
#'   '{"rid":"dev-2","rtype":"device"}]}]}'
#' )
#' rooms <- hue_parse_response(room_json)
#' hue_unnest_array(rooms, "children")
hue_unnest_array <- function(x, col) {
  if (!is.data.frame(x)) {
    cli::cli_abort(
      "{.arg x} must be a {.cls tibble} or {.cls data.frame} returned with {.code tidy = TRUE}."
    )
  }
  validate_scalar_chr(col, "col")

  if (!col %in% names(x)) {
    cli::cli_abort(
      "Column {.field {col}} was not found in {.arg x}."
    )
  }

  if (nrow(x) == 0L) {
    return(tibble::as_tibble(x))
  }

  col_vals <- x[[col]]
  if (!is.list(col_vals)) {
    cli::cli_abort(
      "Column {.field {col}} is not a list-column and cannot be unnested."
    )
  }

  parent_cols <- setdiff(names(x), col)
  parent_df <- tibble::as_tibble(x[, parent_cols, drop = FALSE])

  row_indices <- integer(0)
  child_blocks <- list()

  for (i in seq_len(nrow(x))) {
    el <- col_vals[[i]]
    if (is.null(el) || length(el) == 0L) {
      next
    }

    if (is.data.frame(el)) {
      if (nrow(el) == 0L) next
      child_tbl <- tibble::as_tibble(el)
    } else if (is.list(el)) {
      child_tbl <- records_to_tibble(el)
      if (nrow(child_tbl) == 0L) next
    } else if (is.atomic(el)) {
      child_tbl <- tibble::tibble(value = el)
      names(child_tbl) <- col
    } else {
      next
    }

    row_indices <- c(row_indices, rep(i, nrow(child_tbl)))
    child_blocks[[length(child_blocks) + 1L]] <- child_tbl
  }

  if (length(child_blocks) == 0L) {
    return(parent_df[0L, , drop = FALSE])
  }

  children_combined <- bind_tibbles_base(child_blocks)

  # Avoid silently overwriting existing parent column names
  dup_names <- intersect(names(parent_df), names(children_combined))
  if (length(dup_names) > 0L) {
    nm <- names(children_combined)
    nm[nm %in% dup_names] <- paste0(col, ".", nm[nm %in% dup_names])
    names(children_combined) <- nm
  }

  parent_expanded <- parent_df[row_indices, , drop = FALSE]
  if (ncol(parent_expanded) == 0L) {
    return(children_combined)
  }
  tibble::as_tibble(cbind(parent_expanded, children_combined))
}

# Pure base R + tibble JSON flattening internals -------------------------------

is_json_object <- function(x) {
  is.list(x) && !is.null(names(x))
}

is_json_array <- function(x) {
  is.list(x) && is.null(names(x))
}

simplify_json_array <- function(arr) {
  if (length(arr) == 0L) {
    return(list())
  }
  all_scalar <- all(vapply(
    arr,
    function(el) is.null(el) || (is.atomic(el) && length(el) == 1L),
    logical(1L)
  ))
  if (all_scalar) {
    return(coerce_scalar_list(arr))
  }
  all_objects <- all(vapply(arr, is_json_object, logical(1L)))
  if (all_objects) {
    return(records_to_tibble(arr))
  }
  arr
}

flatten_json_record <- function(rec, prefix = "") {
  if (!is.list(rec) || length(rec) == 0L) {
    return(list())
  }

  out <- list()
  nms <- names(rec)
  if (is.null(nms)) {
    nms <- paste0("V", seq_along(rec))
  }

  for (idx in seq_along(rec)) {
    key <- if (nzchar(prefix)) paste0(prefix, ".", nms[[idx]]) else nms[[idx]]
    val <- rec[[idx]]

    if (is.null(val)) {
      out[key] <- list(NULL)
    } else if (is.atomic(val) && length(val) == 1L) {
      out[[key]] <- val
    } else if (is_json_object(val)) {
      if (length(val) > 0L) {
        nested <- flatten_json_record(val, prefix = key)
        for (nk in names(nested)) {
          out[nk] <- list(nested[[nk]])
        }
      }
    } else if (is_json_array(val)) {
      out[[key]] <- list(simplify_json_array(val))
    } else {
      out[[key]] <- list(val)
    }
  }

  out
}

coerce_scalar_list <- function(vals) {
  n <- length(vals)
  non_null <- Filter(Negate(is.null), vals)
  if (length(non_null) == 0L) {
    return(rep(NA, n))
  }

  if (all(vapply(non_null, is.logical, logical(1L)))) {
    return(vapply(vals, function(v) if (is.null(v)) NA else as.logical(v), logical(1L)))
  }
  if (all(vapply(non_null, is.integer, logical(1L)))) {
    return(vapply(vals, function(v) if (is.null(v)) NA_integer_ else as.integer(v), integer(1L)))
  }
  if (all(vapply(non_null, is.numeric, logical(1L)))) {
    return(vapply(vals, function(v) if (is.null(v)) NA_real_ else as.numeric(v), double(1L)))
  }
  vapply(vals, function(v) if (is.null(v)) NA_character_ else as.character(v), character(1L))
}

records_to_tibble <- function(records) {
  if (!is.list(records) || length(records) == 0L) {
    return(tibble::tibble())
  }

  flat_list <- lapply(records, flatten_json_record)
  all_cols <- unique(unlist(lapply(flat_list, names), use.names = FALSE))

  if (length(all_cols) == 0L) {
    return(tibble::tibble())
  }

  n <- length(flat_list)
  cols <- vector("list", length(all_cols))
  names(cols) <- all_cols

  for (col in all_cols) {
    vals <- lapply(flat_list, function(rec) {
      if (col %in% names(rec)) rec[[col]] else NULL
    })

    is_wrapped_list <- any(vapply(vals, is.list, logical(1L)))
    if (is_wrapped_list) {
      # Unwrap single-level list wrapper placed by flatten_json_record()
      cols[[col]] <- lapply(vals, function(v) {
        if (is.null(v)) NULL else if (is.list(v) && length(v) == 1L) v[[1L]] else v
      })
    } else {
      cols[[col]] <- coerce_scalar_list(vals)
    }
  }

  tibble::as_tibble(cols)
}

bind_tibbles_base <- function(tbl_list) {
  if (length(tbl_list) == 0L) {
    return(tibble::tibble())
  }
  if (length(tbl_list) == 1L) {
    return(tibble::as_tibble(tbl_list[[1L]]))
  }

  all_cols <- unique(unlist(lapply(tbl_list, names), use.names = FALSE))
  total_rows <- sum(vapply(tbl_list, nrow, integer(1L)))
  out <- vector("list", length(all_cols))
  names(out) <- all_cols

  for (col in all_cols) {
    col_pieces <- lapply(tbl_list, function(df) {
      if (col %in% names(df)) {
        df[[col]]
      } else {
        rep(NA, nrow(df))
      }
    })

    has_list_piece <- any(vapply(col_pieces, is.list, logical(1L)))
    if (has_list_piece) {
      out[[col]] <- unlist(
        lapply(col_pieces, function(p) {
          if (is.list(p)) p else as.list(p)
        }),
        recursive = FALSE
      )
    } else {
      out[[col]] <- do.call(c, col_pieces)
    }
  }

  if (length(out) == 0L) {
    return(tibble::new_tibble(list(), nrow = total_rows))
  }
  tibble::as_tibble(out)
}
