# Rooms, Zones, Bridge Home, and Service Group Endpoints

Manage structural groupings on a Philips Hue Bridge v2 or Bridge Pro,
including rooms (`/clip/v2/resource/room`), zones
(`/clip/v2/resource/zone`), top-level bridge home containers
(`/clip/v2/resource/bridge_home`), and Bridge Pro service groups
(`/clip/v2/resource/service_group`).

## Usage

``` r
hue_get_rooms(bridge = NULL, tidy = TRUE)

hue_get_room(id, bridge = NULL, tidy = TRUE)

hue_create_room(body, bridge = NULL, tidy = TRUE)

hue_update_room(id, body, bridge = NULL, tidy = TRUE)

hue_delete_room(id, bridge = NULL, tidy = TRUE)

hue_get_zones(bridge = NULL, tidy = TRUE)

hue_get_zone(id, bridge = NULL, tidy = TRUE)

hue_create_zone(body, bridge = NULL, tidy = TRUE)

hue_update_zone(id, body, bridge = NULL, tidy = TRUE)

hue_delete_zone(id, bridge = NULL, tidy = TRUE)

hue_get_bridge_homes(bridge = NULL, tidy = TRUE)

hue_get_bridge_home(id, bridge = NULL, tidy = TRUE)

hue_update_bridge_home(id, body, bridge = NULL, tidy = TRUE)

hue_get_service_groups(bridge = NULL, tidy = TRUE)

hue_get_service_group(id, bridge = NULL, tidy = TRUE)

hue_create_service_group(body, bridge = NULL, tidy = TRUE)

hue_update_service_group(id, body, bridge = NULL, tidy = TRUE)

hue_delete_service_group(id, bridge = NULL, tidy = TRUE)
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

  Character scalar. UUID of the room, zone, bridge home, or service
  group resource.

- body:

  Named list representing the CLIP API v2 JSON payload.

## Value

A `tbl_json` tibble (or list when `tidy = FALSE`) containing the bridge
response `data` array.

## Details

Supported CLIP API v2 endpoints:

- `GET /clip/v2/resource/room` — `hue_get_rooms()`

- `GET /clip/v2/resource/room/{id}` — `hue_get_room()`

- `POST /clip/v2/resource/room` — `hue_create_room()`

- `PUT /clip/v2/resource/room/{id}` — `hue_update_room()`

- `DELETE /clip/v2/resource/room/{id}` — `hue_delete_room()`

- `GET /clip/v2/resource/zone` — `hue_get_zones()`

- `GET /clip/v2/resource/zone/{id}` — `hue_get_zone()`

- `POST /clip/v2/resource/zone` — `hue_create_zone()`

- `PUT /clip/v2/resource/zone/{id}` — `hue_update_zone()`

- `DELETE /clip/v2/resource/zone/{id}` — `hue_delete_zone()`

- `GET /clip/v2/resource/bridge_home` — `hue_get_bridge_homes()`

- `GET /clip/v2/resource/bridge_home/{id}` — `hue_get_bridge_home()`

- `PUT /clip/v2/resource/bridge_home/{id}` — `hue_update_bridge_home()`

- `GET /clip/v2/resource/service_group` — `hue_get_service_groups()`

- `GET /clip/v2/resource/service_group/{id}` — `hue_get_service_group()`

- `POST /clip/v2/resource/service_group` — `hue_create_service_group()`

- `PUT /clip/v2/resource/service_group/{id}` —
  `hue_update_service_group()`

- `DELETE /clip/v2/resource/service_group/{id}` —
  `hue_delete_service_group()`

## See also

[`hue_resource_identifier()`](https://michael-cw.github.io/huer/reference/hue_resource_identifier.md),
[`hue_unnest_array()`](https://michael-cw.github.io/huer/reference/hue_unnest_array.md),
[`hue_get_grouped_lights()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)

## Examples

``` r
if (FALSE) { # \dontrun{
rooms <- hue_get_rooms()
new_room <- hue_create_room(list(
  metadata = list(name = "Studio", archetype = "office"),
  children = list(hue_resource_identifier("device-uuid", "device"))
))
} # }
```
