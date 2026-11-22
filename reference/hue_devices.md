# Device, Power, Firmware Update, and Bridge Endpoints

Manage hardware devices (`/clip/v2/resource/device`), device
battery/power states (`/clip/v2/resource/device_power`), firmware
software update services (`/clip/v2/resource/device_software_update`),
and Hue Bridge properties (`/clip/v2/resource/bridge`).

## Usage

``` r
hue_get_devices(bridge = NULL, tidy = TRUE)

hue_get_device(id, bridge = NULL, tidy = TRUE)

hue_update_device(id, body, bridge = NULL, tidy = TRUE)

hue_delete_device(id, bridge = NULL, tidy = TRUE)

hue_get_device_powers(bridge = NULL, tidy = TRUE)

hue_get_device_power(id, bridge = NULL, tidy = TRUE)

hue_get_device_software_updates(bridge = NULL, tidy = TRUE)

hue_get_device_software_update(id, bridge = NULL, tidy = TRUE)

hue_update_device_software_update(id, body, bridge = NULL, tidy = TRUE)

hue_get_bridges(bridge = NULL, tidy = TRUE)

hue_get_bridge(id, bridge = NULL, tidy = TRUE)

hue_update_bridge(id, body, bridge = NULL, tidy = TRUE)
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

  Character scalar. UUID of the device, device power, software update,
  or bridge resource.

- body:

  Named list representing the CLIP API v2 JSON payload.

## Value

A `tbl_json` tibble (or list when `tidy = FALSE`) containing the bridge
response `data` array.

## Details

Supported CLIP API v2 endpoints:

- `GET /clip/v2/resource/device` — `hue_get_devices()`

- `GET /clip/v2/resource/device/{id}` — `hue_get_device()`

- `PUT /clip/v2/resource/device/{id}` — `hue_update_device()`

- `DELETE /clip/v2/resource/device/{id}` — `hue_delete_device()`

- `GET /clip/v2/resource/device_power` — `hue_get_device_powers()`

- `GET /clip/v2/resource/device_power/{id}` — `hue_get_device_power()`

- `GET /clip/v2/resource/device_software_update` —
  `hue_get_device_software_updates()`

- `GET /clip/v2/resource/device_software_update/{id}` —
  `hue_get_device_software_update()`

- `PUT /clip/v2/resource/device_software_update/{id}` —
  `hue_update_device_software_update()`

- `GET /clip/v2/resource/bridge` — `hue_get_bridges()`

- `GET /clip/v2/resource/bridge/{id}` — `hue_get_bridge()`

- `PUT /clip/v2/resource/bridge/{id}` — `hue_update_bridge()`

## See also

[`hue_get_zigbee_connectivities()`](https://michael-cw.github.io/huer/reference/hue_connectivity.md),
[`hue_get_wifi_connectivities()`](https://michael-cw.github.io/huer/reference/hue_connectivity.md)

## Examples

``` r
if (FALSE) { # \dontrun{
devices <- hue_get_devices()
bridge_info <- hue_get_bridges()
} # }
```
