# Internal session state for bridge configuration
.huer_env <- new.env(parent = emptyenv())

#' Create a Philips Hue Bridge Client Configuration
#'
#' Constructs a `hue_bridge` S3 configuration object used to authenticate and
#' direct HTTPS requests to a local Philips Hue Bridge (v2 or Bridge Pro)
#' running the CLIP API v2.
#'
#' @param ip Character scalar. IPv4/IPv6 address or hostname of the local
#'   Philips Hue Bridge (e.g., `"192.168.1.50"`). If `NULL`, falls back to
#'   session state set by [hue_auth()] and then the `HUE_BRIDGE_IP` environment
#'   variable.
#' @param app_key Character scalar. Application key (`hue-application-key`)
#'   obtained via [hue_create_app_key()]. If `NULL`, falls back to session
#'   state set by [hue_auth()] and then the `HUE_APP_KEY` environment variable.
#' @param verify_ssl Logical scalar. Whether to verify the bridge TLS
#'   certificate. Defaults to `TRUE`. Because local Philips Hue Bridges present
#'   a self-signed certificate signed by the Hue Bridge Root CA, either supply
#'   `ca_cert` with the path to the Signify Root CA PEM file or explicitly set
#'   `verify_ssl = FALSE` on trusted local networks.
#' @param ca_cert Optional character scalar path to a PEM CA certificate bundle
#'   (such as the Philips Hue Bridge Root CA) used for TLS verification.
#' @param timeout Numeric scalar. Request timeout in seconds. Defaults to `10`.
#'
#' @return An object of class `"hue_bridge"`.
#' @seealso [hue_auth()], [hue_discover()], [hue_create_app_key()]
#' @export
#' @examples
#' bridge <- hue_bridge(
#'   ip = "192.168.1.50",
#'   app_key = "example-application-key",
#'   verify_ssl = FALSE
#' )
#' print(bridge)
hue_bridge <- function(ip = NULL,
                       app_key = NULL,
                       verify_ssl = NULL,
                       ca_cert = NULL,
                       timeout = 10) {
  ip <- ip %||% .huer_env$ip %||% nzchar_or_null(Sys.getenv("HUE_BRIDGE_IP"))
  app_key <- app_key %||% .huer_env$app_key %||%
    nzchar_or_null(Sys.getenv("HUE_APP_KEY"))
  verify_ssl <- verify_ssl %||% .huer_env$verify_ssl %||% TRUE
  ca_cert <- ca_cert %||% .huer_env$ca_cert %||%
    nzchar_or_null(Sys.getenv("HUE_CA_CERT"))

  validate_scalar_chr(ip, "ip")
  validate_scalar_chr(app_key, "app_key")
  validate_scalar_lgl(verify_ssl, "verify_ssl")
  if (!is.null(ca_cert)) {
    validate_scalar_chr(ca_cert, "ca_cert")
  }
  if (!is.numeric(timeout) || length(timeout) != 1L || is.na(timeout) ||
      timeout <= 0) {
    cli::cli_abort(
      "{.arg timeout} must be a single positive number.",
      call = rlang::caller_env()
    )
  }

  # Strip any leading scheme or trailing slash so URL building is predictable
  ip_clean <- sub("^https?://", "", ip)
  ip_clean <- sub("/+$", "", ip_clean)

  structure(
    list(
      ip = ip_clean,
      base_url = paste0("https://", ip_clean),
      app_key = app_key,
      verify_ssl = verify_ssl,
      ca_cert = ca_cert,
      timeout = as.numeric(timeout)
    ),
    class = "hue_bridge"
  )
}

#' @export
print.hue_bridge <- function(x, ...) {
  masked_key <- mask_secret(x$app_key)
  ssl_label <- if (!is.null(x$ca_cert)) {
    paste0("CA bundle (", x$ca_cert, ")")
  } else if (isTRUE(x$verify_ssl)) {
    "verified"
  } else {
    "unverified (local)"
  }

  cli::cli_h3("Philips Hue Bridge Client (CLIP API v2)")
  cli::cli_dl(c(
    "Bridge" = x$base_url,
    "App key" = masked_key,
    "TLS" = ssl_label,
    "Timeout" = paste0(x$timeout, "s")
  ))
  invisible(x)
}

