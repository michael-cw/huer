# Automation, Geofencing, HomeKit, and Matter Endpoints

Manage automation scripts (`/clip/v2/resource/behavior_script`), active
behavior instances (`/clip/v2/resource/behavior_instance`), geofence
clients (`/clip/v2/resource/geofence_client`), bridge geolocation
(`/clip/v2/resource/geolocation`), Apple HomeKit
(`/clip/v2/resource/homekit`), Matter configuration
(`/clip/v2/resource/matter`), and Matter fabrics
(`/clip/v2/resource/matter_fabric`).

## Usage

``` r
hue_get_behavior_scripts(bridge = NULL, tidy = TRUE)

hue_get_behavior_script(id, bridge = NULL, tidy = TRUE)

hue_get_behavior_instances(bridge = NULL, tidy = TRUE)

hue_get_behavior_instance(id, bridge = NULL, tidy = TRUE)

hue_create_behavior_instance(body, bridge = NULL, tidy = TRUE)

hue_update_behavior_instance(id, body, bridge = NULL, tidy = TRUE)

hue_delete_behavior_instance(id, bridge = NULL, tidy = TRUE)

hue_get_geofence_clients(bridge = NULL, tidy = TRUE)

hue_get_geofence_client(id, bridge = NULL, tidy = TRUE)

hue_create_geofence_client(body, bridge = NULL, tidy = TRUE)

hue_update_geofence_client(id, body, bridge = NULL, tidy = TRUE)

hue_delete_geofence_client(id, bridge = NULL, tidy = TRUE)

hue_get_geolocations(bridge = NULL, tidy = TRUE)

hue_get_geolocation(id, bridge = NULL, tidy = TRUE)

hue_update_geolocation(id, body, bridge = NULL, tidy = TRUE)

hue_get_homekits(bridge = NULL, tidy = TRUE)

hue_get_homekit(id, bridge = NULL, tidy = TRUE)

hue_update_homekit(id, body, bridge = NULL, tidy = TRUE)

hue_get_matters(bridge = NULL, tidy = TRUE)

hue_get_matter(id, bridge = NULL, tidy = TRUE)

hue_update_matter(id, body, bridge = NULL, tidy = TRUE)

hue_get_matter_fabrics(bridge = NULL, tidy = TRUE)

hue_get_matter_fabric(id, bridge = NULL, tidy = TRUE)

hue_delete_matter_fabric(id, bridge = NULL, tidy = TRUE)
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

  Character scalar. UUID of the automation, geofence, geolocation,
  HomeKit, or Matter resource.

- body:

  Named list representing the CLIP API v2 JSON payload.

## Value

A `tibble` (or list when `tidy = FALSE`) containing the bridge response
`data` array.

## Details

Supported CLIP API v2 endpoints:

- `GET /clip/v2/resource/behavior_script` — `hue_get_behavior_scripts()`

- `GET /clip/v2/resource/behavior_script/{id}` —
  `hue_get_behavior_script()`

- `GET /clip/v2/resource/behavior_instance` —
  `hue_get_behavior_instances()`

- `GET /clip/v2/resource/behavior_instance/{id}` —
  `hue_get_behavior_instance()`

- `POST /clip/v2/resource/behavior_instance` —
  `hue_create_behavior_instance()`

- `PUT /clip/v2/resource/behavior_instance/{id}` —
  `hue_update_behavior_instance()`

- `DELETE /clip/v2/resource/behavior_instance/{id}` —
  `hue_delete_behavior_instance()`

- `GET /clip/v2/resource/geofence_client` — `hue_get_geofence_clients()`

- `GET /clip/v2/resource/geofence_client/{id}` —
  `hue_get_geofence_client()`

- `POST /clip/v2/resource/geofence_client` —
  `hue_create_geofence_client()`

- `PUT /clip/v2/resource/geofence_client/{id}` —
  `hue_update_geofence_client()`

- `DELETE /clip/v2/resource/geofence_client/{id}` —
  `hue_delete_geofence_client()`

- `GET /clip/v2/resource/geolocation` — `hue_get_geolocations()`

- `GET /clip/v2/resource/geolocation/{id}` — `hue_get_geolocation()`

- `PUT /clip/v2/resource/geolocation/{id}` — `hue_update_geolocation()`

- `GET /clip/v2/resource/homekit` — `hue_get_homekits()`

- `GET /clip/v2/resource/homekit/{id}` — `hue_get_homekit()`

- `PUT /clip/v2/resource/homekit/{id}` — `hue_update_homekit()`

- `GET /clip/v2/resource/matter` — `hue_get_matters()`

- `GET /clip/v2/resource/matter/{id}` — `hue_get_matter()`

- `PUT /clip/v2/resource/matter/{id}` — `hue_update_matter()`

- `GET /clip/v2/resource/matter_fabric` — `hue_get_matter_fabrics()`

- `GET /clip/v2/resource/matter_fabric/{id}` — `hue_get_matter_fabric()`

- `DELETE /clip/v2/resource/matter_fabric/{id}` —
  `hue_delete_matter_fabric()`

## See also

[`hue_endpoints()`](https://michael-cw.github.io/huer/reference/hue_endpoints.md),
[hue_resources](https://michael-cw.github.io/huer/reference/hue_resources.md)

## Examples

``` r
if (FALSE) { # \dontrun{
scripts <- hue_get_behavior_scripts()
instances <- hue_get_behavior_instances()
fabrics <- hue_get_matter_fabrics()
} # }
```
