# huer 0.1.0

* Initial release of `huer`, providing complete `httr2`, `tidyjson`, and `cli`
  support for the Philips Hue CLIP API v2 and Hue Bridge Pro.
* Added typed `GET`, `POST`, `PUT`, and `DELETE` wrappers for all 41 CLIP API
  v2 and Bridge Pro resource types, plus generic `hue_resource_*()` helpers and
  `hue_endpoints()`.
* Added `hue_discover()`, `hue_create_app_key()`, `hue_get_application_id()`,
  `hue_bridge()`, `hue_auth()`, and `hue_eventstream()`.
* Added `hue_parse_response()`, `hue_unnest_array()`, `hue_payload_light()`,
  and `hue_resource_identifier()`.
