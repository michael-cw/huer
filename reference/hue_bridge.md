# Create a Philips Hue Bridge Client Configuration

Constructs a `hue_bridge` S3 configuration object used to authenticate
and direct HTTPS requests to a local Philips Hue Bridge (v2 or Bridge
Pro) running the CLIP API v2.

## Usage

``` r
hue_bridge(
  ip = NULL,
  app_key = NULL,
  verify_ssl = NULL,
  ca_cert = NULL,
  timeout = 10
)
```

## Arguments

- ip:

  Character scalar. IPv4/IPv6 address or hostname of the local Philips
  Hue Bridge (e.g., `"192.168.1.50"`). If `NULL`, falls back to session
  state set by
  [`hue_auth()`](https://michael-cw.github.io/huer/reference/hue_auth.md)
  and then the `HUE_BRIDGE_IP` environment variable.

- app_key:

  Character scalar. Application key (`hue-application-key`) obtained via
  [`hue_create_app_key()`](https://michael-cw.github.io/huer/reference/hue_create_app_key.md).
  If `NULL`, falls back to session state set by
  [`hue_auth()`](https://michael-cw.github.io/huer/reference/hue_auth.md)
  and then the `HUE_APP_KEY` environment variable.

- verify_ssl:

  Logical scalar. Whether to verify the bridge TLS certificate. Defaults
  to `TRUE`. Because local Philips Hue Bridges present a self-signed
  certificate signed by the Hue Bridge Root CA, either supply `ca_cert`
  with the path to the Signify Root CA PEM file or explicitly set
  `verify_ssl = FALSE` on trusted local networks.

- ca_cert:

  Optional character scalar path to a PEM CA certificate bundle (such as
  the Philips Hue Bridge Root CA) used for TLS verification.

- timeout:

  Numeric scalar. Request timeout in seconds. Defaults to `10`.

## Value

An object of class `"hue_bridge"`.

## See also

[`hue_auth()`](https://michael-cw.github.io/huer/reference/hue_auth.md),
[`hue_discover()`](https://michael-cw.github.io/huer/reference/hue_discover.md),
[`hue_create_app_key()`](https://michael-cw.github.io/huer/reference/hue_create_app_key.md)

## Examples

``` r
bridge <- hue_bridge(
  ip = "192.168.1.50",
  app_key = "example-application-key",
  verify_ssl = FALSE
)
print(bridge)
#> 
#> ── Philips Hue Bridge Client (CLIP API v2) 
#> Bridge: https://192.168.1.50
#> App key: exam...-key
#> TLS: unverified (local)
#> Timeout: 10s
```
