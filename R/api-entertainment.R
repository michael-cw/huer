#' Entertainment and Speaker Endpoints
#'
#' Query and configure Hue Entertainment streaming capabilities
#' (`/clip/v2/resource/entertainment`), Entertainment area layouts
#' (`/clip/v2/resource/entertainment_configuration`), and audio/chime speaker
#' resources (`/clip/v2/resource/speaker`) on a Philips Hue Bridge v2 or
#' Bridge Pro.
#'
#' @details
#' Supported CLIP API v2 endpoints:
#' * `GET /clip/v2/resource/entertainment` — [hue_get_entertainments()]
#' * `GET /clip/v2/resource/entertainment/{id}` — [hue_get_entertainment()]
#' * `GET /clip/v2/resource/entertainment_configuration` —
#'   [hue_get_entertainment_configurations()]
#' * `GET /clip/v2/resource/entertainment_configuration/{id}` —
#'   [hue_get_entertainment_configuration()]
#' * `POST /clip/v2/resource/entertainment_configuration` —
#'   [hue_create_entertainment_configuration()]
#' * `PUT /clip/v2/resource/entertainment_configuration/{id}` —
#'   [hue_update_entertainment_configuration()]
#' * `DELETE /clip/v2/resource/entertainment_configuration/{id}` —
#'   [hue_delete_entertainment_configuration()]
#' * `GET /clip/v2/resource/speaker` — [hue_get_speakers()]
#' * `GET /clip/v2/resource/speaker/{id}` — [hue_get_speaker()]
#' * `PUT /clip/v2/resource/speaker/{id}` — [hue_update_speaker()]
#'
#' @param id Character scalar. UUID of the entertainment, entertainment
#'   configuration, or speaker resource.
#' @param body Named list representing the CLIP API v2 JSON payload.
#' @inheritParams hue_resources
#'
#' @return A `tibble` (or list when `tidy = FALSE`) containing the
#'   bridge response `data` array.
#' @seealso [hue_get_application_id()], [hue_get_bell_buttons()]
#' @name hue_entertainment
NULL

#' @rdname hue_entertainment
#' @export
#' @examples
#' \dontrun{
#' configs <- hue_get_entertainment_configurations()
#' speakers <- hue_get_speakers()
#' }
hue_get_entertainments <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("entertainment", bridge = bridge, tidy = tidy)
}

#' @rdname hue_entertainment
#' @export
hue_get_entertainment <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("entertainment", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_entertainment
#' @export
hue_get_entertainment_configurations <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("entertainment_configuration", bridge = bridge, tidy = tidy)
}

#' @rdname hue_entertainment
#' @export
hue_get_entertainment_configuration <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get(
    "entertainment_configuration",
    id = id,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_entertainment
#' @export
hue_create_entertainment_configuration <- function(body,
                                                   bridge = NULL,
                                                   tidy = TRUE) {
  hue_resource_post(
    "entertainment_configuration",
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_entertainment
#' @export
hue_update_entertainment_configuration <- function(id,
                                                   body,
                                                   bridge = NULL,
                                                   tidy = TRUE) {
  hue_resource_put(
    "entertainment_configuration",
    id = id,
    body = body,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_entertainment
#' @export
hue_delete_entertainment_configuration <- function(id,
                                                   bridge = NULL,
                                                   tidy = TRUE) {
  hue_resource_delete(
    "entertainment_configuration",
    id = id,
    bridge = bridge,
    tidy = tidy
  )
}

#' @rdname hue_entertainment
#' @export
hue_get_speakers <- function(bridge = NULL, tidy = TRUE) {
  hue_resource_get("speaker", bridge = bridge, tidy = tidy)
}

#' @rdname hue_entertainment
#' @export
hue_get_speaker <- function(id, bridge = NULL, tidy = TRUE) {
  hue_resource_get("speaker", id = id, bridge = bridge, tidy = tidy)
}

#' @rdname hue_entertainment
#' @export
hue_update_speaker <- function(id, body, bridge = NULL, tidy = TRUE) {
  hue_resource_put("speaker", id = id, body = body, bridge = bridge, tidy = tidy)
}
