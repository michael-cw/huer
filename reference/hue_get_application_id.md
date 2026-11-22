# Retrieve the Hue Application Identifier

Calls `GET /auth/v1` with the configured `hue-application-key` header to
retrieve the `hue-application-id` UUID returned in response headers.
This ID is required as the DTLS identity when connecting to the Hue
Entertainment streaming API.

## Usage

``` r
hue_get_application_id(bridge = NULL)
```

## Arguments

- bridge:

  Optional `hue_bridge` object created by
  [`hue_bridge()`](https://michael-cw.github.io/huer/reference/hue_bridge.md).
  If `NULL`, resolves from session defaults set by
  [`hue_auth()`](https://michael-cw.github.io/huer/reference/hue_auth.md)
  or environment variables.

## Value

A character scalar containing the `hue-application-id` header value.

## See also

[`hue_create_app_key()`](https://michael-cw.github.io/huer/reference/hue_create_app_key.md),
[`hue_get_entertainment_configurations()`](https://michael-cw.github.io/huer/reference/hue_entertainment.md)

## Examples

``` r
if (FALSE) { # \dontrun{
app_id <- hue_get_application_id()
} # }
```
