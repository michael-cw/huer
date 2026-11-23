#' Stream Real-Time Events from a Philips Hue Bridge (SSE)
#'
#' Opens a persistent Server-Sent Events (`text/event-stream`) connection to
#' `GET /eventstream/clip/v2` on a Philips Hue Bridge v2 or Bridge Pro and
#' collects or processes real-time resource change events (including light
#' state changes, button presses, sensor readings, and Bridge Pro MotionAware
#' updates).
#'
#' @param callback Optional function invoked for each received SSE event. It
#'   receives a single argument: the parsed event object (`tibble` when
#'   `tidy = TRUE`, or a parsed list when `tidy = FALSE`). Return `FALSE` from
#'   `callback` to stop streaming early.
#' @param max_events Positive integer scalar. Maximum number of SSE events to
#'   read before closing the connection. Defaults to `10L`.
#' @param timeout Numeric scalar. Total streaming timeout in seconds. Defaults
#'   to `30`.
#' @param bridge Optional `hue_bridge` object created by [hue_bridge()]. If
#'   `NULL`, resolves from session defaults set by [hue_auth()] or environment
#'   variables.
#' @param tidy Logical scalar. If `TRUE` (default), parses each event's JSON
#'   data payload into a `tibble` with `jsonlite`. If `FALSE`, returns raw
#'   parsed lists.
#'
#' @return A list of parsed event objects (invisibly if `callback` is
#'   provided).
#' @seealso [hue_get_resources()], [hue_bridge()]
#' @export
#' @examples
#' \dontrun{
#' # Collect up to 5 real-time bridge events
#' events <- hue_eventstream(max_events = 5L, timeout = 15)
#'
#' # Process events live with a callback
#' hue_eventstream(
#'   callback = function(ev) {
#'     print(ev)
#'     TRUE
#'   },
#'   max_events = 20L
#' )
#' }
hue_eventstream <- function(callback = NULL,
                            max_events = 10L,
                            timeout = 30,
                            bridge = NULL,
                            tidy = TRUE) {
  if (!is.null(callback) && !is.function(callback)) {
    cli::cli_abort("{.arg callback} must be a function or {.val NULL}.")
  }
  if (!is.numeric(max_events) || length(max_events) != 1L ||
      is.na(max_events) || max_events < 1L) {
    cli::cli_abort("{.arg max_events} must be a positive integer.")
  }
  if (!is.numeric(timeout) || length(timeout) != 1L ||
      is.na(timeout) || timeout <= 0) {
    cli::cli_abort("{.arg timeout} must be a positive number of seconds.")
  }
  validate_scalar_lgl(tidy, "tidy")

  bridge <- resolve_bridge(bridge)
  max_events <- as.integer(max_events)

  req <- httr2::request(bridge$base_url) |>
    httr2::req_url_path_append("/eventstream/clip/v2") |>
    httr2::req_method("GET") |>
    httr2::req_headers(
      `hue-application-key` = bridge$app_key,
      Accept = "text/event-stream",
      .redact = "hue-application-key"
    ) |>
    httr2::req_user_agent(huer_user_agent()) |>
    httr2::req_error(body = hue_error_body)

  req <- apply_tls_options(
    req,
    verify_ssl = bridge$verify_ssl,
    ca_cert = bridge$ca_cert
  )

  resp <- httr2::req_perform_connection(req, blocking = TRUE)
  on.exit(close(resp), add = TRUE)

  events <- list()
  deadline <- Sys.time() + timeout

  while (length(events) < max_events && Sys.time() < deadline) {
    sse <- httr2::resp_stream_sse(resp)
    if (is.null(sse)) {
      break
    }

    data_txt <- sse$data
    if (is.null(data_txt) || !nzchar(trimws(data_txt))) {
      next
    }

    parsed <- if (tidy) {
      hue_parse_array(data_txt)
    } else {
      jsonlite::fromJSON(data_txt, simplifyVector = FALSE)
    }

    events[[length(events) + 1L]] <- parsed

    if (!is.null(callback)) {
      keep_going <- callback(parsed)
      if (isFALSE(keep_going)) {
        break
      }
    }
  }

  if (!is.null(callback)) {
    invisible(events)
  } else {
    events
  }
}
