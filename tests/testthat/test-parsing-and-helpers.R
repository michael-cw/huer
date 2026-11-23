test_that("hue_parse_response handles objects, heterogeneous rows, nulls, empty data, and tidy = FALSE", {
  json_ok <- paste0(
    '{"errors":[],"data":[',
    '{"id":"l-1","type":"light","metadata":{"name":"Lamp"},',
    '"on":{"on":true},"dimming":{"brightness":62.5},',
    '"color_temperature":{"mirek":null},',
    '"effects":{"effect_values":["no_effect","candle"]}},',
    '{"id":"p-1","type":"light","metadata":{"name":"Smart Plug"},',
    '"on":{"on":false}}]}'
  )

  res <- hue_parse_response(json_ok)
  expect_s3_class(res, "tbl_df")
  expect_identical(nrow(res), 2L)
  expect_identical(res$id, c("l-1", "p-1"))
  expect_identical(res$metadata.name, c("Lamp", "Smart Plug"))
  expect_identical(res$on.on, c(TRUE, FALSE))
  expect_equal(res$dimming.brightness, c(62.5, NA_real_))
  expect_true(all(is.na(res$color_temperature.mirek)))
  expect_identical(res$effects.effect_values[[1L]], c("no_effect", "candle"))
  expect_null(res$effects.effect_values[[2L]])

  res_raw <- hue_parse_response(json_ok, tidy = FALSE)
  expect_type(res_raw, "list")
  expect_identical(res_raw$data[[1]]$id, "l-1")

  empty <- hue_parse_response('{"errors":[],"data":[]}')
  expect_s3_class(empty, "tbl_df")
  expect_identical(nrow(empty), 0L)

  expect_error(hue_parse_response('{"errors":[]}'), "data")
})

test_that("hue_unnest_array expands nested JSON arrays, handles empty rows and scalar arrays", {
  room_json <- paste0(
    '{"errors":[],"data":[',
    '{"id":"room-1","type":"room","metadata":{"name":"Office"},',
    '"children":[{"rid":"dev-1","rtype":"device"},{"rid":"dev-2","rtype":"device"}]},',
    '{"id":"room-2","type":"room","metadata":{"name":"Hallway"},"children":[]}]}'
  )

  rooms <- hue_parse_response(room_json)
  expect_s3_class(rooms, "tbl_df")
  expect_true("children" %in% names(rooms))
  expect_s3_class(rooms$children[[1L]], "tbl_df")

  children <- hue_unnest_array(rooms, "children")
  expect_s3_class(children, "tbl_df")
  expect_identical(nrow(children), 2L)
  expect_identical(children$rid, c("dev-1", "dev-2"))
  expect_identical(children$rtype, c("device", "device"))
  expect_identical(children$metadata.name, c("Office", "Office"))
  expect_false("children" %in% names(children))

  # Scalar array unnesting
  light_json <- paste0(
    '{"errors":[],"data":[{"id":"l-1","effects":{"effect_values":["candle","fire"]}}]}'
  )
  lights <- hue_parse_response(light_json)
  fx <- hue_unnest_array(lights, "effects.effect_values")
  expect_identical(nrow(fx), 2L)
  expect_identical(fx$effects.effect_values, c("candle", "fire"))

  # Validation errors
  expect_error(hue_unnest_array(list(), "children"), "tibble")
  expect_error(hue_unnest_array(rooms, "nonexistent"), "not found")
  expect_error(hue_unnest_array(rooms, "id"), "not a list-column")
})

test_that("hue_payload_light and hue_resource_identifier build valid payloads", {
  ref <- hue_resource_identifier("uuid-1", "device")
  expect_identical(ref, list(rid = "uuid-1", rtype = "device"))

  p <- hue_payload_light(
    on = TRUE,
    brightness = 55,
    mirek = 280,
    xy = c(0.32, 0.33),
    effect = "candle",
    dynamics_duration = 1000,
    alert = "breathe",
    metadata = list(name = "Desk")
  )

  expect_true(p$on$on)
  expect_equal(p$dimming$brightness, 55)
  expect_identical(p$color_temperature$mirek, 280L)
  expect_equal(p$color$xy$x, 0.32)
  expect_equal(p$color$xy$y, 0.33)
  expect_identical(p$effects$effect, "candle")
  expect_identical(p$dynamics$duration, 1000L)
  expect_identical(p$alert$action, "breathe")
  expect_identical(p$metadata$name, "Desk")

  expect_error(hue_payload_light(), "At least one")
  expect_error(hue_payload_light(brightness = 150), "between 0 and 100")
  expect_error(hue_payload_light(mirek = 900), "between 153 and 500")
  expect_error(hue_payload_light(xy = c(0.5, 1.5)), "length 2")
})

test_that("HTTP errors and HTTP 207 partial errors surface Hue descriptions", {
  b <- hue_bridge(ip = "192.168.1.50", app_key = "test-key", verify_ssl = FALSE)

  httr2::local_mocked_responses(function(req) {
    httr2::response_json(
      status_code = 404L,
      body = list(
        errors = list(list(description = "resource not found")),
        data = list()
      )
    )
  })

  expect_error(hue_get_light("missing-id", bridge = b), "resource not found")

  httr2::local_mocked_responses(function(req) {
    httr2::response_json(
      status_code = 207L,
      body = list(
        errors = list(list(description = "device soft unreachable")),
        data = list(list(rid = "l-1", rtype = "light"))
      )
    )
  })

  expect_warning(
    out <- hue_update_light("l-1", body = list(on = list(on = TRUE)), bridge = b),
    "device soft unreachable"
  )
  expect_identical(out$rid, "l-1")
})
