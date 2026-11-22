# Changelog

## huer 0.1.0

- Initial release of `huer`, providing complete `httr2`, `tidyjson`, and
  `cli` support for the Philips Hue CLIP API v2 and Hue Bridge Pro.
- Added typed `GET`, `POST`, `PUT`, and `DELETE` wrappers for all 41
  CLIP API v2 and Bridge Pro resource types, plus generic
  `hue_resource_*()` helpers and
  [`hue_endpoints()`](https://michael-cw.github.io/huer/reference/hue_endpoints.md).
- Added
  [`hue_discover()`](https://michael-cw.github.io/huer/reference/hue_discover.md),
  [`hue_create_app_key()`](https://michael-cw.github.io/huer/reference/hue_create_app_key.md),
  [`hue_get_application_id()`](https://michael-cw.github.io/huer/reference/hue_get_application_id.md),
  [`hue_bridge()`](https://michael-cw.github.io/huer/reference/hue_bridge.md),
  [`hue_auth()`](https://michael-cw.github.io/huer/reference/hue_auth.md),
  and
  [`hue_eventstream()`](https://michael-cw.github.io/huer/reference/hue_eventstream.md).
- Added
  [`hue_parse_response()`](https://michael-cw.github.io/huer/reference/hue_parse_response.md),
  [`hue_unnest_array()`](https://michael-cw.github.io/huer/reference/hue_unnest_array.md),
  [`hue_payload_light()`](https://michael-cw.github.io/huer/reference/hue_payload_light.md),
  and
  [`hue_resource_identifier()`](https://michael-cw.github.io/huer/reference/hue_resource_identifier.md).
