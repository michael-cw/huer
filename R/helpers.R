#' Build a Philips Hue Resource Identifier Reference
#'
#' Constructs a standard CLIP API v2 resource identifier (`rid` / `rtype`)
#' object used when referencing lights, devices, rooms, zones, or services in
#' `POST` and `PUT` request bodies.
#'
#' @param rid Character scalar. UUID of the target resource.
#' @param rtype Character scalar. CLIP API v2 resource type (e.g., `"device"`,
#'   `"light"`, `"room"`, `"zone"`, `"grouped_light"`).
#'
#' @return A named list with elements `rid` and `rtype`.
#' @seealso [hue_create_room()], [hue_create_zone()], [hue_create_scene()]
#' @export
#' @examples
#' hue_resource_identifier("3b149a01-810e-4d5e-9094-41c0d1f35020", "device")
hue_resource_identifier <- function(rid, rtype) {
  validate_scalar_chr(rid, "rid")
  validate_scalar_chr(rtype, "rtype")
  list(rid = rid, rtype = rtype)
}

#' Build a Light or Grouped Light State Update Payload
#'
#' Convenience helper that constructs a validated CLIP API v2 JSON payload list
#' suitable for [hue_update_light()] and [hue_update_grouped_light()].
#'
#' @param on Optional logical scalar. Set `TRUE` to turn on or `FALSE` to turn
#'   off.
#' @param brightness Optional numeric scalar in `[0, 100]`. Target brightness
#'   percentage.
#' @param mirek Optional integer scalar in `[153, 500]`. Color temperature in
#'   mirek (`153` = coolest 6500K, `500` = warmest 2000K).
#' @param xy Optional numeric vector of length 2 (`c(x, y)`), each in `[0, 1]`,
#'   specifying CIE 1931 xy chromaticity coordinates.
#' @param effect Optional character scalar effect name (e.g., `"no_effect"`,
#'   `"candle"`, `"fire"`, `"prism"`, `"sparkle"`, `"opal"`, `"glisten"`,
#'   `"underwater"`, `"cosmos"`, `"sunbeam"`, `"enchant"`).
#' @param dynamics_duration Optional non-negative integer scalar transition
#'   duration in milliseconds.
#' @param alert Optional character scalar alert action (e.g., `"breathe"`).
#' @param ... Additional named CLIP API v2 fields merged into the payload
#'   (e.g., `gradient`, `timed_effects`, `signaling`, `metadata`).
#'
#' @return A named list suitable for passing as the `body` argument to
#'   [hue_update_light()] or [hue_update_grouped_light()].
#' @seealso [hue_update_light()], [hue_update_grouped_light()]
#' @export
#' @examples
#' payload <- hue_payload_light(
#'   on = TRUE,
#'   brightness = 80,
#'   mirek = 300,
#'   dynamics_duration = 400
#' )
#' payload
hue_payload_light <- function(on = NULL,
                              brightness = NULL,
                              mirek = NULL,
                              xy = NULL,
                              effect = NULL,
                              dynamics_duration = NULL,
                              alert = NULL,
                              ...) {
  body <- list()

  if (!is.null(on)) {
    validate_scalar_lgl(on, "on")
    body$on <- list(on = on)
  }

  if (!is.null(brightness)) {
    if (!is.numeric(brightness) || length(brightness) != 1L ||
        is.na(brightness) || brightness < 0 || brightness > 100) {
      cli::cli_abort("{.arg brightness} must be a single number between 0 and 100.")
    }
    body$dimming <- list(brightness = as.numeric(brightness))
  }

  if (!is.null(mirek)) {
    if (!is.numeric(mirek) || length(mirek) != 1L || is.na(mirek) ||
        mirek < 153 || mirek > 500) {
      cli::cli_abort("{.arg mirek} must be a single integer between 153 and 500.")
    }
    body$color_temperature <- list(mirek = as.integer(round(mirek)))
  }

  if (!is.null(xy)) {
    if (!is.numeric(xy) || length(xy) != 2L || any(is.na(xy)) ||
        any(xy < 0) || any(xy > 1)) {
      cli::cli_abort("{.arg xy} must be a numeric vector of length 2 with values in [0, 1].")
    }
    body$color <- list(xy = list(x = as.numeric(xy[[1L]]), y = as.numeric(xy[[2L]])))
  }

  if (!is.null(effect)) {
    validate_scalar_chr(effect, "effect")
    body$effects <- list(effect = effect)
  }

  if (!is.null(dynamics_duration)) {
    if (!is.numeric(dynamics_duration) || length(dynamics_duration) != 1L ||
        is.na(dynamics_duration) || dynamics_duration < 0) {
      cli::cli_abort("{.arg dynamics_duration} must be a non-negative integer (milliseconds).")
    }
    body$dynamics <- list(duration = as.integer(round(dynamics_duration)))
  }

  if (!is.null(alert)) {
    validate_scalar_chr(alert, "alert")
    body$alert <- list(action = alert)
  }

  extra <- list(...)
  if (length(extra) > 0L) {
    if (is.null(names(extra)) || any(!nzchar(names(extra)))) {
      cli::cli_abort("All extra arguments in {.arg ...} must be named.")
    }
    body <- utils::modifyList(body, extra)
  }

  if (length(body) == 0L) {
    cli::cli_abort("At least one light state field must be supplied.")
  }

  body
}
