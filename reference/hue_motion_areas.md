# MotionAware and Motion Area Endpoints (Hue Bridge Pro)

Manage and read virtual motion sensing areas introduced with the Philips
Hue Bridge Pro MotionAware feature, including motion area configurations
(`/clip/v2/resource/motion_area_configuration`), eligible room/zone
candidates (`/clip/v2/resource/motion_area_candidate`), convenience area
motion states (`/clip/v2/resource/convenience_area_motion`), and
security area motion states (`/clip/v2/resource/security_area_motion`).

## Usage

``` r
hue_get_motion_area_configurations(bridge = NULL, tidy = TRUE)

hue_get_motion_area_configuration(id, bridge = NULL, tidy = TRUE)

hue_create_motion_area_configuration(body, bridge = NULL, tidy = TRUE)

hue_update_motion_area_configuration(id, body, bridge = NULL, tidy = TRUE)

hue_delete_motion_area_configuration(id, bridge = NULL, tidy = TRUE)

hue_get_motion_area_candidates(bridge = NULL, tidy = TRUE)

hue_get_motion_area_candidate(id, bridge = NULL, tidy = TRUE)

hue_get_convenience_area_motions(bridge = NULL, tidy = TRUE)

hue_get_convenience_area_motion(id, bridge = NULL, tidy = TRUE)

hue_update_convenience_area_motion(id, body, bridge = NULL, tidy = TRUE)

hue_get_security_area_motions(bridge = NULL, tidy = TRUE)

hue_get_security_area_motion(id, bridge = NULL, tidy = TRUE)

hue_update_security_area_motion(id, body, bridge = NULL, tidy = TRUE)
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

  Character scalar. UUID of the motion area resource.

- body:

  Named list representing the CLIP API v2 JSON payload.

## Value

A `tbl_json` tibble (or list when `tidy = FALSE`) containing the bridge
response `data` array.

## Details

Supported CLIP API v2 / Bridge Pro endpoints:

- `GET /clip/v2/resource/motion_area_configuration` —
  `hue_get_motion_area_configurations()`

- `GET /clip/v2/resource/motion_area_configuration/{id}` —
  `hue_get_motion_area_configuration()`

- `POST /clip/v2/resource/motion_area_configuration` —
  `hue_create_motion_area_configuration()`

- `PUT /clip/v2/resource/motion_area_configuration/{id}` —
  `hue_update_motion_area_configuration()`

- `DELETE /clip/v2/resource/motion_area_configuration/{id}` —
  `hue_delete_motion_area_configuration()`

- `GET /clip/v2/resource/motion_area_candidate` —
  `hue_get_motion_area_candidates()`

- `GET /clip/v2/resource/motion_area_candidate/{id}` —
  `hue_get_motion_area_candidate()`

- `GET /clip/v2/resource/convenience_area_motion` —
  `hue_get_convenience_area_motions()`

- `GET /clip/v2/resource/convenience_area_motion/{id}` —
  `hue_get_convenience_area_motion()`

- `PUT /clip/v2/resource/convenience_area_motion/{id}` —
  `hue_update_convenience_area_motion()`

- `GET /clip/v2/resource/security_area_motion` —
  `hue_get_security_area_motions()`

- `GET /clip/v2/resource/security_area_motion/{id}` —
  `hue_get_security_area_motion()`

- `PUT /clip/v2/resource/security_area_motion/{id}` —
  `hue_update_security_area_motion()`

## See also

[hue_sensors](https://michael-cw.github.io/huer/reference/hue_sensors.md),
[`hue_eventstream()`](https://michael-cw.github.io/huer/reference/hue_eventstream.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Inspect MotionAware configurations and live convenience/security motion
configs <- hue_get_motion_area_configurations()
candidates <- hue_get_motion_area_candidates()
convenience <- hue_get_convenience_area_motions()
security <- hue_get_security_area_motions()
} # }
```
