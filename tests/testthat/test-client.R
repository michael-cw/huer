test_that("hue_bridge validates inputs and prints masked key", {
  hue_auth(clear = TRUE)
  on.exit(hue_auth(clear = TRUE), add = TRUE)

  b <- hue_bridge(
    ip = "https://192.168.1.50/",
    app_key = "abcdefgh12345678",
    verify_ssl = FALSE,
    timeout = 5
  )
  expect_s3_class(b, "hue_bridge")
  expect_identical(b$ip, "192.168.1.50")
  expect_identical(b$base_url, "https://192.168.1.50")
  expect_false(b$verify_ssl)
  expect_identical(b$timeout, 5)

  out <- capture.output(print(b), type = "message")
  expect_true(any(grepl("abcd\\.\\.\\.5678", out)))
  expect_false(any(grepl("abcdefgh12345678", out)))

  expect_error(hue_bridge(ip = "", app_key = "key"), "non-empty character")
  expect_error(hue_bridge(ip = "192.168.1.1", app_key = "key", timeout = -1), "positive number")
})

test_that("hue_auth stores, retrieves, and clears session credentials", {
  hue_auth(clear = TRUE)
  on.exit(hue_auth(clear = TRUE), add = TRUE)

  expect_null(hue_auth())
  b <- hue_auth(ip = "10.0.0.2", app_key = "session-key-1234", verify_ssl = FALSE)
  expect_s3_class(b, "hue_bridge")

  b2 <- hue_bridge()
  expect_identical(b2$ip, "10.0.0.2")
  expect_identical(b2$app_key, "session-key-1234")
  expect_false(b2$verify_ssl)

  hue_auth(clear = TRUE)
  expect_null(hue_auth())
})

test_that("hue_discover parses bridge discovery array", {
  httr2::local_mocked_responses(function(req) {
    expect_identical(req$url, "https://discovery.meethue.com/")
    httr2::response_json(
      status_code = 200L,
      body = list(list(id = "001788fffe000001", internalipaddress = "192.168.1.42", port = 443L))
    )
  })

  res <- hue_discover()
  expect_s3_class(res, "tbl_df")
  expect_identical(res$internalipaddress, "192.168.1.42")
  expect_identical(res$id, "001788fffe000001")

  raw_res <- hue_discover(tidy = FALSE)
  expect_type(raw_res, "list")
  expect_identical(raw_res[[1]]$internalipaddress, "192.168.1.42")
})

test_that("hue_create_app_key handles success and link button errors", {
  httr2::local_mocked_responses(function(req) {
    expect_identical(req$method, "POST")
    expect_identical(req$url, "https://192.168.1.42/api")
    httr2::response_json(
      status_code = 200L,
      body = list(list(success = list(username = "new-app-key", clientkey = "DEADBEAF")))
    )
  })

  creds <- hue_create_app_key("192.168.1.42", app_name = "huer", instance_name = "mac")
  expect_s3_class(creds, "tbl_df")
  expect_identical(creds$username, "new-app-key")
  expect_identical(creds$clientkey, "DEADBEAF")

  httr2::local_mocked_responses(function(req) {
    httr2::response_json(
      status_code = 200L,
      body = list(list(error = list(type = 101L, description = "link button not pressed")))
    )
  })

  expect_error(
    hue_create_app_key("192.168.1.42"),
    "link button not pressed"
  )
})

test_that("hue_get_application_id extracts hue-application-id header", {
  b <- hue_bridge(ip = "192.168.1.42", app_key = "test-key", verify_ssl = FALSE)

  httr2::local_mocked_responses(function(req) {
    expect_identical(req$url, "https://192.168.1.42/auth/v1")
    expect_identical(req$headers[["hue-application-key"]], "test-key")
    httr2::response(
      status_code = 200L,
      headers = list(`hue-application-id` = "app-uuid-9999")
    )
  })

  expect_identical(hue_get_application_id(bridge = b), "app-uuid-9999")
})
