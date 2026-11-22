#' List All Supported Philips Hue CLIP API v2 and Bridge Pro Endpoints
#'
#' Returns a reference `tibble` documenting every resource type exposed by the
#' Philips Hue Bridge v2 and Bridge Pro CLIP API v2 under `/clip/v2/resource/`,
#' including its functional category, whether it was introduced for Bridge Pro
#' or Hue Secure features, and which HTTP verbs (`GET`, `POST`, `PUT`,
#' `DELETE`) are supported.
#'
#' @return A `tibble` with columns `resource`, `category`, `path`, `get`,
#'   `post`, `put`, `delete`, and `bridge_pro`.
#' @seealso [hue_get_resources()], [hue_resource_get()], [hue_resource_post()],
#'   [hue_resource_put()], [hue_resource_delete()]
#' @export
#' @examples
#' ep <- hue_endpoints()
#' ep
#' ep[ep$bridge_pro, ]
hue_endpoints <- function() {
  specs <- list(
    # Lighting & Control
    list("light", "lighting", TRUE, FALSE, TRUE, FALSE, FALSE),
    list("grouped_light", "lighting", TRUE, FALSE, TRUE, FALSE, FALSE),
    # Rooms, Zones & Home Architecture
    list("room", "groups", TRUE, TRUE, TRUE, TRUE, FALSE),
    list("zone", "groups", TRUE, TRUE, TRUE, TRUE, FALSE),
    list("bridge_home", "groups", TRUE, FALSE, TRUE, FALSE, FALSE),
    list("service_group", "groups", TRUE, TRUE, TRUE, TRUE, TRUE),
    # Scenes & Smart Scenes
    list("scene", "scenes", TRUE, TRUE, TRUE, TRUE, FALSE),
    list("smart_scene", "scenes", TRUE, TRUE, TRUE, TRUE, FALSE),
    # Devices, Power, Firmware & Bridge
    list("device", "devices", TRUE, FALSE, TRUE, TRUE, FALSE),
    list("device_power", "devices", TRUE, FALSE, FALSE, FALSE, FALSE),
    list("device_software_update", "devices", TRUE, FALSE, TRUE, FALSE, FALSE),
    list("bridge", "devices", TRUE, FALSE, TRUE, FALSE, FALSE),
    # Sensors & Physical Controls
    list("motion", "sensors", TRUE, FALSE, TRUE, FALSE, FALSE),
    list("grouped_motion", "sensors", TRUE, FALSE, TRUE, FALSE, FALSE),
    list("camera_motion", "sensors", TRUE, FALSE, TRUE, FALSE, TRUE),
    list("temperature", "sensors", TRUE, FALSE, TRUE, FALSE, FALSE),
    list("light_level", "sensors", TRUE, FALSE, TRUE, FALSE, FALSE),
    list("grouped_light_level", "sensors", TRUE, FALSE, TRUE, FALSE, FALSE),
    list("button", "sensors", TRUE, FALSE, FALSE, FALSE, FALSE),
    list("bell_button", "sensors", TRUE, FALSE, FALSE, FALSE, TRUE),
    list("relative_rotary", "sensors", TRUE, FALSE, FALSE, FALSE, FALSE),
    list("contact", "sensors", TRUE, FALSE, TRUE, FALSE, TRUE),
    list("tamper", "sensors", TRUE, FALSE, TRUE, FALSE, TRUE),
    # MotionAware & Motion Areas (Hue Bridge Pro)
    list("motion_area_configuration", "motion_areas", TRUE, TRUE, TRUE, TRUE, TRUE),
    list("motion_area_candidate", "motion_areas", TRUE, FALSE, FALSE, FALSE, TRUE),
    list("convenience_area_motion", "motion_areas", TRUE, FALSE, TRUE, FALSE, TRUE),
    list("security_area_motion", "motion_areas", TRUE, FALSE, TRUE, FALSE, TRUE),
    # Connectivity & Discovery
    list("zigbee_connectivity", "connectivity", TRUE, FALSE, FALSE, FALSE, FALSE),
    list("zgp_connectivity", "connectivity", TRUE, FALSE, FALSE, FALSE, FALSE),
    list("wifi_connectivity", "connectivity", TRUE, FALSE, TRUE, FALSE, TRUE),
    list("zigbee_device_discovery", "connectivity", TRUE, FALSE, TRUE, FALSE, FALSE),
    # Entertainment & Audio
    list("entertainment", "entertainment", TRUE, FALSE, FALSE, FALSE, FALSE),
    list("entertainment_configuration", "entertainment", TRUE, TRUE, TRUE, TRUE, FALSE),
    list("speaker", "entertainment", TRUE, FALSE, TRUE, FALSE, TRUE),
    # Automation, Geofencing & Ecosystem
    list("behavior_script", "automation", TRUE, FALSE, FALSE, FALSE, FALSE),
    list("behavior_instance", "automation", TRUE, TRUE, TRUE, TRUE, FALSE),
    list("geofence_client", "automation", TRUE, TRUE, TRUE, TRUE, FALSE),
    list("geolocation", "automation", TRUE, FALSE, TRUE, FALSE, FALSE),
    list("homekit", "automation", TRUE, FALSE, TRUE, FALSE, FALSE),
    list("matter", "automation", TRUE, FALSE, TRUE, FALSE, FALSE),
    list("matter_fabric", "automation", TRUE, FALSE, FALSE, TRUE, FALSE)
  )

  tibble::tibble(
    resource = vapply(specs, `[[`, character(1L), 1L),
    category = vapply(specs, `[[`, character(1L), 2L),
    path = paste0("/clip/v2/resource/", vapply(specs, `[[`, character(1L), 1L)),
    get = vapply(specs, `[[`, logical(1L), 3L),
    post = vapply(specs, `[[`, logical(1L), 4L),
    put = vapply(specs, `[[`, logical(1L), 5L),
    delete = vapply(specs, `[[`, logical(1L), 6L),
    bridge_pro = vapply(specs, `[[`, logical(1L), 7L)
  )
}

