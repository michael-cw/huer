# Connectivity and Zigbee Device Discovery Endpoints

Monitor and manage wireless connectivity services on a Philips Hue
Bridge v2 or Bridge Pro, including Zigbee
(`/clip/v2/resource/zigbee_connectivity`), Zigbee Green Power
(`/clip/v2/resource/zgp_connectivity`), Wi-Fi
(`/clip/v2/resource/wifi_connectivity`), and Zigbee pairing discovery
(`/clip/v2/resource/zigbee_device_discovery`).

## Usage

``` r
hue_get_zigbee_connectivities(bridge = NULL, tidy = TRUE)

hue_get_zigbee_connectivity(id, bridge = NULL, tidy = TRUE)

hue_get_zgp_connectivities(bridge = NULL, tidy = TRUE)

hue_get_zgp_connectivity(id, bridge = NULL, tidy = TRUE)

hue_get_wifi_connectivities(bridge = NULL, tidy = TRUE)

hue_get_wifi_connectivity(id, bridge = NULL, tidy = TRUE)

hue_update_wifi_connectivity(id, body, bridge = NULL, tidy = TRUE)

hue_get_zigbee_device_discoveries(bridge = NULL, tidy = TRUE)

hue_get_zigbee_device_discovery(id, bridge = NULL, tidy = TRUE)

hue_update_zigbee_device_discovery(id, body, bridge = NULL, tidy = TRUE)
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

  Character scalar. UUID of the connectivity or discovery resource.

- body:

  Named list representing the CLIP API v2 JSON payload.

## Value

A `tbl_json` tibble (or list when `tidy = FALSE`) containing the bridge
response `data` array.

## Details

Supported CLIP API v2 endpoints:

- `GET /clip/v2/resource/zigbee_connectivity` —
  `hue_get_zigbee_connectivities()`

- `GET /clip/v2/resource/zigbee_connectivity/{id}` —
  `hue_get_zigbee_connectivity()`

- `GET /clip/v2/resource/zgp_connectivity` —
  `hue_get_zgp_connectivities()`

- `GET /clip/v2/resource/zgp_connectivity/{id}` —
  `hue_get_zgp_connectivity()`

- `GET /clip/v2/resource/wifi_connectivity` —
  `hue_get_wifi_connectivities()`

- `GET /clip/v2/resource/wifi_connectivity/{id}` —
  `hue_get_wifi_connectivity()`

- `PUT /clip/v2/resource/wifi_connectivity/{id}` —
  `hue_update_wifi_connectivity()`

- `GET /clip/v2/resource/zigbee_device_discovery` —
  `hue_get_zigbee_device_discoveries()`

- `GET /clip/v2/resource/zigbee_device_discovery/{id}` —
  `hue_get_zigbee_device_discovery()`

- `PUT /clip/v2/resource/zigbee_device_discovery/{id}` —
  `hue_update_zigbee_device_discovery()`

## See also

[hue_devices](https://michael-cw.github.io/huer/reference/hue_devices.md)

## Examples

``` r
if (FALSE) { # \dontrun{
zigbee <- hue_get_zigbee_connectivities()
wifi <- hue_get_wifi_connectivities()
} # }
```
