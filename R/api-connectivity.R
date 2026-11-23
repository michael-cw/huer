#' Connectivity and Zigbee Device Discovery Endpoints
#'
#' Monitor and manage wireless connectivity services on a Philips Hue Bridge v2
#' or Bridge Pro, including Zigbee (`/clip/v2/resource/zigbee_connectivity`),
#' Zigbee Green Power (`/clip/v2/resource/zgp_connectivity`), Wi-Fi
#' (`/clip/v2/resource/wifi_connectivity`), and Zigbee pairing discovery
#' (`/clip/v2/resource/zigbee_device_discovery`).
#'
#' @details
#' Supported CLIP API v2 endpoints:
#' * `GET /clip/v2/resource/zigbee_connectivity` —
#'   [hue_get_zigbee_connectivities()]
#' * `GET /clip/v2/resource/zigbee_connectivity/{id}` —
#'   [hue_get_zigbee_connectivity()]
#' * `GET /clip/v2/resource/zgp_connectivity` —
#'   [hue_get_zgp_connectivities()]
#' * `GET /clip/v2/resource/zgp_connectivity/{id}` —
#'   [hue_get_zgp_connectivity()]
#' * `GET /clip/v2/resource/wifi_connectivity` —
#'   [hue_get_wifi_connectivities()]
#' * `GET /clip/v2/resource/wifi_connectivity/{id}` —
#'   [hue_get_wifi_connectivity()]
#' * `PUT /clip/v2/resource/wifi_connectivity/{id}` —
#'   [hue_update_wifi_connectivity()]
#' * `GET /clip/v2/resource/zigbee_device_discovery` —
#'   [hue_get_zigbee_device_discoveries()]
#' * `GET /clip/v2/resource/zigbee_device_discovery/{id}` —
#'   [hue_get_zigbee_device_discovery()]
#' * `PUT /clip/v2/resource/zigbee_device_discovery/{id}` —
#'   [hue_update_zigbee_device_discovery()]
#'
#' @param id Character scalar. UUID of the connectivity or discovery resource.
#' @param body Named list representing the CLIP API v2 JSON payload.
#' @inheritParams hue_resources
#'
#' @return A `tibble` (or list when `tidy = FALSE`) containing the
#'   bridge response `data` array.
#' @seealso [hue_devices]
#' @name hue_connectivity
NULL

#' @rdname hue_connectivity
#' @export
#' @examples
#' \dontrun{
#' zigbee <- hue_get_zigbee_connectivities()
#' wifi <- hue_get_wifi_connectivities()
#' }
hue_get_zigbee_connectivities <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("zigbee_connectivity", bridge = bridge, tidy = tidy)
}

#' @rdname hue_connectivity
#' @export
hue_get_zigbee_connectivity <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get(
    "zigbee_connectivity",
    id = id,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_connectivity
#' @export
hue_get_zgp_connectivities <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("zgp_connectivity", bridge = bridge, tidy = tidy)
}

#' @rdname hue_connectivity
#' @export
hue_get_zgp_connectivity <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("zgp_connectivity", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_connectivity
#' @export
hue_get_wifi_connectivities <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("wifi_connectivity", bridge = bridge, tidy = tidy)
}

#' @rdname hue_connectivity
#' @export
hue_get_wifi_connectivity <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("wifi_connectivity", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_connectivity
#' @export
hue_update_wifi_connectivity <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "wifi_connectivity",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_connectivity
#' @export
hue_get_zigbee_device_discoveries <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("zigbee_device_discovery", bridge = bridge, tidy = tidy)
}

#' @rdname hue_connectivity
#' @export
hue_get_zigbee_device_discovery <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get(
    "zigbee_device_discovery",
    id = id,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_connectivity
#' @export
hue_update_zigbee_device_discovery <- function(id,
                                               body,
                                               bridge = NULL,
                                               tidy = TRUE) {
  hue_resource_put(
    "zigbee_device_discovery",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}
