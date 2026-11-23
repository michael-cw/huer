# Sensor and Physical Control Endpoints

Query and configure sensor and physical control resources on a Philips
Hue Bridge v2 or Bridge Pro, including motion, grouped motion, Hue
Secure camera motion, temperature, ambient light level, grouped light
level, buttons, doorbell buttons, rotary dials, contact sensors, and
tamper sensors.

## Usage

``` r
hue_get_motions(bridge = NULL, tidy = TRUE)

hue_get_motion(id, bridge = NULL, tidy = TRUE)

hue_update_motion(id, body, bridge = NULL, tidy = TRUE)

hue_get_grouped_motions(bridge = NULL, tidy = TRUE)

hue_get_grouped_motion(id, bridge = NULL, tidy = TRUE)

hue_update_grouped_motion(id, body, bridge = NULL, tidy = TRUE)

hue_get_camera_motions(bridge = NULL, tidy = TRUE)

hue_get_camera_motion(id, bridge = NULL, tidy = TRUE)

hue_update_camera_motion(id, body, bridge = NULL, tidy = TRUE)

hue_get_temperatures(bridge = NULL, tidy = TRUE)

hue_get_temperature(id, bridge = NULL, tidy = TRUE)

hue_update_temperature(id, body, bridge = NULL, tidy = TRUE)

hue_get_light_levels(bridge = NULL, tidy = TRUE)

hue_get_light_level(id, bridge = NULL, tidy = TRUE)

hue_update_light_level(id, body, bridge = NULL, tidy = TRUE)

hue_get_grouped_light_levels(bridge = NULL, tidy = TRUE)

hue_get_grouped_light_level(id, bridge = NULL, tidy = TRUE)

hue_update_grouped_light_level(id, body, bridge = NULL, tidy = TRUE)

hue_get_buttons(bridge = NULL, tidy = TRUE)

hue_get_button(id, bridge = NULL, tidy = TRUE)

hue_get_bell_buttons(bridge = NULL, tidy = TRUE)

hue_get_bell_button(id, bridge = NULL, tidy = TRUE)

hue_get_relative_rotaries(bridge = NULL, tidy = TRUE)

hue_get_relative_rotary(id, bridge = NULL, tidy = TRUE)

hue_get_contacts(bridge = NULL, tidy = TRUE)

hue_get_contact(id, bridge = NULL, tidy = TRUE)

hue_update_contact(id, body, bridge = NULL, tidy = TRUE)

hue_get_tampers(bridge = NULL, tidy = TRUE)

hue_get_tamper(id, bridge = NULL, tidy = TRUE)

hue_update_tamper(id, body, bridge = NULL, tidy = TRUE)
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

  Character scalar. UUID of the sensor or control resource.

- body:

  Named list representing the CLIP API v2 JSON update payload (for
  example, `list(enabled = TRUE)`).

## Value

A `tibble` (or list when `tidy = FALSE`) containing the bridge response
`data` array.

## Details

Supported CLIP API v2 endpoints:

- `GET /clip/v2/resource/motion` — `hue_get_motions()`

- `GET /clip/v2/resource/motion/{id}` — `hue_get_motion()`

- `PUT /clip/v2/resource/motion/{id}` — `hue_update_motion()`

- `GET /clip/v2/resource/grouped_motion` — `hue_get_grouped_motions()`

- `GET /clip/v2/resource/grouped_motion/{id}` —
  `hue_get_grouped_motion()`

- `PUT /clip/v2/resource/grouped_motion/{id}` —
  `hue_update_grouped_motion()`

- `GET /clip/v2/resource/camera_motion` — `hue_get_camera_motions()`

- `GET /clip/v2/resource/camera_motion/{id}` — `hue_get_camera_motion()`

- `PUT /clip/v2/resource/camera_motion/{id}` —
  `hue_update_camera_motion()`

- `GET /clip/v2/resource/temperature` — `hue_get_temperatures()`

- `GET /clip/v2/resource/temperature/{id}` — `hue_get_temperature()`

- `PUT /clip/v2/resource/temperature/{id}` — `hue_update_temperature()`

- `GET /clip/v2/resource/light_level` — `hue_get_light_levels()`

- `GET /clip/v2/resource/light_level/{id}` — `hue_get_light_level()`

- `PUT /clip/v2/resource/light_level/{id}` — `hue_update_light_level()`

- `GET /clip/v2/resource/grouped_light_level` —
  `hue_get_grouped_light_levels()`

- `GET /clip/v2/resource/grouped_light_level/{id}` —
  `hue_get_grouped_light_level()`

- `PUT /clip/v2/resource/grouped_light_level/{id}` —
  `hue_update_grouped_light_level()`

- `GET /clip/v2/resource/button` — `hue_get_buttons()`

- `GET /clip/v2/resource/button/{id}` — `hue_get_button()`

- `GET /clip/v2/resource/bell_button` — `hue_get_bell_buttons()`

- `GET /clip/v2/resource/bell_button/{id}` — `hue_get_bell_button()`

- `GET /clip/v2/resource/relative_rotary` —
  `hue_get_relative_rotaries()`

- `GET /clip/v2/resource/relative_rotary/{id}` —
  `hue_get_relative_rotary()`

- `GET /clip/v2/resource/contact` — `hue_get_contacts()`

- `GET /clip/v2/resource/contact/{id}` — `hue_get_contact()`

- `PUT /clip/v2/resource/contact/{id}` — `hue_update_contact()`

- `GET /clip/v2/resource/tamper` — `hue_get_tampers()`

- `GET /clip/v2/resource/tamper/{id}` — `hue_get_tamper()`

- `PUT /clip/v2/resource/tamper/{id}` — `hue_update_tamper()`

## See also

[hue_motion_areas](https://michael-cw.github.io/huer/reference/hue_motion_areas.md),
[`hue_eventstream()`](https://michael-cw.github.io/huer/reference/hue_eventstream.md)

## Examples

``` r
if (FALSE) { # \dontrun{
motions <- hue_get_motions()
temps <- hue_get_temperatures()
contacts <- hue_get_contacts()
} # }
```
