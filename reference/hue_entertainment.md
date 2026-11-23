# Entertainment and Speaker Endpoints

Query and configure Hue Entertainment streaming capabilities
(`/clip/v2/resource/entertainment`), Entertainment area layouts
(`/clip/v2/resource/entertainment_configuration`), and audio/chime
speaker resources (`/clip/v2/resource/speaker`) on a Philips Hue Bridge
v2 or Bridge Pro.

## Usage

``` r
hue_get_entertainments(bridge = NULL, tidy = TRUE)

hue_get_entertainment(id, bridge = NULL, tidy = TRUE)

hue_get_entertainment_configurations(bridge = NULL, tidy = TRUE)

hue_get_entertainment_configuration(id, bridge = NULL, tidy = TRUE)

hue_create_entertainment_configuration(body, bridge = NULL, tidy = TRUE)

hue_update_entertainment_configuration(id, body, bridge = NULL, tidy = TRUE)

hue_delete_entertainment_configuration(id, bridge = NULL, tidy = TRUE)

hue_get_speakers(bridge = NULL, tidy = TRUE)

hue_get_speaker(id, bridge = NULL, tidy = TRUE)

hue_update_speaker(id, body, bridge = NULL, tidy = TRUE)
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

  Character scalar. UUID of the entertainment, entertainment
  configuration, or speaker resource.

- body:

  Named list representing the CLIP API v2 JSON payload.

## Value

A `tibble` (or list when `tidy = FALSE`) containing the bridge response
`data` array.

## Details

Supported CLIP API v2 endpoints:

- `GET /clip/v2/resource/entertainment` — `hue_get_entertainments()`

- `GET /clip/v2/resource/entertainment/{id}` — `hue_get_entertainment()`

- `GET /clip/v2/resource/entertainment_configuration` —
  `hue_get_entertainment_configurations()`

- `GET /clip/v2/resource/entertainment_configuration/{id}` —
  `hue_get_entertainment_configuration()`

- `POST /clip/v2/resource/entertainment_configuration` —
  `hue_create_entertainment_configuration()`

- `PUT /clip/v2/resource/entertainment_configuration/{id}` —
  `hue_update_entertainment_configuration()`

- `DELETE /clip/v2/resource/entertainment_configuration/{id}` —
  `hue_delete_entertainment_configuration()`

- `GET /clip/v2/resource/speaker` — `hue_get_speakers()`

- `GET /clip/v2/resource/speaker/{id}` — `hue_get_speaker()`

- `PUT /clip/v2/resource/speaker/{id}` — `hue_update_speaker()`

## See also

[`hue_get_application_id()`](https://michael-cw.github.io/huer/reference/hue_get_application_id.md),
[`hue_get_bell_buttons()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)

## Examples

``` r
if (FALSE) { # \dontrun{
configs <- hue_get_entertainment_configurations()
speakers <- hue_get_speakers()
} # }
```
