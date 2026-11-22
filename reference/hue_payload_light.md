# Build a Light or Grouped Light State Update Payload

Convenience helper that constructs a validated CLIP API v2 JSON payload
list suitable for
[`hue_update_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)
and
[`hue_update_grouped_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md).

## Usage

``` r
hue_payload_light(
  on = NULL,
  brightness = NULL,
  mirek = NULL,
  xy = NULL,
  effect = NULL,
  dynamics_duration = NULL,
  alert = NULL,
  ...
)
```

## Arguments

- on:

  Optional logical scalar. Set `TRUE` to turn on or `FALSE` to turn off.

- brightness:

  Optional numeric scalar in `[0, 100]`. Target brightness percentage.

- mirek:

  Optional integer scalar in `[153, 500]`. Color temperature in mirek
  (`153` = coolest 6500K, `500` = warmest 2000K).

- xy:

  Optional numeric vector of length 2 (`c(x, y)`), each in `[0, 1]`,
  specifying CIE 1931 xy chromaticity coordinates.

- effect:

  Optional character scalar effect name (e.g., `"no_effect"`,
  `"candle"`, `"fire"`, `"prism"`, `"sparkle"`, `"opal"`, `"glisten"`,
  `"underwater"`, `"cosmos"`, `"sunbeam"`, `"enchant"`).

- dynamics_duration:

  Optional non-negative integer scalar transition duration in
  milliseconds.

- alert:

  Optional character scalar alert action (e.g., `"breathe"`).

- ...:

  Additional named CLIP API v2 fields merged into the payload (e.g.,
  `gradient`, `timed_effects`, `signaling`, `metadata`).

## Value

A named list suitable for passing as the `body` argument to
[`hue_update_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)
or
[`hue_update_grouped_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md).

## See also

[`hue_update_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md),
[`hue_update_grouped_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)

## Examples

``` r
payload <- hue_payload_light(
  on = TRUE,
  brightness = 80,
  mirek = 300,
  dynamics_duration = 400
)
payload
#> $on
#> $on$on
#> [1] TRUE
#> 
#> 
#> $dimming
#> $dimming$brightness
#> [1] 80
#> 
#> 
#> $color_temperature
#> $color_temperature$mirek
#> [1] 300
#> 
#> 
#> $dynamics
#> $dynamics$duration
#> [1] 400
#> 
#> 
```
