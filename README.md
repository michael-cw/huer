# huer

`huer` is a complete R client for the **Philips Hue CLIP API v2** and
**Hue Bridge Pro** local HTTPS endpoints, built on
[`httr2`](https://cran.r-project.org/package=httr2),
[`jsonlite`](https://cran.r-project.org/package=jsonlite), and
[`cli`](https://cran.r-project.org/package=cli).

## Features

- **Complete CLIP API v2 & Bridge Pro Coverage**: Dedicated `GET`, `POST`,
  `PUT`, and `DELETE` functions for all 41 CLIP v2 & Bridge Pro resource types
  (including Bridge Pro MotionAware `motion_area_configuration`,
  `motion_area_candidate`, `convenience_area_motion`, `security_area_motion`,
  `service_group`, `wifi_connectivity`, `speaker`, `bell_button`, `contact`,
  `tamper`, and `camera_motion`), plus generic `hue_resource_*()` helpers and
  the root `GET /clip/v2/resource` endpoint.
- **Discovery, Onboarding & Streaming**: Local bridge discovery
  (`hue_discover()`), link-button application key generation
  (`hue_create_app_key()`), Entertainment DTLS app ID lookup
  (`hue_get_application_id()`), and real-time Server-Sent Events streaming
  (`hue_eventstream()`).
- **Tidy JSON Output**: Responses are parsed via `jsonlite` into `tibble`
  data frames with flattened dot-separated columns and nested array
  list-columns that can be expanded with `hue_unnest_array()`.
- **Structured Diagnostics**: Human-readable error and partial-error messages
  powered by `cli` and `httr2`.

## Quick Start

```r
library(huer)

# 1. Discover bridges on your network
bridges <- hue_discover()
ip <- bridges$internalipaddress[[1]]

# 2. Press the link button on your Hue Bridge, then generate an app key
creds <- hue_create_app_key(ip, app_name = "huer")

# 3. Configure session credentials
hue_auth(ip = ip, app_key = creds$username[[1]], verify_ssl = FALSE)

# 4. Query lights and adjust state
lights <- hue_get_lights()
hue_update_light(
  id = lights$id[[1]],
  body = hue_payload_light(on = TRUE, brightness = 80, mirek = 300)
)

# 5. Inspect all 41 supported CLIP v2 & Bridge Pro endpoints
hue_endpoints()
```

## Author & Maintainer

Michael Wild (<michael.wild@me.com>)

## License

MIT + file LICENSE