#' Configure Session Credentials for a Philips Hue Bridge
#'
#' Stores, retrieves, or clears default Philips Hue Bridge connection settings
#' in an internal session environment so individual API calls do not need to
#' pass a `bridge` object repeatedly.
#'
#' @inheritParams hue_bridge
#' @param clear Logical scalar. If `TRUE`, clears all stored session settings.
#'
#' @return Invisibly returns a `hue_bridge` object when `ip` and `app_key` are
#'   available, or `NULL` when cleared or unconfigured.
#' @seealso [hue_bridge()], [hue_create_app_key()]
#' @export
#' @examples
#' hue_auth(ip = "192.168.1.50", app_key = "demo-key", verify_ssl = FALSE)
#' hue_auth()
#' hue_auth(clear = TRUE)
hue_auth <- function(ip = NULL,
                     app_key = NULL,
                     verify_ssl = NULL,
                     ca_cert = NULL,
                     clear = FALSE) {
  validate_scalar_lgl(clear, "clear")

  if (isTRUE(clear)) {
    rm(list = ls(envir = .huer_env), envir = .huer_env)
    return(invisible(NULL))
  }

  if (!is.null(ip)) {
    validate_scalar_chr(ip, "ip")
    .huer_env$ip <- ip
  }
  if (!is.null(app_key)) {
    validate_scalar_chr(app_key, "app_key")
    .huer_env$app_key <- app_key
  }
  if (!is.null(verify_ssl)) {
    validate_scalar_lgl(verify_ssl, "verify_ssl")
    .huer_env$verify_ssl <- verify_ssl
  }
  if (!is.null(ca_cert)) {
    validate_scalar_chr(ca_cert, "ca_cert")
    .huer_env$ca_cert <- ca_cert
  }

  has_ip <- !is.null(.huer_env$ip) || nzchar(Sys.getenv("HUE_BRIDGE_IP"))
  has_key <- !is.null(.huer_env$app_key) || nzchar(Sys.getenv("HUE_APP_KEY"))

  if (has_ip && has_key) {
    invisible(hue_bridge())
  } else {
    invisible(NULL)
  }
}

#' Discover Philips Hue Bridges on the Local Network
#'
#' Queries the Philips Hue cloud discovery endpoint
#' (`GET https://discovery.meethue.com/`) to locate Hue Bridges (including
#' Bridge v2 and Bridge Pro) registered on the same public network.
#'
#' @param timeout Numeric scalar. Request timeout in seconds. Defaults to `10`.
#' @param tidy Logical scalar. If `TRUE` (default), parses the JSON response
#'   into a `tbl_json` tibble via `tidyjson`. If `FALSE`, returns the parsed R
#'   list from `jsonlite`.
#'
#' @return A `tbl_json` tibble (or list when `tidy = FALSE`) containing
#'   discovered bridges (`id`, `internalipaddress`, `port`).
#' @seealso [hue_create_app_key()], [hue_bridge()]
#' @export
#' @examples
#' \dontrun{
#' bridges <- hue_discover()
#' bridges
#' }
hue_discover <- function(timeout = 10, tidy = TRUE) {
  validate_scalar_lgl(tidy, "tidy")

  req <- httr2::request("https://discovery.meethue.com/") |>
    httr2::req_user_agent(huer_user_agent()) |>
    httr2::req_timeout(timeout)

  resp <- httr2::req_perform(req)
  body_txt <- httr2::resp_body_string(resp)

  if (!tidy) {
    return(jsonlite::fromJSON(body_txt, simplifyVector = FALSE))
  }

  hue_parse_array(body_txt)
}

#' Create a Philips Hue Application Key
#'
#' Sends `POST https://<ip>/api` to register a new application key
#' (`hue-application-key`) and optional Entertainment DTLS `clientkey` on a
#' local Philips Hue Bridge (v2 or Bridge Pro).
#'
#' @details
#' Before calling `hue_create_app_key()`, you must physically press the round
#' link button on top of the Philips Hue Bridge. If the link button was not
#' pressed within the last 30 seconds, the bridge returns error type `101`
#' (`link button not pressed`).
#'
#' @param ip Character scalar. IPv4/IPv6 address or hostname of the Hue Bridge.
#' @param app_name Character scalar. Application identifier (1-20 ASCII
#'   characters). Defaults to `"huer"`.
#' @param instance_name Character scalar. Device or host identifier (1-19 ASCII
#'   characters). Defaults to the local machine hostname.
#' @param generate_client_key Logical scalar. If `TRUE` (default), also
#'   requests a 32-character hex `clientkey` for Hue Entertainment DTLS
#'   streaming.
#' @param verify_ssl Logical scalar. Whether to verify the bridge TLS
#'   certificate. Defaults to `FALSE` for initial local LAN onboarding; supply
#'   `ca_cert` and `verify_ssl = TRUE` when verifying against the Hue Root CA.
#' @param ca_cert Optional path to a PEM CA certificate bundle.
#' @param timeout Numeric scalar. Request timeout in seconds. Defaults to `10`.
#'
#' @return A `tbl_json` tibble containing `username` (the `hue-application-key`)
#'   and, when requested, `clientkey`.
#' @seealso [hue_auth()], [hue_bridge()], [hue_get_application_id()]
#' @export
#' @examples
#' \dontrun{
#' # Press the physical link button on your Hue Bridge first, then run:
#' creds <- hue_create_app_key("192.168.1.50", app_name = "huer")
#' hue_auth(ip = "192.168.1.50", app_key = creds$username[[1]])
#' }
hue_create_app_key <- function(ip,
                               app_name = "huer",
                               instance_name = Sys.info()[["nodename"]],
                               generate_client_key = TRUE,
                               verify_ssl = FALSE,
                               ca_cert = NULL,
                               timeout = 10) {
  validate_scalar_chr(ip, "ip")
  validate_scalar_chr(app_name, "app_name")
  validate_scalar_chr(instance_name, "instance_name")
  validate_scalar_lgl(generate_client_key, "generate_client_key")
  validate_scalar_lgl(verify_ssl, "verify_ssl")

  ip_clean <- sub("/+$", "", sub("^https?://", "", ip))
  devicetype <- paste0(
    substr(app_name, 1L, 20L),
    "#",
    substr(instance_name, 1L, 19L)
  )

  payload <- list(
    devicetype = devicetype,
    generateclientkey = generate_client_key
  )

  req <- httr2::request(paste0("https://", ip_clean, "/api")) |>
    httr2::req_method("POST") |>
    httr2::req_user_agent(huer_user_agent()) |>
    httr2::req_timeout(timeout) |>
    httr2::req_body_json(payload, auto_unbox = TRUE)

  req <- apply_tls_options(req, verify_ssl = verify_ssl, ca_cert = ca_cert)
  resp <- httr2::req_perform(req)
  body_txt <- httr2::resp_body_string(resp)
  parsed <- jsonlite::fromJSON(body_txt, simplifyVector = FALSE)

  if (length(parsed) > 0L && !is.null(parsed[[1L]]$error)) {
    err <- parsed[[1L]]$error
    cli::cli_abort(c(
      "Philips Hue Bridge rejected application key creation.",
      "x" = "Error {err$type}: {err$description}",
      "i" = "Press the physical link button on the bridge and retry within 30 seconds."
    ))
  }

  if (length(parsed) == 0L || is.null(parsed[[1L]]$success)) {
    cli::cli_abort("Unexpected response from Philips Hue Bridge `/api` endpoint.")
  }

  success_json <- jsonlite::toJSON(
    list(parsed[[1L]]$success),
    auto_unbox = TRUE
  )
  hue_parse_array(as.character(success_json))
}

