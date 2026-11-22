# Build a Philips Hue Resource Identifier Reference

Constructs a standard CLIP API v2 resource identifier (`rid` / `rtype`)
object used when referencing lights, devices, rooms, zones, or services
in `POST` and `PUT` request bodies.

## Usage

``` r
hue_resource_identifier(rid, rtype)
```

## Arguments

- rid:

  Character scalar. UUID of the target resource.

- rtype:

  Character scalar. CLIP API v2 resource type (e.g., `"device"`,
  `"light"`, `"room"`, `"zone"`, `"grouped_light"`).

## Value

A named list with elements `rid` and `rtype`.

## See also

[`hue_create_room()`](https://michael-cw.github.io/huer/reference/hue_groups.md),
[`hue_create_zone()`](https://michael-cw.github.io/huer/reference/hue_groups.md),
[`hue_create_scene()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)

## Examples

``` r
hue_resource_identifier("3b149a01-810e-4d5e-9094-41c0d1f35020", "device")
#> $rid
#> [1] "3b149a01-810e-4d5e-9094-41c0d1f35020"
#> 
#> $rtype
#> [1] "device"
#> 
```
