# Core HTTP transport and tidyjson parsing helpers

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

  c("Philips Hue CLIP API v2 returned error(s):", stats::setNames(msgs, rep("x", length(msgs))))
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
#' (`{"errors": [...], "data": [...]}`) into a `tbl_json` tibble using
#' `tidyjson`, automatically spreading scalar and nested object properties into
#' columns while preserving the underlying `..JSON` attribute for nested array
#' exploration with [hue_unnest_array()] or `tidyjson` verbs.
#'
#' @param json Character scalar containing a JSON string, or a parsed R list
#'   containing a `data` element.
#' @param tidy Logical scalar. If `TRUE` (default), returns a `tbl_json` tibble
#'   via `tidyjson`. If `FALSE`, returns the raw parsed R list.
#'
#' @return A `tbl_json` tibble (inheriting from `tbl_df`, `tbl`, `data.frame`)
#'   when `tidy = TRUE`, or a named list when `tidy = FALSE`.
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
    json <- as.character(jsonlite::toJSON(json, auto_unbox = TRUE, null = "null"))
  }

  validate_scalar_chr(json, "json")

  if (!tidy) {
    return(jsonlite::fromJSON(json, simplifyVector = FALSE))
  }

  parsed <- jsonlite::fromJSON(json, simplifyVector = FALSE)
  if (!is.list(parsed) || is.null(parsed$data)) {
    cli::cli_abort(
      "JSON payload does not contain a top-level {.field data} array."
    )
  }

  if (length(parsed$data) == 0L) {
    empty_tbl <- tidyjson::as.tbl_json("[]") |>
      tidyjson::gather_array()
    return(drop_tidyjson_index_cols(empty_tbl))
  }

  tbl <- tidyjson::as.tbl_json(json) |>
    tidyjson::enter_object("data") |>
    tidyjson::gather_array() |>
    tidyjson::spread_all()

  drop_tidyjson_index_cols(tbl)
}

hue_parse_array <- function(json) {
  validate_scalar_chr(json, "json")
  parsed <- jsonlite::fromJSON(json, simplifyVector = FALSE)
  if (length(parsed) == 0L) {
    empty_tbl <- tidyjson::as.tbl_json("[]") |>
      tidyjson::gather_array()
    return(drop_tidyjson_index_cols(empty_tbl))
  }

  tbl <- tidyjson::as.tbl_json(json) |>
    tidyjson::gather_array() |>
    tidyjson::spread_all()

  drop_tidyjson_index_cols(tbl)
}

drop_tidyjson_index_cols <- function(tbl) {
  keep <- setdiff(names(tbl), c("document.id", "array.index"))
  tbl[, keep, drop = FALSE]
}

#' Unnest a Nested JSON Array Field from a Hue Response
#'
#' Uses `tidyjson` to enter and expand a nested array property (such as
#' `"children"`, `"services"`, `"actions"`, `"channels"`, or `"locations"`)
#' stored inside the `..JSON` payload of a `tbl_json` object returned by
#' `huer`.
#'
#' @param x A `tbl_json` object returned by [hue_parse_response()] or any
#'   `hue_get_*()` function.
#' @param col Character scalar. Name of the nested JSON array key to expand
#'   (e.g., `"children"` or `"services"`).
#'
#' @return A `tbl_json` tibble with one row per element of the nested array,
#'   preserving parent columns and spreading array element fields.
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
  if (!inherits(x, "tbl_json")) {
    cli::cli_abort(
      "{.arg x} must be a {.cls tbl_json} object returned with {.code tidy = TRUE}."
    )
  }
  validate_scalar_chr(col, "col")

  if (nrow(x) == 0L) {
    return(x)
  }

  out <- do.call(tidyjson::enter_object, list(x, col)) |>
    tidyjson::gather_array() |>
    tidyjson::spread_all()

  drop_tidyjson_index_cols(out)
}
