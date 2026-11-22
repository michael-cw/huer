# Create a Philips Hue Application Key

Sends `POST https://<ip>/api` to register a new application key
(`hue-application-key`) and optional Entertainment DTLS `clientkey` on a
local Philips Hue Bridge (v2 or Bridge Pro).

## Usage

``` r
hue_create_app_key(
  ip,
  app_name = "huer",
  instance_name = Sys.info()[["nodename"]],
  generate_client_key = TRUE,
  verify_ssl = FALSE,
  ca_cert = NULL,
  timeout = 10
)
```

## Arguments

- ip:

  Character scalar. IPv4/IPv6 address or hostname of the Hue Bridge.

- app_name:

  Character scalar. Application identifier (1-20 ASCII characters).
  Defaults to `"huer"`.

- instance_name:

  Character scalar. Device or host identifier (1-19 ASCII characters).
  Defaults to the local machine hostname.

- generate_client_key:

  Logical scalar. If `TRUE` (default), also requests a 32-character hex
  `clientkey` for Hue Entertainment DTLS streaming.

- verify_ssl:

  Logical scalar. Whether to verify the bridge TLS certificate. Defaults
  to `FALSE` for initial local LAN onboarding; supply `ca_cert` and
  `verify_ssl = TRUE` when verifying against the Hue Root CA.

- ca_cert:

  Optional path to a PEM CA certificate bundle.

- timeout:

  Numeric scalar. Request timeout in seconds. Defaults to `10`.

## Value

A `tbl_json` tibble containing `username` (the `hue-application-key`)
and, when requested, `clientkey`.

## Details

Before calling `hue_create_app_key()`, you must physically press the
round link button on top of the Philips Hue Bridge. If the link button
was not pressed within the last 30 seconds, the bridge returns error
type `101` (`link button not pressed`).

## See also

[`hue_auth()`](https://michael-cw.github.io/huer/reference/hue_auth.md),
[`hue_bridge()`](https://michael-cw.github.io/huer/reference/hue_bridge.md),
[`hue_get_application_id()`](https://michael-cw.github.io/huer/reference/hue_get_application_id.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Press the physical link button on your Hue Bridge first, then run:
creds <- hue_create_app_key("192.168.1.50", app_name = "huer")
hue_auth(ip = "192.168.1.50", app_key = creds$username[[1]])
} # }
```
