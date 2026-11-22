#' Automation, Geofencing, HomeKit, and Matter Endpoints
#'
#' Manage automation scripts (`/clip/v2/resource/behavior_script`), active
#' behavior instances (`/clip/v2/resource/behavior_instance`), geofence clients
#' (`/clip/v2/resource/geofence_client`), bridge geolocation
#' (`/clip/v2/resource/geolocation`), Apple HomeKit
#' (`/clip/v2/resource/homekit`), Matter configuration
#' (`/clip/v2/resource/matter`), and Matter fabrics
#' (`/clip/v2/resource/matter_fabric`).
#'
#' @details
#' Supported CLIP API v2 endpoints:
#' * `GET /clip/v2/resource/behavior_script` — [hue_get_behavior_scripts()]
#' * `GET /clip/v2/resource/behavior_script/{id}` — [hue_get_behavior_script()]
#' * `GET /clip/v2/resource/behavior_instance` — [hue_get_behavior_instances()]
#' * `GET /clip/v2/resource/behavior_instance/{id}` — [hue_get_behavior_instance()]
#' * `POST /clip/v2/resource/behavior_instance` — [hue_create_behavior_instance()]
#' * `PUT /clip/v2/resource/behavior_instance/{id}` — [hue_update_behavior_instance()]
#' * `DELETE /clip/v2/resource/behavior_instance/{id}` — [hue_delete_behavior_instance()]
#' * `GET /clip/v2/resource/geofence_client` — [hue_get_geofence_clients()]
#' * `GET /clip/v2/resource/geofence_client/{id}` — [hue_get_geofence_client()]
#' * `POST /clip/v2/resource/geofence_client` — [hue_create_geofence_client()]
#' * `PUT /clip/v2/resource/geofence_client/{id}` — [hue_update_geofence_client()]
#' * `DELETE /clip/v2/resource/geofence_client/{id}` — [hue_delete_geofence_client()]
#' * `GET /clip/v2/resource/geolocation` — [hue_get_geolocations()]
#' * `GET /clip/v2/resource/geolocation/{id}` — [hue_get_geolocation()]
#' * `PUT /clip/v2/resource/geolocation/{id}` — [hue_update_geolocation()]
#' * `GET /clip/v2/resource/homekit` — [hue_get_homekits()]
#' * `GET /clip/v2/resource/homekit/{id}` — [hue_get_homekit()]
#' * `PUT /clip/v2/resource/homekit/{id}` — [hue_update_homekit()]
#' * `GET /clip/v2/resource/matter` — [hue_get_matters()]
#' * `GET /clip/v2/resource/matter/{id}` — [hue_get_matter()]
#' * `PUT /clip/v2/resource/matter/{id}` — [hue_update_matter()]
#' * `GET /clip/v2/resource/matter_fabric` — [hue_get_matter_fabrics()]
#' * `GET /clip/v2/resource/matter_fabric/{id}` — [hue_get_matter_fabric()]
#' * `DELETE /clip/v2/resource/matter_fabric/{id}` — [hue_delete_matter_fabric()]
#'
#' @param id Character scalar. UUID of the automation, geofence, geolocation,
#'   HomeKit, or Matter resource.
#' @param body Named list representing the CLIP API v2 JSON payload.
#' @inheritParams hue_resources
#'
#' @return A `tbl_json` tibble (or list when `tidy = FALSE`) containing the
#'   bridge response `data` array.
#' @seealso [hue_endpoints()], [hue_resources]
#' @name hue_automation
NULL

#' @rdname hue_automation
#' @export
#' @examples
#' \dontrun{
#' scripts <- hue_get_behavior_scripts()
#' instances <- hue_get_behavior_instances()
#' fabrics <- hue_get_matter_fabrics()
#' }
hue_get_behavior_scripts <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("behavior_script", bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_get_behavior_script <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("behavior_script", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_get_behavior_instances <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("behavior_instance", bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_get_behavior_instance <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("behavior_instance", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_create_behavior_instance <- function(body, bridge = NULL, tidy = TRUE) {
  hue_resource_post(
    "behavior_instance",
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_automation
#' @export
hue_update_behavior_instance <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "behavior_instance",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_automation
#' @export
hue_delete_behavior_instance <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_delete("behavior_instance", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_get_geofence_clients <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("geofence_client", bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_get_geofence_client <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("geofence_client", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_create_geofence_client <- function(body, bridge = NULL, tidy = TRUE) {
  hue_resource_post(
    "geofence_client",
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_automation
#' @export
hue_update_geofence_client <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "geofence_client",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_automation
#' @export
hue_delete_geofence_client <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_delete("geofence_client", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_get_geolocations <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("geolocation", bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_get_geolocation <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("geolocation", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_update_geolocation <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "geolocation",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_automation
#' @export
hue_get_homekits <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("homekit", bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_get_homekit <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("homekit", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_update_homekit <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put("homekit", id = id, body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_get_matters <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("matter", bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_get_matter <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("matter", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_update_matter <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put("matter", id = id, body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_get_matter_fabrics <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("matter_fabric", bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_get_matter_fabric <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("matter_fabric", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_automation
#' @export
hue_delete_matter_fabric <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_delete("matter_fabric", id = id, bridge = bridge, tidy = tidy)
}
