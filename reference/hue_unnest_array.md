# Unnest a Nested JSON Array Column from a Hue Response

Expands a nested JSON array list-column (such as `"children"`,
`"services"`, `"actions"`, `"channels"`, or `"locations"`) from a
`tibble` returned by `huer`, repeating parent rows and flattening each
element's fields into columns.

## Usage

``` r
hue_unnest_array(x, col)
```

## Arguments

- x:

  A `data.frame` or `tibble` returned by
  [`hue_parse_response()`](https://michael-cw.github.io/huer/reference/hue_parse_response.md)
  or any `hue_get_*()` function with `tidy = TRUE`.

- col:

  Character scalar. Name of the nested JSON array list-column to expand
  (e.g., `"children"` or `"services"`).

## Value

A `tibble` with one row per element of the nested array, preserving
parent columns and spreading nested element fields.

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
#> # A tibble: 2 × 5
#>   id     type  metadata.name rid   rtype 
#>   <chr>  <chr> <chr>         <chr> <chr> 
#> 1 room-1 room  Living Room   dev-1 device
#> 2 room-1 room  Living Room   dev-2 device
```
