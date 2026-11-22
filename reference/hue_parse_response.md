# Parse a Philips Hue CLIP API v2 JSON Response

Parses a standard Philips Hue CLIP API v2 JSON envelope
(`{"errors": [...], "data": [...]}`) into a `tbl_json` tibble using
`tidyjson`, automatically spreading scalar and nested object properties
into columns while preserving the underlying `..JSON` attribute for
nested array exploration with
[`hue_unnest_array()`](https://michael-cw.github.io/huer/reference/hue_unnest_array.md)
or `tidyjson` verbs.

## Usage

``` r
hue_parse_response(json, tidy = TRUE)
```

## Arguments

- json:

  Character scalar containing a JSON string, or a parsed R list
  containing a `data` element.

- tidy:

  Logical scalar. If `TRUE` (default), returns a `tbl_json` tibble via
  `tidyjson`. If `FALSE`, returns the raw parsed R list.

## Value

A `tbl_json` tibble (inheriting from `tbl_df`, `tbl`, `data.frame`) when
`tidy = TRUE`, or a named list when `tidy = FALSE`.

## See also

[`hue_unnest_array()`](https://michael-cw.github.io/huer/reference/hue_unnest_array.md),
[`hue_get_resources()`](https://michael-cw.github.io/huer/reference/hue_resources.md)

## Examples

``` r
sample_json <- paste0(
  '{"errors":[],"data":[',
  '{"id":"1111","type":"light","metadata":{"name":"Desk Lamp"},',
  '"on":{"on":true},"dimming":{"brightness":75.0}}]}'
)
res <- hue_parse_response(sample_json)
res
#> # A tibble: 1 × 6
#>   ..JSON                    id    type  metadata.name on.on dimming.brightness
#>   <chr>                     <chr> <chr> <chr>         <lgl>              <dbl>
#> 1 "{\"id\":\"1111\",\"t..." 1111  light Desk Lamp     TRUE                  75
```
