# List All Supported Philips Hue CLIP API v2 and Bridge Pro Endpoints

Returns a reference `tibble` documenting every resource type exposed by
the Philips Hue Bridge v2 and Bridge Pro CLIP API v2 under
`/clip/v2/resource/`, including its functional category, whether it was
introduced for Bridge Pro or Hue Secure features, and which HTTP verbs
(`GET`, `POST`, `PUT`, `DELETE`) are supported.

## Usage

``` r
hue_endpoints()
```

## Value

A `tibble` with columns `resource`, `category`, `path`, `get`, `post`,
`put`, `delete`, and `bridge_pro`.

## See also

[`hue_get_resources()`](https://michael-cw.github.io/huer/reference/hue_resources.md),
[`hue_resource_get()`](https://michael-cw.github.io/huer/reference/hue_resources.md),
[`hue_resource_post()`](https://michael-cw.github.io/huer/reference/hue_resources.md),
[`hue_resource_put()`](https://michael-cw.github.io/huer/reference/hue_resources.md),
[`hue_resource_delete()`](https://michael-cw.github.io/huer/reference/hue_resources.md)

## Examples

``` r
ep <- hue_endpoints()
ep
#> # A tibble: 41 × 8
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
#> # ℹ 31 more rows
ep[ep$bridge_pro, ]
#> # A tibble: 11 × 8
#>    resource                  category  path  get   post  put   delete bridge_pro
#>    <chr>                     <chr>     <chr> <lgl> <lgl> <lgl> <lgl>  <lgl>     
#>  1 service_group             groups    /cli… TRUE  TRUE  TRUE  TRUE   TRUE      
#>  2 camera_motion             sensors   /cli… TRUE  FALSE TRUE  FALSE  TRUE      
#>  3 bell_button               sensors   /cli… TRUE  FALSE FALSE FALSE  TRUE      
#>  4 contact                   sensors   /cli… TRUE  FALSE TRUE  FALSE  TRUE      
#>  5 tamper                    sensors   /cli… TRUE  FALSE TRUE  FALSE  TRUE      
#>  6 motion_area_configuration motion_a… /cli… TRUE  TRUE  TRUE  TRUE   TRUE      
#>  7 motion_area_candidate     motion_a… /cli… TRUE  FALSE FALSE FALSE  TRUE      
#>  8 convenience_area_motion   motion_a… /cli… TRUE  FALSE TRUE  FALSE  TRUE      
#>  9 security_area_motion      motion_a… /cli… TRUE  FALSE TRUE  FALSE  TRUE      
#> 10 wifi_connectivity         connecti… /cli… TRUE  FALSE TRUE  FALSE  TRUE      
#> 11 speaker                   entertai… /cli… TRUE  FALSE TRUE  FALSE  TRUE      
```
