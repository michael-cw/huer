## R CMD check results

0 errors | 0 warnings | 0 notes

## Submission notes

* This is a new CRAN submission.
* Network-dependent examples requiring a physical local Philips Hue Bridge are
  wrapped in `\dontrun{}`, while all offline functions (`hue_bridge()`,
  `hue_auth()`, `hue_endpoints()`, `hue_parse_response()`,
  `hue_unnest_array()`, `hue_payload_light()`, `hue_resource_identifier()`)
  have runnable examples tested during `R CMD check`.
* Unit tests cover all HTTP verbs, endpoints, error paths, and `tidyjson`
  parsing using `httr2::local_mocked_responses()` with no live network access.
