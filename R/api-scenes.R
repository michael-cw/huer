#' Scene and Smart Scene Endpoints
#'
#' Manage and recall static/dynamic scenes (`/clip/v2/resource/scene`) and
#' time-based all-day smart scenes (`/clip/v2/resource/smart_scene`) on a
#' Philips Hue Bridge v2 or Bridge Pro.
#'
#' @details
#' Supported CLIP API v2 endpoints:
#' * `GET /clip/v2/resource/scene` — [hue_get_scenes()]
#' * `GET /clip/v2/resource/scene/{id}` — [hue_get_scene()]
#' * `POST /clip/v2/resource/scene` — [hue_create_scene()]
#' * `PUT /clip/v2/resource/scene/{id}` — [hue_update_scene()], [hue_recall_scene()]
#' * `DELETE /clip/v2/resource/scene/{id}` — [hue_delete_scene()]
#' * `GET /clip/v2/resource/smart_scene` — [hue_get_smart_scenes()]
#' * `GET /clip/v2/resource/smart_scene/{id}` — [hue_get_smart_scene()]
#' * `POST /clip/v2/resource/smart_scene` — [hue_create_smart_scene()]
#' * `PUT /clip/v2/resource/smart_scene/{id}` — [hue_update_smart_scene()],
#'   [hue_recall_smart_scene()]
#' * `DELETE /clip/v2/resource/smart_scene/{id}` — [hue_delete_smart_scene()]
#'
#' @param id Character scalar. UUID of the scene or smart scene resource.
#' @param body Named list representing the CLIP API v2 JSON payload.
#' @param action Character scalar recall action. For [hue_recall_scene()], one
#'   of `"active"`, `"dynamic_palette"`, or `"static"`. For
#'   [hue_recall_smart_scene()], one of `"activate"` or `"deactivate"`.
#' @param duration Optional non-negative integer transition duration in
#'   milliseconds for [hue_recall_scene()].
#' @param brightness Optional numeric scalar in `[0, 100]` overriding scene
#'   dimming brightness during recall.
#' @inheritParams hue_resources
#'
#' @return A `tibble` (or list when `tidy = FALSE`) containing the
#'   bridge response `data` array.
#' @seealso [hue_get_rooms()], [hue_get_zones()], [hue_get_lights()]
#' @name hue_scenes
NULL

#' @rdname hue_scenes
#' @export
#' @examples
#' \dontrun{
#' scenes <- hue_get_scenes()
#' hue_recall_scene(scenes$id[[1]], action = "active", duration = 500)
#' }
hue_get_scenes <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("scene", bridge = bridge, tidy = tidy)
}

#' @rdname hue_scenes
#' @export
hue_get_scene <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("scene", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_scenes
#' @export
hue_create_scene <- function(body, bridge = NULL, tidy = TRUE) {
  hue_resource_post("scene", body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_scenes
#' @export
hue_update_scene <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put("scene", id = id, body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_scenes
#' @export
hue_delete_scene <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_delete("scene", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_scenes
#' @export
hue_recall_scene <- function(id,
                             action = c("active", "dynamic_palette", "static"),
                             duration = NULL,
                             brightness = NULL,
                             bridge = NULL,
                             tidy = TRUE) {
  action <- match.arg(action)
  recall <- list(action = action)

  if (!is.null(duration)) {
    if (!is.numeric(duration) || length(duration) != 1L || is.na(duration) ||
        duration < 0) {
      cli::cli_abort("{.arg duration} must be a non-negative integer (milliseconds).")
    }
    recall$duration <- as.integer(round(duration))
  }

  if (!is.null(brightness)) {
    if (!is.numeric(brightness) || length(brightness) != 1L ||
        is.na(brightness) || brightness < 0 || brightness > 100) {
      cli::cli_abort("{.arg brightness} must be a single number between 0 and 100.")
    }
    recall$dimming <- list(brightness = as.numeric(brightness))
  }

  hue_update_scene(
    id = id,
    body = list(recall = recall),
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_scenes
#' @export
hue_get_smart_scenes <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("smart_scene", bridge = bridge, tidy = tidy)
}

#' @rdname hue_scenes
#' @export
hue_get_smart_scene <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("smart_scene", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_scenes
#' @export
hue_create_smart_scene <- function(body, bridge = NULL, tidy = TRUE) {
  hue_resource_post("smart_scene", body = body, bridge = bridge, tidy = tidy)
}

#' @rdname hue_scenes
#' @export
hue_update_smart_scene <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put(
    "smart_scene",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_scenes
#' @export
hue_delete_smart_scene <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_delete("smart_scene", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_scenes
#' @export
hue_recall_smart_scene <- function(id,
                                   action = c("activate", "deactivate"),
                                   bridge = NULL,
                                   tidy = TRUE) {
  action <- match.arg(action)
  hue_update_smart_scene(
    id = id,
    body = list(recall = list(action = action)),
    bridge = bridge,
    tidy = tidy
  )
}
