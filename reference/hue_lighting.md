# Light and Grouped Light Endpoints

Interact with individual lights (`/clip/v2/resource/light`) and grouped
lighting services (`/clip/v2/resource/grouped_light`) on a Philips Hue
Bridge v2 or Bridge Pro.

## Usage

``` r
hue_get_lights(bridge = NULL, tidy = TRUE)

hue_get_light(id, bridge = NULL, tidy = TRUE)

hue_update_light(id, body, bridge = NULL, tidy = TRUE)

hue_get_grouped_lights(bridge = NULL, tidy = TRUE)

hue_get_grouped_light(id, bridge = NULL, tidy = TRUE)

hue_update_grouped_light(id, body, bridge = NULL, tidy = TRUE)
```

## Arguments

- bridge:

  Optional `hue_bridge` object created by
  [`hue_bridge()`](https://michael-cw.github.io/huer/reference/hue_bridge.md).
  If `NULL`, resolves from session defaults set by
  [`hue_auth()`](https://michael-cw.github.io/huer/reference/hue_auth.md)
  or environment variables.

- tidy:

  Logical scalar. If `TRUE` (default), returns a `tibble` parsed via
  `jsonlite`. If `FALSE`, returns the raw parsed R list.

- id:

  Character scalar. UUID of the light or grouped light resource.

- body:

  Named list representing the CLIP API v2 JSON update payload (see
  [`hue_payload_light()`](https://michael-cw.github.io/huer/reference/hue_payload_light.md)).

## Value

A `tibble` (or list when `tidy = FALSE`) containing the bridge response
`data` array.

## Details

Supported CLIP API v2 endpoints:

- `GET /clip/v2/resource/light` — `hue_get_lights()`

- `GET /clip/v2/resource/light/{id}` — `hue_get_light()`

- `PUT /clip/v2/resource/light/{id}` — `hue_update_light()`

- `GET /clip/v2/resource/grouped_light` — `hue_get_grouped_lights()`

- `GET /clip/v2/resource/grouped_light/{id}` — `hue_get_grouped_light()`

- `PUT /clip/v2/resource/grouped_light/{id}` —
  `hue_update_grouped_light()`

Use
[`hue_payload_light()`](https://michael-cw.github.io/huer/reference/hue_payload_light.md)
to build validated `body` lists for updating power, brightness, color
temperature (mirek), CIE xy chromaticity, effects, alerts, and
transition dynamics.

## See also

[`hue_payload_light()`](https://michael-cw.github.io/huer/reference/hue_payload_light.md),
[`hue_get_rooms()`](https://michael-cw.github.io/huer/reference/hue_groups.md),
[`hue_get_zones()`](https://michael-cw.github.io/huer/reference/hue_groups.md)

## Examples

``` r
if (FALSE) { # \dontrun{
lights <- hue_get_lights()
hue_update_light(
  id = lights$id[[1]],
  body = hue_payload_light(on = TRUE, brightness = 80, mirek = 300)
)
} # }
```
