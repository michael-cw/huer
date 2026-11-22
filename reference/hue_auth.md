# Configure Session Credentials for a Philips Hue Bridge

Stores, retrieves, or clears default Philips Hue Bridge connection
settings in an internal session environment so individual API calls do
not need to pass a `bridge` object repeatedly.

## Usage

``` r
hue_auth(
  ip = NULL,
  app_key = NULL,
  verify_ssl = NULL,
  ca_cert = NULL,
  clear = FALSE
)
```

## Arguments

- ip:

  Character scalar. IPv4/IPv6 address or hostname of the local Philips
  Hue Bridge (e.g., `"192.168.1.50"`). If `NULL`, falls back to session
  state set by `hue_auth()` and then the `HUE_BRIDGE_IP` environment
  variable.

- app_key:

  Character scalar. Application key (`hue-application-key`) obtained via
  [`hue_create_app_key()`](https://michael-cw.github.io/huer/reference/hue_create_app_key.md).
  If `NULL`, falls back to session state set by `hue_auth()` and then
  the `HUE_APP_KEY` environment variable.

- verify_ssl:

  Logical scalar. Whether to verify the bridge TLS certificate. Defaults
  to `TRUE`. Because local Philips Hue Bridges present a self-signed
  certificate signed by the Hue Bridge Root CA, either supply `ca_cert`
  with the path to the Signify Root CA PEM file or explicitly set
  `verify_ssl = FALSE` on trusted local networks.

- ca_cert:

  Optional character scalar path to a PEM CA certificate bundle (such as
  the Philips Hue Bridge Root CA) used for TLS verification.

- clear:

  Logical scalar. If `TRUE`, clears all stored session settings.

## Value

Invisibly returns a `hue_bridge` object when `ip` and `app_key` are
available, or `NULL` when cleared or unconfigured.

## See also

[`hue_bridge()`](https://michael-cw.github.io/huer/reference/hue_bridge.md),
[`hue_create_app_key()`](https://michael-cw.github.io/huer/reference/hue_create_app_key.md)

## Examples

``` r
hue_auth(ip = "192.168.1.50", app_key = "demo-key", verify_ssl = FALSE)
hue_auth()
hue_auth(clear = TRUE)
```
