#' Rooms, Zones, Bridge Home, and Service Group Endpoints
#'
#' Manage structural groupings on a Philips Hue Bridge v2 or Bridge Pro,
#' including rooms (`/clip/v2/resource/room`), zones
#' (`/clip/v2/resource/zone`), top-level bridge home containers
#' (`/clip/v2/resource/bridge_home`), and Bridge Pro service groups
#' (`/clip/v2/resource/service_group`).
#'
#' @details
#' Supported CLIP API v2 endpoints:
#' * `GET /clip/v2/resource/room` — [hue_get_rooms()]
#' * `GET /clip/v2/resource/room/{id}` — [hue_get_room()]
#' * `POST /clip/v2/resource/room` — [hue_create_room()]
#' * `PUT /clip/v2/resource/room/{id}` — [hue_update_room()]
#' * `DELETE /clip/v2/resource/room/{id}` — [hue_delete_room()]
#' * `GET /clip/v2/resource/zone` — [hue_get_zones()]
#' * `GET /clip/v2/resource/zone/{id}` — [hue_get_zone()]
#' * `POST /clip/v2/resource/zone` — [hue_create_zone()]
#' * `PUT /clip/v2/resource/zone/{id}` — [hue_update_zone()]
#' * `DELETE /clip/v2/resource/zone/{id}` — [hue_delete_zone()]
#' * `GET /clip/v2/resource/bridge_home` — [hue_get_bridge_homes()]
#' * `GET /clip/v2/resource/bridge_home/{id}` — [hue_get_bridge_home()]
#' * `PUT /clip/v2/resource/bridge_home/{id}` — [hue_update_bridge_home()]
#' * `GET /clip/v2/resource/service_group` — [hue_get_service_groups()]
#' * `GET /clip/v2/resource/service_group/{id}` — [hue_get_service_group()]
#' * `POST /clip/v2/resource/service_group` — [hue_create_service_group()]
#' * `PUT /clip/v2/resource/service_group/{id}` — [hue_update_service_group()]
#' * `DELETE /clip/v2/resource/service_group/{id}` — [hue_delete_service_group()]
#'
#' @param id Character scalar. UUID of the room, zone, bridge home, or service
#'   group resource.
#' @param body Named list representing the CLIP API v2 JSON payload.
#' @inheritParams hue_resources
#'
#' @return A `tbl_json` tibble (or list when `tidy = FALSE`) containing the
#'   bridge response `data` array.
#' @seealso [hue_resource_identifier()], [hue_unnest_array()],
#'   [hue_get_grouped_lights()]
#' @name hue_groups
NULL

#' @rdname hue_groups
#' @export
#' @examples
#' \dontrun{
#' rooms <- hue_get_rooms()
#' new_room <- hue_create_room(list(
#'   metadata = list(name = "Studio", archetype = "office"),
#'   children = list(hue_resource_identifier("device-uuid", "device"))
#' ))
#' }
hue_get_rooms <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("room", bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_get_room <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("room", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_create_room <- function(body, bridge = NULL, tidy = TRUE) {
  hue_resource_post("room", body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_update_room <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put("room", id = id, body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_delete_room <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_delete("room", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_get_zones <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("zone", bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_get_zone <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("zone", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_create_zone <- function(body, bridge = NULL, tidy = TRUE) {
  hue_resource_post("zone", body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_update_zone <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put("zone", id = id, body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_delete_zone <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_delete("zone", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_get_bridge_homes <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("bridge_home", bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_get_bridge_home <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("bridge_home", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_update_bridge_home <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "bridge_home",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_groups
#' @export
hue_get_service_groups <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("service_group", bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_get_service_group <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("service_group", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_create_service_group <- function(body, bridge = NULL, tidy = TRUE) {
  hue_resource_post("service_group", body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_groups
#' @export
hue_update_service_group <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "service_group",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_groups
#' @export
hue_delete_service_group <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_delete("service_group", id = id, bridge = bridge, tidy = tidy)
}
