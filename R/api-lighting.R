#' Light and Grouped Light Endpoints
#'
#' Interact with individual lights (`/clip/v2/resource/light`) and grouped
#' lighting services (`/clip/v2/resource/grouped_light`) on a Philips Hue
#' Bridge v2 or Bridge Pro.
#'
#' @details
#' Supported CLIP API v2 endpoints:
#' * `GET /clip/v2/resource/light` — [hue_get_lights()]
#' * `GET /clip/v2/resource/light/{id}` — [hue_get_light()]
#' * `PUT /clip/v2/resource/light/{id}` — [hue_update_light()]
#' * `GET /clip/v2/resource/grouped_light` — [hue_get_grouped_lights()]
#' * `GET /clip/v2/resource/grouped_light/{id}` — [hue_get_grouped_light()]
#' * `PUT /clip/v2/resource/grouped_light/{id}` — [hue_update_grouped_light()]
#'
#' Use [hue_payload_light()] to build validated `body` lists for updating power,
#' brightness, color temperature (mirek), CIE xy chromaticity, effects, alerts,
#' and transition dynamics.
#'
#' @param id Character scalar. UUID of the light or grouped light resource.
#' @param body Named list representing the CLIP API v2 JSON update payload
#'   (see [hue_payload_light()]).
#' @inheritParams hue_resources
#'
#' @return A `tbl_json` tibble (or list when `tidy = FALSE`) containing the
#'   bridge response `data` array.
#' @seealso [hue_payload_light()], [hue_get_rooms()], [hue_get_zones()]
#' @name hue_lighting
NULL

#' @rdname hue_lighting
#' @export
#' @examples
#' \dontrun{
#' lights <- hue_get_lights()
#' hue_update_light(
#'   id = lights$id[[1]],
#'   body = hue_payload_light(on = TRUE, brightness = 80, mirek = 300)
#' )
#' }
hue_get_lights <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("light", bridge = bridge, tidy = tidy)
}

#' @rdname hue_lighting
#' @export
hue_get_light <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("light", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_lighting
#' @export
hue_update_light <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put("light", id = id, body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_lighting
#' @export
hue_get_grouped_lights <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("grouped_light", bridge = bridge, tidy = tidy)
}

#' @rdname hue_lighting
#' @export
hue_get_grouped_light <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("grouped_light", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_lighting
#' @export
hue_update_grouped_light <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "grouped_light",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}
