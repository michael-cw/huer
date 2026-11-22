# Scene and Smart Scene Endpoints

Manage and recall static/dynamic scenes (`/clip/v2/resource/scene`) and
time-based all-day smart scenes (`/clip/v2/resource/smart_scene`) on a
Philips Hue Bridge v2 or Bridge Pro.

## Usage

``` r
hue_get_scenes(bridge = NULL, tidy = TRUE)

hue_get_scene(id, bridge = NULL, tidy = TRUE)

hue_create_scene(body, bridge = NULL, tidy = TRUE)

hue_update_scene(id, body, bridge = NULL, tidy = TRUE)

hue_delete_scene(id, bridge = NULL, tidy = TRUE)

hue_recall_scene(
  id,
  action = c("active", "dynamic_palette", "static"),
  duration = NULL,
  brightness = NULL,
  bridge = NULL,
  tidy = TRUE
)

hue_get_smart_scenes(bridge = NULL, tidy = TRUE)

hue_get_smart_scene(id, bridge = NULL, tidy = TRUE)

hue_create_smart_scene(body, bridge = NULL, tidy = TRUE)

hue_update_smart_scene(id, body, bridge = NULL, tidy = TRUE)

hue_delete_smart_scene(id, bridge = NULL, tidy = TRUE)

hue_recall_smart_scene(
  id,
  action = c("activate", "deactivate"),
  bridge = NULL,
  tidy = TRUE
)
```

## Arguments

- bridge:

  Optional `hue_bridge` object created by
  [`hue_bridge()`](https://michael-cw.github.io/huer/reference/hue_bridge.md).
  If `NULL`, resolves from session defaults set by
  [`hue_auth()`](https://michael-cw.github.io/huer/reference/hue_auth.md)
  or environment variables.

- tidy:

  Logical scalar. If `TRUE` (default), returns a `tbl_json` tibble
  parsed via `tidyjson`. If `FALSE`, returns the raw parsed R list.

- id:

  Character scalar. UUID of the scene or smart scene resource.

- body:

  Named list representing the CLIP API v2 JSON payload.

- action:

  Character scalar recall action. For `hue_recall_scene()`, one of
  `"active"`, `"dynamic_palette"`, or `"static"`. For
  `hue_recall_smart_scene()`, one of `"activate"` or `"deactivate"`.

- duration:

  Optional non-negative integer transition duration in milliseconds for
  `hue_recall_scene()`.

- brightness:

  Optional numeric scalar in `[0, 100]` overriding scene dimming
  brightness during recall.

## Value

A `tbl_json` tibble (or list when `tidy = FALSE`) containing the bridge
response `data` array.

## Details

Supported CLIP API v2 endpoints:

- `GET /clip/v2/resource/scene` — `hue_get_scenes()`

- `GET /clip/v2/resource/scene/{id}` — `hue_get_scene()`

- `POST /clip/v2/resource/scene` — `hue_create_scene()`

- `PUT /clip/v2/resource/scene/{id}` — `hue_update_scene()`,
  `hue_recall_scene()`

- `DELETE /clip/v2/resource/scene/{id}` — `hue_delete_scene()`

- `GET /clip/v2/resource/smart_scene` — `hue_get_smart_scenes()`

- `GET /clip/v2/resource/smart_scene/{id}` — `hue_get_smart_scene()`

- `POST /clip/v2/resource/smart_scene` — `hue_create_smart_scene()`

- `PUT /clip/v2/resource/smart_scene/{id}` — `hue_update_smart_scene()`,
  `hue_recall_smart_scene()`

- `DELETE /clip/v2/resource/smart_scene/{id}` —
  `hue_delete_smart_scene()`

## See also

[`hue_get_rooms()`](https://michael-cw.github.io/huer/reference/hue_groups.md),
[`hue_get_zones()`](https://michael-cw.github.io/huer/reference/hue_groups.md),
[`hue_get_lights()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)

## Examples

``` r
if (FALSE) { # \dontrun{
scenes <- hue_get_scenes()
hue_recall_scene(scenes$id[[1]], action = "active", duration = 500)
} # }
```
