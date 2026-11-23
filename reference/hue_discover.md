# Discover Philips Hue Bridges on the Local Network

Queries the Philips Hue cloud discovery endpoint
(`GET https://discovery.meethue.com/`) to locate Hue Bridges (including
Bridge v2 and Bridge Pro) registered on the same public network.

## Usage

``` r
hue_discover(timeout = 10, tidy = TRUE)
```

## Arguments

- timeout:

  Numeric scalar. Request timeout in seconds. Defaults to `10`.

- tidy:

  Logical scalar. If `TRUE` (default), parses the JSON response into a
  `tibble` via `jsonlite`. If `FALSE`, returns the parsed R list from
  `jsonlite`.

## Value

A `tibble` (or list when `tidy = FALSE`) containing discovered bridges
(`id`, `internalipaddress`, `port`).

## See also

[`hue_create_app_key()`](https://michael-cw.github.io/huer/reference/hue_create_app_key.md),
[`hue_bridge()`](https://michael-cw.github.io/huer/reference/hue_bridge.md)

## Examples

``` r
if (FALSE) { # \dontrun{
bridges <- hue_discover()
bridges
} # }
```
