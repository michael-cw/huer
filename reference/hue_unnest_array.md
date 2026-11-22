# Unnest a Nested JSON Array Field from a Hue Response

Uses `tidyjson` to enter and expand a nested array property (such as
`"children"`, `"services"`, `"actions"`, `"channels"`, or `"locations"`)
stored inside the `..JSON` payload of a `tbl_json` object returned by
`huer`.

## Usage

``` r
hue_unnest_array(x, col)
```

## Arguments

- x:

  A `tbl_json` object returned by
  [`hue_parse_response()`](https://michael-cw.github.io/huer/reference/hue_parse_response.md)
  or any `hue_get_*()` function.

- col:

  Character scalar. Name of the nested JSON array key to expand (e.g.,
  `"children"` or `"services"`).

## Value

A `tbl_json` tibble with one row per element of the nested array,
preserving parent columns and spreading array element fields.

## See also

[`hue_parse_response()`](https://michael-cw.github.io/huer/reference/hue_parse_response.md)

## Examples

``` r
room_json <- paste0(
  '{"errors":[],"data":[{"id":"room-1","type":"room",',
  '"metadata":{"name":"Living Room"},',
  '"children":[{"rid":"dev-1","rtype":"device"},',
  '{"rid":"dev-2","rtype":"device"}]}]}'
)
rooms <- hue_parse_response(room_json)
hue_unnest_array(rooms, "children")
#> # A tibble: 2 × 6
#>   ..JSON                   id     type  metadata.name rid   rtype 
#>   <chr>                    <chr>  <chr> <chr>         <chr> <chr> 
#> 1 "{\"rid\":\"dev-1\",..." room-1 room  Living Room   dev-1 device
#> 2 "{\"rid\":\"dev-2\",..." room-1 room  Living Room   dev-2 device
```
