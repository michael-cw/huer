#' MotionAware and Motion Area Endpoints (Hue Bridge Pro)
#'
#' Manage and read virtual motion sensing areas introduced with the Philips Hue
#' Bridge Pro MotionAware feature, including motion area configurations
#' (`/clip/v2/resource/motion_area_configuration`), eligible room/zone
#' candidates (`/clip/v2/resource/motion_area_candidate`), convenience area
#' motion states (`/clip/v2/resource/convenience_area_motion`), and security
#' area motion states (`/clip/v2/resource/security_area_motion`).
#'
#' @details
#' Supported CLIP API v2 / Bridge Pro endpoints:
#' * `GET /clip/v2/resource/motion_area_configuration` —
#'   [hue_get_motion_area_configurations()]
#' * `GET /clip/v2/resource/motion_area_configuration/{id}` —
#'   [hue_get_motion_area_configuration()]
#' * `POST /clip/v2/resource/motion_area_configuration` —
#'   [hue_create_motion_area_configuration()]
#' * `PUT /clip/v2/resource/motion_area_configuration/{id}` —
#'   [hue_update_motion_area_configuration()]
#' * `DELETE /clip/v2/resource/motion_area_configuration/{id}` —
#'   [hue_delete_motion_area_configuration()]
#' * `GET /clip/v2/resource/motion_area_candidate` —
#'   [hue_get_motion_area_candidates()]
#' * `GET /clip/v2/resource/motion_area_candidate/{id}` —
#'   [hue_get_motion_area_candidate()]
#' * `GET /clip/v2/resource/convenience_area_motion` —
#'   [hue_get_convenience_area_motions()]
#' * `GET /clip/v2/resource/convenience_area_motion/{id}` —
#'   [hue_get_convenience_area_motion()]
#' * `PUT /clip/v2/resource/convenience_area_motion/{id}` —
#'   [hue_update_convenience_area_motion()]
#' * `GET /clip/v2/resource/security_area_motion` —
#'   [hue_get_security_area_motions()]
#' * `GET /clip/v2/resource/security_area_motion/{id}` —
#'   [hue_get_security_area_motion()]
#' * `PUT /clip/v2/resource/security_area_motion/{id}` —
#'   [hue_update_security_area_motion()]
#'
#' @param id Character scalar. UUID of the motion area resource.
#' @param body Named list representing the CLIP API v2 JSON payload.
#' @inheritParams hue_resources
#'
#' @return A `tbl_json` tibble (or list when `tidy = FALSE`) containing the
#'   bridge response `data` array.
#' @seealso [hue_sensors], [hue_eventstream()]
#' @name hue_motion_areas
NULL

#' @rdname hue_motion_areas
#' @export
#' @examples
#' \dontrun{
#' # Inspect MotionAware configurations and live convenience/security motion
#' configs <- hue_get_motion_area_configurations()
#' candidates <- hue_get_motion_area_candidates()
#' convenience <- hue_get_convenience_area_motions()
#' security <- hue_get_security_area_motions()
#' }
hue_get_motion_area_configurations <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("motion_area_configuration", bridge = bridge, tidy = tidy)
}

#' @rdname hue_motion_areas
#' @export
hue_get_motion_area_configuration <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get(
    "motion_area_configuration",
    id = id,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_motion_areas
#' @export
hue_create_motion_area_configuration <- function(body,
                                                 bridge = NULL,
                                                 tidy = TRUE) {
  hue_resource_post(
    "motion_area_configuration",
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_motion_areas
#' @export
hue_update_motion_area_configuration <- function(id,
                                                 body,
                                                 bridge = NULL,
                                                 tidy = TRUE) {
  hue_resource_put(
    "motion_area_configuration",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_motion_areas
#' @export
hue_delete_motion_area_configuration <- function(id,
                                                 bridge = NULL,
                                                 tidy = TRUE) {
  hue_resource_delete(
    "motion_area_configuration",
    id = id,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_motion_areas
#' @export
hue_get_motion_area_candidates <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("motion_area_candidate", bridge = bridge, tidy = tidy)
}

#' @rdname hue_motion_areas
#' @export
hue_get_motion_area_candidate <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get(
    "motion_area_candidate",
    id = id,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_motion_areas
#' @export
hue_get_convenience_area_motions <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("convenience_area_motion", bridge = bridge, tidy = tidy)
}

#' @rdname hue_motion_areas
#' @export
hue_get_convenience_area_motion <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get(
    "convenience_area_motion",
    id = id,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_motion_areas
#' @export
hue_update_convenience_area_motion <- function(id,
                                               body,
                                               bridge = NULL,
                                               tidy = TRUE) {
  hue_resource_put(
    "convenience_area_motion",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_motion_areas
#' @export
hue_get_security_area_motions <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("security_area_motion", bridge = bridge, tidy = tidy)
}

#' @rdname hue_motion_areas
#' @export
hue_get_security_area_motion <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get(
    "security_area_motion",
    id = id,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_motion_areas
#' @export
hue_update_security_area_motion <- function(id,
                                            body,
                                            bridge = NULL,
                                            tidy = TRUE) {
  hue_resource_put(
    "security_area_motion",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}
