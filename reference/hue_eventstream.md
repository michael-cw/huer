# Stream Real-Time Events from a Philips Hue Bridge (SSE)

Opens a persistent Server-Sent Events (`text/event-stream`) connection
to `GET /eventstream/clip/v2` on a Philips Hue Bridge v2 or Bridge Pro
and collects or processes real-time resource change events (including
light state changes, button presses, sensor readings, and Bridge Pro
MotionAware updates).

## Usage

``` r
hue_eventstream(
  callback = NULL,
  max_events = 10L,
  timeout = 30,
  bridge = NULL,
  tidy = TRUE
)
```

## Arguments

- callback:

  Optional function invoked for each received SSE event. It receives a
  single argument: the parsed event object (`tibble` when `tidy = TRUE`,
  or a parsed list when `tidy = FALSE`). Return `FALSE` from `callback`
  to stop streaming early.

- max_events:

  Positive integer scalar. Maximum number of SSE events to read before
  closing the connection. Defaults to `10L`.

- timeout:

  Numeric scalar. Total streaming timeout in seconds. Defaults to `30`.

- bridge:

  Optional `hue_bridge` object created by
  [`hue_bridge()`](https://michael-cw.github.io/huer/reference/hue_bridge.md).
  If `NULL`, resolves from session defaults set by
  [`hue_auth()`](https://michael-cw.github.io/huer/reference/hue_auth.md)
  or environment variables.

- tidy:

  Logical scalar. If `TRUE` (default), parses each event's JSON data
  payload into a `tibble` with `jsonlite`. If `FALSE`, returns raw
  parsed lists.

## Value

A list of parsed event objects (invisibly if `callback` is provided).

## See also

[`hue_get_resources()`](https://michael-cw.github.io/huer/reference/hue_resources.md),
[`hue_bridge()`](https://michael-cw.github.io/huer/reference/hue_bridge.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Collect up to 5 real-time bridge events
events <- hue_eventstream(max_events = 5L, timeout = 15)

# Process events live with a callback
hue_eventstream(
  callback = function(ev) {
    print(ev)
    TRUE
  },
  max_events = 20L
)
} # }
```
