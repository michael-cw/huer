# Getting Started with huer

`huer` is an `httr2`-based R client for the **Philips Hue CLIP API v2**
and **Hue Bridge Pro** local HTTPS endpoints. It wraps all `GET`,
`POST`, `PUT`, and `DELETE` resource operations across 41 CLIP v2 and
Bridge Pro resource types, parses JSON envelopes into tidy `tbl_json`
tables via `tidyjson`, and provides clear diagnostics powered by `cli`.

## Discovering and Authenticating with a Bridge

1.  Locate your bridge’s local IP address using
    [`hue_discover()`](https://michael-cw.github.io/huer/reference/hue_discover.md)
    (or check your router / Hue app).
2.  Press the physical round link button on top of the Hue Bridge.
3.  Generate an application key (`hue-application-key`) within 30
    seconds:

``` r

library(huer)

bridges <- hue_discover()
ip <- bridges$internalipaddress[[1]]

# Press the physical link button on the Hue Bridge before running:
creds <- hue_create_app_key(ip, app_name = "huer")

# Store credentials for the current R session
hue_auth(ip = ip, app_key = creds$username[[1]], verify_ssl = FALSE)
```

For reproducible scripts, set `HUE_BRIDGE_IP` and `HUE_APP_KEY` in your
environment, or create an explicit client object with
[`hue_bridge()`](https://michael-cw.github.io/huer/reference/hue_bridge.md):

``` r

library(huer)

bridge <- hue_bridge(
  ip = "192.168.1.50",
  app_key = "example-application-key",
  verify_ssl = FALSE
)
bridge
#> 
#> ── Philips Hue Bridge Client (CLIP API v2)
#> Bridge: https://192.168.1.50
#> App key: exam...-key
#> TLS: unverified (local)
#> Timeout: 10s
```

> **TLS Note:** Local Philips Hue Bridges serve HTTPS using a
> certificate signed by the Signify Hue Bridge Root CA. For strict
> certificate validation, pass the path to the Signify Root CA PEM file
> via `ca_cert` with `verify_ssl = TRUE`; on trusted local LANs,
> `verify_ssl = FALSE` disables certificate verification.

## Exploring All CLIP API v2 & Bridge Pro Endpoints

Use
[`hue_endpoints()`](https://michael-cw.github.io/huer/reference/hue_endpoints.md)
to inspect the complete matrix of supported resource types, REST paths,
HTTP methods, and Bridge Pro / Hue Secure additions:

``` r

ep <- hue_endpoints()
nrow(ep)
#> [1] 41
head(ep, 10)
#> # A tibble: 10 × 8
#>    resource      category path               get   post  put   delete bridge_pro
#>    <chr>         <chr>    <chr>              <lgl> <lgl> <lgl> <lgl>  <lgl>     
#>  1 light         lighting /clip/v2/resource… TRUE  FALSE TRUE  FALSE  FALSE     
#>  2 grouped_light lighting /clip/v2/resource… TRUE  FALSE TRUE  FALSE  FALSE     
#>  3 room          groups   /clip/v2/resource… TRUE  TRUE  TRUE  TRUE   FALSE     
#>  4 zone          groups   /clip/v2/resource… TRUE  TRUE  TRUE  TRUE   FALSE     
#>  5 bridge_home   groups   /clip/v2/resource… TRUE  FALSE TRUE  FALSE  FALSE     
#>  6 service_group groups   /clip/v2/resource… TRUE  TRUE  TRUE  TRUE   TRUE      
#>  7 scene         scenes   /clip/v2/resource… TRUE  TRUE  TRUE  TRUE   FALSE     
#>  8 smart_scene   scenes   /clip/v2/resource… TRUE  TRUE  TRUE  TRUE   FALSE     
#>  9 device        devices  /clip/v2/resource… TRUE  FALSE TRUE  TRUE   FALSE     
#> 10 device_power  devices  /clip/v2/resource… TRUE  FALSE FALSE FALSE  FALSE
```

Filter for endpoints introduced for **Hue Bridge Pro** (such as
MotionAware virtual motion areas, `service_group`, `wifi_connectivity`,
`speaker`, and Hue Secure sensors):

``` r

ep[ep$bridge_pro, c("resource", "category", "get", "post", "put", "delete")]
#> # A tibble: 11 × 6
#>    resource                  category      get   post  put   delete
#>    <chr>                     <chr>         <lgl> <lgl> <lgl> <lgl> 
#>  1 service_group             groups        TRUE  TRUE  TRUE  TRUE  
#>  2 camera_motion             sensors       TRUE  FALSE TRUE  FALSE 
#>  3 bell_button               sensors       TRUE  FALSE FALSE FALSE 
#>  4 contact                   sensors       TRUE  FALSE TRUE  FALSE 
#>  5 tamper                    sensors       TRUE  FALSE TRUE  FALSE 
#>  6 motion_area_configuration motion_areas  TRUE  TRUE  TRUE  TRUE  
#>  7 motion_area_candidate     motion_areas  TRUE  FALSE FALSE FALSE 
#>  8 convenience_area_motion   motion_areas  TRUE  FALSE TRUE  FALSE 
#>  9 security_area_motion      motion_areas  TRUE  FALSE TRUE  FALSE 
#> 10 wifi_connectivity         connectivity  TRUE  FALSE TRUE  FALSE 
#> 11 speaker                   entertainment TRUE  FALSE TRUE  FALSE
```

## Controlling Lights and Building Payloads

[`hue_payload_light()`](https://michael-cw.github.io/huer/reference/hue_payload_light.md)
constructs validated CLIP API v2 update payloads for
[`hue_update_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)
and
[`hue_update_grouped_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md):

``` r

payload <- hue_payload_light(
  on = TRUE,
  brightness = 75,
  mirek = 320,
  dynamics_duration = 500
)
str(payload)
#> List of 4
#>  $ on               :List of 1
#>   ..$ on: logi TRUE
#>  $ dimming          :List of 1
#>   ..$ brightness: num 75
#>  $ color_temperature:List of 1
#>   ..$ mirek: int 320
#>  $ dynamics         :List of 1
#>   ..$ duration: int 500
```

``` r

lights <- hue_get_lights()
hue_update_light(lights$id[[1]], body = payload)

# Recall a scene with a 1-second transition
scenes <- hue_get_scenes()
hue_recall_scene(scenes$id[[1]], action = "active", duration = 1000)
```

## Working with `tidyjson` Responses

Every API response from `huer` is parsed through
[`hue_parse_response()`](https://michael-cw.github.io/huer/reference/hue_parse_response.md)
into a `tbl_json` object (which inherits from `tibble`). Scalar and
nested object properties are spread into columns automatically, while
nested arrays (such as `children`, `services`, or `actions`) remain
accessible through
[`hue_unnest_array()`](https://michael-cw.github.io/huer/reference/hue_unnest_array.md):

``` r

sample_room <- paste0(
  '{"errors":[],"data":[{"id":"room-01","type":"room",',
  '"metadata":{"name":"Living Room","archetype":"living_room"},',
  '"children":[',
  '{"rid":"dev-01","rtype":"device"},',
  '{"rid":"dev-02","rtype":"device"}],',
  '"services":[{"rid":"gl-01","rtype":"grouped_light"}]}]}'
)

rooms <- hue_parse_response(sample_room)
rooms
#> # A tibble: 1 × 5
#>   ..JSON                   id      type  metadata.name metadata.archetype
#>   <chr>                    <chr>   <chr> <chr>         <chr>             
#> 1 "{\"id\":\"room-01\"..." room-01 room  Living Room   living_room

# Expand nested arrays directly with tidyjson
hue_unnest_array(rooms, "children")
#> # A tibble: 2 × 7
#>   ..JSON                id    type  metadata.name metadata.archetype rid   rtype
#>   <chr>                 <chr> <chr> <chr>         <chr>              <chr> <chr>
#> 1 "{\"rid\":\"dev-01\"… room… room  Living Room   living_room        dev-… devi…
#> 2 "{\"rid\":\"dev-02\"… room… room  Living Room   living_room        dev-… devi…
hue_unnest_array(rooms, "services")
#> # A tibble: 1 × 7
#>   ..JSON                id    type  metadata.name metadata.archetype rid   rtype
#>   <chr>                 <chr> <chr> <chr>         <chr>              <chr> <chr>
#> 1 "{\"rid\":\"gl-01\",… room… room  Living Room   living_room        gl-01 grou…
```

Set `tidy = FALSE` on any endpoint call if you prefer the raw parsed R
list.

## Hue Bridge Pro MotionAware & Real-Time EventStream

Bridge Pro turns compatible lights into MotionAware virtual motion
areas. You can manage configurations and read convenience/security
motion states directly, or subscribe to real-time updates over
Server-Sent Events (`GET /eventstream/clip/v2`):

``` r

# Bridge Pro MotionAware resources
candidates <- hue_get_motion_area_candidates()
configs <- hue_get_motion_area_configurations()
convenience <- hue_get_convenience_area_motions()
security <- hue_get_security_area_motions()

# Stream live events over SSE
events <- hue_eventstream(max_events = 5L, timeout = 30)
```
