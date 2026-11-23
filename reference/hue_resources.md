# Generic CLIP API v2 Resource Operations

Low-level CRUD functions covering the root `GET /clip/v2/resource`
endpoint and any `/clip/v2/resource/{resource}` or
`/clip/v2/resource/{resource}/{id}` endpoint on a Philips Hue Bridge v2
or Bridge Pro.

## Usage

``` r
hue_get_resources(bridge = NULL, tidy = TRUE)

hue_resource_get(resource, id = NULL, bridge = NULL, tidy = TRUE)

hue_resource_post(resource, body, bridge = NULL, tidy = TRUE)

hue_resource_put(resource, id, body, bridge = NULL, tidy = TRUE)

hue_resource_delete(resource, id, bridge = NULL, tidy = TRUE)
```

## Arguments

- bridge:

  Optional `hue_bridge` object created by
  [`hue_bridge()`](https://michael-cw.github.io/huer/reference/hue_bridge.md).
  If `NULL`, resolves from session defaults set by
  [`hue_auth()`](https://michael-cw.github.io/huer/reference/hue_auth.md)
  or environment variables.

- tidy:

  Logical scalar. If `TRUE` (default), returns a `tibble` parsed via
  `jsonlite`. If `FALSE`, returns the raw parsed R list.

- resource:

  Character scalar. CLIP API v2 resource type name (see
  [`hue_endpoints()`](https://michael-cw.github.io/huer/reference/hue_endpoints.md)
  for all 41 built-in resource types).

- id:

  Character scalar. UUID of a specific resource item. For
  `hue_resource_get()`, omit or pass `NULL` to list all resources of
  that type.

- body:

  Named list representing the JSON payload for `POST` or `PUT`.

## Value

A `tibble` (or list when `tidy = FALSE`) representing the bridge
response `data` array.

## See also

[`hue_endpoints()`](https://michael-cw.github.io/huer/reference/hue_endpoints.md),
[`hue_parse_response()`](https://michael-cw.github.io/huer/reference/hue_parse_response.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Retrieve all resources exposed by the Hue Bridge
all_res <- hue_get_resources()
} # }
```
