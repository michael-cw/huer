test_that("hue_eventstream validates arguments before opening a connection", {
  b <- hue_bridge(ip = "192.168.1.50", app_key = "test-key", verify_ssl = FALSE)

  expect_error(
    hue_eventstream(callback = "not-a-fn", bridge = b),
    "function"
  )
  expect_error(
    hue_eventstream(max_events = 0L, bridge = b),
    "positive integer"
  )
  expect_error(
    hue_eventstream(timeout = -5, bridge = b),
    "positive number"
  )
  expect_error(
    hue_eventstream(tidy = "yes", bridge = b),
    "logical"
  )
})
