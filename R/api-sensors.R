#' Sensor and Physical Control Endpoints
#'
#' Query and configure sensor and physical control resources on a Philips Hue
#' Bridge v2 or Bridge Pro, including motion, grouped motion, Hue Secure camera
#' motion, temperature, ambient light level, grouped light level, buttons,
#' doorbell buttons, rotary dials, contact sensors, and tamper sensors.
#'
#' @details
#' Supported CLIP API v2 endpoints:
#' * `GET /clip/v2/resource/motion` — [hue_get_motions()]
#' * `GET /clip/v2/resource/motion/{id}` — [hue_get_motion()]
#' * `PUT /clip/v2/resource/motion/{id}` — [hue_update_motion()]
#' * `GET /clip/v2/resource/grouped_motion` — [hue_get_grouped_motions()]
#' * `GET /clip/v2/resource/grouped_motion/{id}` — [hue_get_grouped_motion()]
#' * `PUT /clip/v2/resource/grouped_motion/{id}` — [hue_update_grouped_motion()]
#' * `GET /clip/v2/resource/camera_motion` — [hue_get_camera_motions()]
#' * `GET /clip/v2/resource/camera_motion/{id}` — [hue_get_camera_motion()]
#' * `PUT /clip/v2/resource/camera_motion/{id}` — [hue_update_camera_motion()]
#' * `GET /clip/v2/resource/temperature` — [hue_get_temperatures()]
#' * `GET /clip/v2/resource/temperature/{id}` — [hue_get_temperature()]
#' * `PUT /clip/v2/resource/temperature/{id}` — [hue_update_temperature()]
#' * `GET /clip/v2/resource/light_level` — [hue_get_light_levels()]
#' * `GET /clip/v2/resource/light_level/{id}` — [hue_get_light_level()]
#' * `PUT /clip/v2/resource/light_level/{id}` — [hue_update_light_level()]
#' * `GET /clip/v2/resource/grouped_light_level` — [hue_get_grouped_light_levels()]
#' * `GET /clip/v2/resource/grouped_light_level/{id}` — [hue_get_grouped_light_level()]
#' * `PUT /clip/v2/resource/grouped_light_level/{id}` — [hue_update_grouped_light_level()]
#' * `GET /clip/v2/resource/button` — [hue_get_buttons()]
#' * `GET /clip/v2/resource/button/{id}` — [hue_get_button()]
#' * `GET /clip/v2/resource/bell_button` — [hue_get_bell_buttons()]
#' * `GET /clip/v2/resource/bell_button/{id}` — [hue_get_bell_button()]
#' * `GET /clip/v2/resource/relative_rotary` — [hue_get_relative_rotaries()]
#' * `GET /clip/v2/resource/relative_rotary/{id}` — [hue_get_relative_rotary()]
#' * `GET /clip/v2/resource/contact` — [hue_get_contacts()]
#' * `GET /clip/v2/resource/contact/{id}` — [hue_get_contact()]
#' * `PUT /clip/v2/resource/contact/{id}` — [hue_update_contact()]
#' * `GET /clip/v2/resource/tamper` — [hue_get_tampers()]
#' * `GET /clip/v2/resource/tamper/{id}` — [hue_get_tamper()]
#' * `PUT /clip/v2/resource/tamper/{id}` — [hue_update_tamper()]
#'
#' @param id Character scalar. UUID of the sensor or control resource.
#' @param body Named list representing the CLIP API v2 JSON update payload
#'   (for example, `list(enabled = TRUE)`).
#' @inheritParams hue_resources
#'
#' @return A `tibble` (or list when `tidy = FALSE`) containing the
#'   bridge response `data` array.
#' @seealso [hue_motion_areas], [hue_eventstream()]
#' @name hue_sensors
NULL

#' @rdname hue_sensors
#' @export
#' @examples
#' \dontrun{
#' motions <- hue_get_motions()
#' temps <- hue_get_temperatures()
#' contacts <- hue_get_contacts()
#' }
hue_get_motions <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("motion", bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_motion <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("motion", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_update_motion <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put("motion", id = id, body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_grouped_motions <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("grouped_motion", bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_grouped_motion <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("grouped_motion", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_update_grouped_motion <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "grouped_motion",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_sensors
#' @export
hue_get_camera_motions <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("camera_motion", bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_camera_motion <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("camera_motion", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_update_camera_motion <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "camera_motion",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_sensors
#' @export
hue_get_temperatures <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("temperature", bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_temperature <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("temperature", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_update_temperature <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "temperature",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_sensors
#' @export
hue_get_light_levels <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("light_level", bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_light_level <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("light_level", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_update_light_level <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "light_level",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_sensors
#' @export
hue_get_grouped_light_levels <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("grouped_light_level", bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_grouped_light_level <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("grouped_light_level", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_update_grouped_light_level <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "grouped_light_level",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_sensors
#' @export
hue_get_buttons <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("button", bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_button <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("button", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_bell_buttons <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("bell_button", bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_bell_button <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("bell_button", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_relative_rotaries <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("relative_rotary", bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_relative_rotary <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("relative_rotary", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_contacts <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("contact", bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_contact <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("contact", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_update_contact <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put("contact", id = id, body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_tampers <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("tamper", bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_get_tamper <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("tamper", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_sensors
#' @export
hue_update_tamper <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put("tamper", id = id, body = body, bridge = bridge, tidy = tidy)
}