#' Retrieve the Hue Application Identifier
#'
#' Calls `GET /auth/v1` with the configured `hue-application-key` header to
#' retrieve the `hue-application-id` UUID returned in response headers. This ID
#' is required as the DTLS identity when connecting to the Hue Entertainment
#' streaming API.
#'
#' @param bridge Optional `hue_bridge` object created by [hue_bridge()]. If
#'   `NULL`, resolves from session defaults set by [hue_auth()] or environment
#'   variables.
#'
#' @return A character scalar containing the `hue-application-id` header value.
#' @seealso [hue_create_app_key()], [hue_get_entertainment_configurations()]
#' @export
#' @examples
#' \dontrun{
#' app_id <- hue_get_application_id()
#' }
hue_get_application_id <- function(bridge = NULL) {
  bridge <- resolve_bridge(bridge)
  req <- hue_req_base(bridge, path = "/auth/v1", method = "GET")
  resp <- httr2::req_perform(req)
  app_id <- httr2::resp_header(resp, "hue-application-id")

  if (is.null(app_id) || !nzchar(app_id)) {
    cli::cli_abort(
      "Bridge response from {.path /auth/v1} did not include a {.field hue-application-id} header."
    )
  }

  app_id
}

# Internal helpers -------------------------------------------------------------

resolve_bridge <- function(bridge = NULL, call = rlang::caller_env()) {
  if (is.null(bridge)) {
    return(hue_bridge())
  }
  if (!inherits(bridge, "hue_bridge")) {
    cli::cli_abort(
      "{.arg bridge} must be a {.cls hue_bridge} object created with {.fn hue_bridge}.",
      call = call
    )
  }
  bridge
}

nzchar_or_null <- function(x) {
  if (is.character(x) && length(x) == 1L && !is.na(x) && nzchar(x)) {
    x
  } else {
    NULL
  }
}

mask_secret <- function(x) {
  n <- nchar(x)
  if (n <= 6L) {
    return(paste(rep("*", n), collapse = ""))
  }
  paste0(substr(x, 1L, 4L), "...", substr(x, n - 3L, n))
}

validate_scalar_chr <- function(x, arg, call = rlang::caller_env()) {
  if (!is.character(x) || length(x) != 1L || is.na(x) || !nzchar(x)) {
    cli::cli_abort(
      "{.arg {arg}} must be a single non-empty character string.",
      call = call
    )
  }
  invisible(x)
}

validate_scalar_lgl <- function(x, arg, call = rlang::caller_env()) {
  if (!is.logical(x) || length(x) != 1L || is.na(x)) {
    cli::cli_abort(
      "{.arg {arg}} must be a single non-missing logical value ({.val TRUE} or {.val FALSE}).",
      call = call
    )
  }
  invisible(x)
}

validate_body <- function(body, call = rlang::caller_env()) {
  if (!is.list(body) || length(body) == 0L) {
    cli::cli_abort(
      "{.arg body} must be a non-empty named list representing the JSON payload.",
      call = call
    )
  }
  invisible(body)
}