#' Generic CLIP API v2 Resource Operations
#'
#' Low-level CRUD functions covering the root `GET /clip/v2/resource` endpoint
#' and any `/clip/v2/resource/{resource}` or
#' `/clip/v2/resource/{resource}/{id}` endpoint on a Philips Hue Bridge v2 or
#' Bridge Pro.
#'
#' @param resource Character scalar. CLIP API v2 resource type name (see
#'   [hue_endpoints()] for all 41 built-in resource types).
#' @param id Character scalar. UUID of a specific resource item. For
#'   `hue_resource_get()`, omit or pass `NULL` to list all resources of that
#'   type.
#' @param body Named list representing the JSON payload for `POST` or `PUT`.
#' @param bridge Optional `hue_bridge` object created by [hue_bridge()]. If
#'   `NULL`, resolves from session defaults set by [hue_auth()] or environment
#'   variables.
#' @param tidy Logical scalar. If `TRUE` (default), returns a `tbl_json` tibble
#'   parsed via `tidyjson`. If `FALSE`, returns the raw parsed R list.
#'
#' @return A `tbl_json` tibble (or list when `tidy = FALSE`) representing the
#'   bridge response `data` array.
#' @seealso [hue_endpoints()], [hue_parse_response()]
#' @name hue_resources
NULL

#' @rdname hue_resources
#' @export
#' @examples
#' \dontrun{
#' # Retrieve all resources exposed by the Hue Bridge
#' all_res <- hue_get_resources()
#' }
hue_get_resources <- function(bridge = NULL, tidy = TRUE) {
  bridge <- resolve_bridge(bridge)
  hue_perform(
    bridge = bridge,
    path = "/clip/v2/resource",
    method = "GET",
    tidy = tidy
  )
}

#' @rdname hue_resources
#' @export
hue_resource_get <- function(resource, id = NULL, bridge = NULL, tidy = TRUE) {
  validate_scalar_chr(resource, "resource")
  bridge <- resolve_bridge(bridge)

  path <- paste0("/clip/v2/resource/", resource)
  if (!is.null(id)) {
    validate_scalar_chr(id, "id")
    path <- paste0(path, "/", id)
  }

  hue_perform(bridge = bridge, path = path, method = "GET", tidy = tidy)
}

#' @rdname hue_resources
#' @export
hue_resource_post <- function(resource, body, bridge = NULL, tidy = TRUE) {
  validate_scalar_chr(resource, "resource")
  validate_body(body)
  bridge <- resolve_bridge(bridge)

  path <- paste0("/clip/v2/resource/", resource)
  hue_perform(
    bridge = bridge,
    path = path,
    method = "POST",
    body = body,
    tidy = tidy
  )
}

#' @rdname hue_resources
#' @export
hue_resource_put <- function(resource, id, body, bridge = NULL, tidy = TRUE) {
  validate_scalar_chr(resource, "resource")
  validate_scalar_chr(id, "id")
  validate_body(body)
  bridge <- resolve_bridge(bridge)

  path <- paste0("/clip/v2/resource/", resource, "/", id)
  hue_perform(
    bridge = bridge,
    path = path,
    method = "PUT",
    body = body,
    tidy = tidy
  )
}

#' @rdname hue_resources
#' @export
hue_resource_delete <- function(resource, id, bridge = NULL, tidy = TRUE) {
  validate_scalar_chr(resource, "resource")
  validate_scalar_chr(id, "id")
  bridge <- resolve_bridge(bridge)

  path <- paste0("/clip/v2/resource/", resource, "/", id)
  hue_perform(bridge = bridge, path = path, method = "DELETE", tidy = tidy)
}
