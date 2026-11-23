#' Device, Power, Firmware Update, and Bridge Endpoints
#'
#' Manage hardware devices (`/clip/v2/resource/device`), device battery/power
#' states (`/clip/v2/resource/device_power`), firmware software update services
#' (`/clip/v2/resource/device_software_update`), and Hue Bridge properties
#' (`/clip/v2/resource/bridge`).
#'
#' @details
#' Supported CLIP API v2 endpoints:
#' * `GET /clip/v2/resource/device` — [hue_get_devices()]
#' * `GET /clip/v2/resource/device/{id}` — [hue_get_device()]
#' * `PUT /clip/v2/resource/device/{id}` — [hue_update_device()]
#' * `DELETE /clip/v2/resource/device/{id}` — [hue_delete_device()]
#' * `GET /clip/v2/resource/device_power` — [hue_get_device_powers()]
#' * `GET /clip/v2/resource/device_power/{id}` — [hue_get_device_power()]
#' * `GET /clip/v2/resource/device_software_update` — [hue_get_device_software_updates()]
#' * `GET /clip/v2/resource/device_software_update/{id}` — [hue_get_device_software_update()]
#' * `PUT /clip/v2/resource/device_software_update/{id}` — [hue_update_device_software_update()]
#' * `GET /clip/v2/resource/bridge` — [hue_get_bridges()]
#' * `GET /clip/v2/resource/bridge/{id}` — [hue_get_bridge()]
#' * `PUT /clip/v2/resource/bridge/{id}` — [hue_update_bridge()]
#'
#' @param id Character scalar. UUID of the device, device power, software
#'   update, or bridge resource.
#' @param body Named list representing the CLIP API v2 JSON payload.
#' @inheritParams hue_resources
#'
#' @return A `tibble` (or list when `tidy = FALSE`) containing the
#'   bridge response `data` array.
#' @seealso [hue_get_zigbee_connectivities()], [hue_get_wifi_connectivities()]
#' @name hue_devices
NULL

#' @rdname hue_devices
#' @export
#' @examples
#' \dontrun{
#' devices <- hue_get_devices()
#' bridge_info <- hue_get_bridges()
#' }
hue_get_devices <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("device", bridge = bridge, tidy = tidy)
}

#' @rdname hue_devices
#' @export
hue_get_device <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("device", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_devices
#' @export
hue_update_device <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put("device", id = id, body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_devices
#' @export
hue_delete_device <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_delete("device", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_devices
#' @export
hue_get_device_powers <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("device_power", bridge = bridge, tidy = tidy)
}

#' @rdname hue_devices
#' @export
hue_get_device_power <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("device_power", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_devices
#' @export
hue_get_device_software_updates <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("device_software_update", bridge = bridge, tidy = tidy)
}

#' @rdname hue_devices
#' @export
hue_get_device_software_update <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("device_software_update", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_devices
#' @export
hue_update_device_software_update <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "device_software_update",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_devices
#' @export
hue_get_bridges <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("bridge", bridge = bridge, tidy = tidy)
}

#' @rdname hue_devices
#' @export
hue_get_bridge <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("bridge", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_devices
#' @export
hue_update_bridge <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put("bridge", id = id, body = body, bridge = bridge, tidy = tidy)
}
