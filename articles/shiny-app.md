# Building a Shiny Hue Controller with huer

This vignette walks through building an interactive **Shiny** dashboard
powered by `huer` to select **Rooms** and **Zones** on your local
Philips Hue Bridge (v2 or Bridge Pro), adjust group-level lighting
(`grouped_light`), recall scenes, and control individual lights inside
each room or zone.

## Architecture & Packages

The application uses four packages:

- `huer` — connects to the Philips Hue CLIP API v2 via `httr2` and
  parses JSON responses into `tidyjson` tibbles.
- `shiny` — provides the reactive web application framework.
- `bslib` — provides a modern Bootstrap 5 sidebar layout
  ([`page_sidebar()`](https://rstudio.github.io/bslib/reference/page_sidebar.html)),
  cards, tabs, and value boxes.
- `DT` — renders an interactive status table of the lights inside the
  selected room or zone.

Install the UI packages if you do not already have them:

``` r

install.packages(c("shiny", "bslib", "DT"))
```

Create a directory for your app (for example `shiny_hue_control/app.R`)
and assemble the components described below.

## Step 1: Understanding the CLIP API v2 Resource Graph

In the Philips Hue CLIP API v2, rooms, zones, grouped lights, individual
lights, and scenes are connected via `rid` / `rtype` references stored
inside nested JSON arrays (`children` and `services`):

- A **room**
  ([`hue_get_rooms()`](https://michael-cw.github.io/huer/reference/hue_groups.md))
  lists its member hardware devices in `children` (`rtype == "device"`)
  and its group light controller in `services`
  (`rtype == "grouped_light"`). Each **light**
  ([`hue_get_lights()`](https://michael-cw.github.io/huer/reference/hue_lighting.md))
  points back to its parent device via `owner.rid`.
- A **zone**
  ([`hue_get_zones()`](https://michael-cw.github.io/huer/reference/hue_groups.md))
  lists its member lights directly in `children` (`rtype == "light"`)
  and its group controller in `services` (`rtype == "grouped_light"`).
- A **scene**
  ([`hue_get_scenes()`](https://michael-cw.github.io/huer/reference/hue_scenes.md))
  links to its room or zone via `group.rid`.

Because `huer` returns `tbl_json` objects,
[`hue_unnest_array()`](https://michael-cw.github.io/huer/reference/hue_unnest_array.md)
resolves these relationships in a single line:

``` r

library(huer)

sample_room_json <- paste0(
  '{"errors":[],"data":[{"id":"room-1","type":"room",',
  '"metadata":{"name":"Living Room"},',
  '"children":[{"rid":"dev-1","rtype":"device"}],',
  '"services":[{"rid":"gl-1","rtype":"grouped_light"}]}]}'
)

sample_light_json <- paste0(
  '{"errors":[],"data":[{"id":"light-1","type":"light",',
  '"owner":{"rid":"dev-1","rtype":"device"},',
  '"metadata":{"name":"Floor Lamp"},',
  '"on":{"on":true},"dimming":{"brightness":80}}]}'
)

rooms <- hue_parse_response(sample_room_json)
lights <- hue_parse_response(sample_light_json)

# 1. Resolve the room's grouped_light ID
services <- hue_unnest_array(rooms, "services")
grouped_light_id <- services$rid[services$rtype == "grouped_light"][[1L]]
grouped_light_id
#> [1] "gl-1"

# 2. Resolve all lights inside the room (matching both light and device children)
children <- hue_unnest_array(rooms, "children")
room_lights <- lights[
  lights$id %in% children$rid[children$rtype == "light"] |
    lights$owner.rid %in% children$rid[children$rtype == "device"],
  ,
  drop = FALSE
]
room_lights[, c("id", "metadata.name", "on.on", "dimming.brightness")]
#> # A tibble: 1 × 5
#>   ..JSON                   id      metadata.name on.on dimming.brightness
#>   <chr>                    <chr>   <chr>         <lgl>              <dbl>
#> 1 "{\"id\":\"light-1\"..." light-1 Floor Lamp    TRUE                  80
```

## Step 2: Converting Hex Colors to CIE 1931 xy

Philips Hue lights expect color chromaticity as CIE 1931 `xy`
coordinates (`hue_payload_light(xy = c(x, y))`), whereas HTML5
`<input type="color">` controls emit sRGB hex strings like `"#ff8800"`.
Add a compact helper using base R’s
[`grDevices::col2rgb()`](https://rdrr.io/r/grDevices/col2rgb.html) and
the Wide RGB D65 matrix recommended by Philips Hue:

``` r

hex_to_cie_xy <- function(hex) {
  rgb <- as.numeric(grDevices::col2rgb(hex)) / 255

  # Inverse sRGB gamma companding
  lin <- ifelse(
    rgb > 0.04045,
    ((rgb + 0.055) / 1.055)^2.4,
    rgb / 12.92
  )

  # Wide RGB D65 -> CIE XYZ
  X <- lin[1] * 0.664511 + lin[2] * 0.154324 + lin[3] * 0.162028
  Y <- lin[1] * 0.283881 + lin[2] * 0.668433 + lin[3] * 0.047685
  Z <- lin[1] * 0.000088 + lin[2] * 0.072310 + lin[3] * 0.986039

  denom <- X + Y + Z
  if (denom == 0) return(c(0.3127, 0.3290))

  c(round(max(0, min(1, X / denom)), 4),
    round(max(0, min(1, Y / denom)), 4))
}

xy <- hex_to_cie_xy("#ff8800")
xy
#> [1] 0.6010 0.3837

# Ready to pass straight into hue_payload_light()
hue_payload_light(on = TRUE, brightness = 80, xy = xy, dynamics_duration = 400)
#> $on
#> $on$on
#> [1] TRUE
#> 
#> 
#> $dimming
#> $dimming$brightness
#> [1] 80
#> 
#> 
#> $color
#> $color$xy
#> $color$xy$x
#> [1] 0.601
#> 
#> $color$xy$y
#> [1] 0.3837
#> 
#> 
#> 
#> $dynamics
#> $dynamics$duration
#> [1] 400
```

For a zero-dependency native HTML5 color picker in Shiny, wrap an
`<input type="color">` tag that pushes updates via
`Shiny.setInputValue()`:

``` r

color_input <- function(inputId, label, value = "#ffcf70") {
  tags$div(
    class = "mb-3",
    tags$label(label, `for` = inputId, class = "form-label d-block"),
    tags$input(
      id = inputId,
      type = "color",
      value = value,
      class = "form-control form-control-color w-100",
      style = "height: 40px; cursor: pointer;",
      onchange = sprintf(
        "Shiny.setInputValue('%s', this.value, {priority: 'event'})",
        inputId
      )
    )
  )
}
```

## Step 3: Designing the `bslib` User Interface

Use
[`bslib::page_sidebar()`](https://rstudio.github.io/bslib/reference/page_sidebar.html)
with a sidebar for bridge connection and room/zone selection, top
summary
[`value_box()`](https://rstudio.github.io/bslib/reference/value_box.html)
cards, and a two-tab main workspace:

1.  **Group & Scene Controls**: Targets the selected room or zone’s
    `grouped_light` service
    ([`hue_update_grouped_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md))
    and recalls scenes belonging to that group
    ([`hue_recall_scene()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)).
2.  **Individual Lights**: Displays a clickable `DT` table of all lights
    in the selected group alongside per-light controls
    ([`hue_update_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)).

``` r

library(shiny)
library(bslib)
library(DT)
library(huer)

HUE_EFFECTS <- c(
  "No effect" = "no_effect", "Candle" = "candle", "Fire" = "fire",
  "Prism" = "prism", "Sparkle" = "sparkle", "Opal" = "opal",
  "Glisten" = "glisten", "Underwater" = "underwater", "Cosmos" = "cosmos",
  "Sunbeam" = "sunbeam", "Enchant" = "enchant"
)

ui <- page_sidebar(
  title = "huer — Philips Hue Bridge Controller",
  theme = bs_theme(version = 5, bootswatch = "darkly", primary = "#f59e0b"),
  sidebar = sidebar(
    width = 320,
    textInput("bridge_ip", "Bridge IP", value = Sys.getenv("HUE_BRIDGE_IP")),
    passwordInput("app_key", "Application Key", value = Sys.getenv("HUE_APP_KEY")),
    checkboxInput("verify_ssl", "Verify TLS certificate", value = FALSE),
    layout_columns(
      col_widths = c(6, 6),
      actionButton("discover_btn", "Discover", class = "btn-outline-secondary btn-sm w-100"),
      actionButton("connect_btn", "Connect", class = "btn-primary btn-sm w-100")
    ),
    hr(),
    radioButtons(
      "group_kind", "Group Type",
      choices = c("Rooms" = "room", "Zones" = "zone"),
      inline = TRUE
    ),
    selectInput("selected_group", "Select Room / Zone", choices = character(0)),
    actionButton("refresh_btn", "Refresh State", class = "btn-outline-info btn-sm w-100")
  ),

  navset_card_tab(
    nav_panel(
      "Group & Scene Controls",
      layout_columns(
        col_widths = c(7, 5),
        card(
          card_header("Room / Zone Lighting (grouped_light)"),
          card_body(
            layout_columns(
              col_widths = c(6, 6),
              actionButton("grp_on_btn", "Turn Group On", class = "btn-warning w-100"),
              actionButton("grp_off_btn", "Turn Group Off", class = "btn-outline-light w-100")
            ),
            sliderInput("grp_brightness", "Brightness (%)", 1, 100, 75),
            sliderInput("grp_mirek", "Color Temp (mirek)", 153, 500, 300),
            sliderInput("grp_duration", "Transition (ms)", 0, 5000, 400, step = 100),
            actionButton("grp_apply_white", "Apply Brightness & Temp", class = "btn-primary w-100"),
            hr(),
            color_input("grp_color", "Group Color (CIE xy)"),
            selectInput("grp_effect", "Effect", choices = HUE_EFFECTS),
            layout_columns(
              col_widths = c(6, 6),
              actionButton("grp_apply_color", "Apply Color", class = "btn-info w-100"),
              actionButton("grp_apply_effect", "Apply Effect", class = "btn-outline-info w-100")
            )
          )
        ),
        card(
          card_header("Scenes in Selected Group"),
          card_body(
            selectInput("selected_scene", "Scene", choices = character(0)),
            sliderInput("scene_duration", "Transition (ms)", 0, 5000, 500, step = 100),
            actionButton("scene_recall_active", "Activate Scene", class = "btn-success w-100")
          )
        )
      )
    ),

    nav_panel(
      "Individual Lights",
      layout_columns(
        col_widths = c(7, 5),
        card(card_header("Lights in Group"), DTOutput("lights_table")),
        card(
          card_header("Selected Light Controls"),
          selectInput("selected_light", "Choose Light", choices = character(0)),
          checkboxInput("light_on", "Power On", value = TRUE),
          sliderInput("light_brightness", "Brightness (%)", 1, 100, 75),
          sliderInput("light_mirek", "Color Temp (mirek)", 153, 500, 300),
          color_input("light_color", "Color (CIE xy)"),
          selectInput("light_effect", "Effect", choices = HUE_EFFECTS),
          layout_columns(
            col_widths = c(6, 6),
            actionButton("light_apply_white", "Apply Power / Temp", class = "btn-primary w-100"),
            actionButton("light_apply_color", "Apply Color", class = "btn-info w-100")
          )
        )
      )
    )
  )
)
```

## Step 4: Wiring the Reactive Server Logic

Store the `hue_bridge` client and fetched resource tables in
`reactiveValues()`. Whenever the user connects or sends a `PUT` update,
call `refresh_state()` so all tables, dropdowns, and KPI cards reflect
the bridge’s live state:

``` r

server <- function(input, output, session) {
  rv <- reactiveValues(
    bridge = NULL,
    rooms = NULL, zones = NULL, lights = NULL,
    grouped_lights = NULL, scenes = NULL
  )

  refresh_state <- function() {
    req(rv$bridge)
    rv$rooms <- hue_get_rooms(bridge = rv$bridge)
    rv$zones <- hue_get_zones(bridge = rv$bridge)
    rv$lights <- hue_get_lights(bridge = rv$bridge)
    rv$grouped_lights <- hue_get_grouped_lights(bridge = rv$bridge)
    rv$scenes <- hue_get_scenes(bridge = rv$bridge)
  }

  # Bridge discovery (GET https://discovery.meethue.com/)
  observeEvent(input$discover_btn, {
    found <- hue_discover()
    if (nrow(found) > 0L) {
      updateTextInput(session, "bridge_ip", value = found$internalipaddress[[1L]])
    }
  })

  # Connect to the local bridge
  observeEvent(input$connect_btn, {
    rv$bridge <- hue_bridge(
      ip = trimws(input$bridge_ip),
      app_key = trimws(input$app_key),
      verify_ssl = isTRUE(input$verify_ssl)
    )
    refresh_state()
  })

  observeEvent(input$refresh_btn, refresh_state())

  # Populate room/zone choices
  active_groups <- reactive({
    req(rv$rooms, rv$zones)
    if (identical(input$group_kind, "room")) rv$rooms else rv$zones
  })

  observe({
    grp <- active_groups()
    choices <- setNames(grp$id, grp$metadata.name)
    updateSelectInput(session, "selected_group", choices = choices)
  })

  selected_group_row <- reactive({
    grp <- active_groups()
    req(nzchar(input$selected_group))
    grp[grp$id == input$selected_group, , drop = FALSE]
  })

  # Resolve grouped_light ID for the selected room/zone
  selected_grouped_light_id <- reactive({
    svcs <- hue_unnest_array(selected_group_row(), "services")
    gl <- svcs[svcs$rtype == "grouped_light", , drop = FALSE]
    if (nrow(gl) == 0L) NULL else gl$rid[[1L]]
  })

  # Resolve member lights for the selected room/zone
  group_lights <- reactive({
    children <- hue_unnest_array(selected_group_row(), "children")
    keep <- (rv$lights$id %in% children$rid[children$rtype == "light"]) |
      (rv$lights$owner.rid %in% children$rid[children$rtype == "device"])
    rv$lights[keep, , drop = FALSE]
  })

  # Populate individual light & scene dropdowns
  observe({
    lt <- group_lights()
    updateSelectInput(session, "selected_light", choices = setNames(lt$id, lt$metadata.name))
  })

  observe({
    row <- selected_group_row()
    sc <- rv$scenes[rv$scenes$group.rid == row$id[[1L]], , drop = FALSE]
    updateSelectInput(session, "selected_scene", choices = setNames(sc$id, sc$metadata.name))
  })

  # Render interactive lights table
  output$lights_table <- renderDT({
    lt <- group_lights()
    datatable(
      tibble::tibble(
        Name = lt$metadata.name,
        State = ifelse(lt$on.on, "ON", "OFF"),
        Brightness = round(lt$dimming.brightness, 1)
      ),
      selection = "single",
      rownames = FALSE
    )
  })

  # Group lighting updates (PUT /clip/v2/resource/grouped_light/{id})
  observeEvent(input$grp_on_btn, {
    hue_update_grouped_light(
      selected_grouped_light_id(),
      hue_payload_light(on = TRUE, dynamics_duration = input$grp_duration),
      bridge = rv$bridge
    )
    refresh_state()
  })

  observeEvent(input$grp_off_btn, {
    hue_update_grouped_light(
      selected_grouped_light_id(),
      hue_payload_light(on = FALSE, dynamics_duration = input$grp_duration),
      bridge = rv$bridge
    )
    refresh_state()
  })

  observeEvent(input$grp_apply_white, {
    hue_update_grouped_light(
      selected_grouped_light_id(),
      hue_payload_light(
        on = TRUE,
        brightness = input$grp_brightness,
        mirek = input$grp_mirek,
        dynamics_duration = input$grp_duration
      ),
      bridge = rv$bridge
    )
    refresh_state()
  })

  observeEvent(input$grp_apply_color, {
    hue_update_grouped_light(
      selected_grouped_light_id(),
      hue_payload_light(
        on = TRUE,
        brightness = input$grp_brightness,
        xy = hex_to_cie_xy(input$grp_color),
        dynamics_duration = input$grp_duration
      ),
      bridge = rv$bridge
    )
    refresh_state()
  })

  observeEvent(input$grp_apply_effect, {
    hue_update_grouped_light(
      selected_grouped_light_id(),
      hue_payload_light(on = TRUE, effect = input$grp_effect),
      bridge = rv$bridge
    )
    refresh_state()
  })

  # Scene recall (PUT /clip/v2/resource/scene/{id})
  observeEvent(input$scene_recall_active, {
    req(nzchar(input$selected_scene))
    hue_recall_scene(
      id = input$selected_scene,
      action = "active",
      duration = input$scene_duration,
      bridge = rv$bridge
    )
    refresh_state()
  })

  # Individual light updates (PUT /clip/v2/resource/light/{id})
  observeEvent(input$light_apply_white, {
    req(nzchar(input$selected_light))
    payload <- if (isTRUE(input$light_on)) {
      hue_payload_light(on = TRUE, brightness = input$light_brightness, mirek = input$light_mirek)
    } else {
      hue_payload_light(on = FALSE)
    }
    hue_update_light(input$selected_light, payload, bridge = rv$bridge)
    refresh_state()
  })

  observeEvent(input$light_apply_color, {
    req(nzchar(input$selected_light))
    hue_update_light(
      input$selected_light,
      hue_payload_light(
        on = TRUE,
        brightness = input$light_brightness,
        xy = hex_to_cie_xy(input$light_color)
      ),
      bridge = rv$bridge
    )
    refresh_state()
  })
}

shinyApp(ui = ui, server = server)
```

## Step 5: Running the App Locally

Save the script as `app.R` and launch it from RStudio (**Run App**) or
the R console:

``` r

Sys.setenv(
  HUE_BRIDGE_IP = "192.168.1.50",
  HUE_APP_KEY = "your-hue-application-key"
)
shiny::runApp("path/to/shiny_hue_control")
```

To harden the app for production or multi-room setups, wrap API calls in
[`tryCatch()`](https://rdrr.io/r/base/conditions.html) with
`shiny::showNotification()`, guard optional columns (such as
`color_temperature.mirek` on white-only dimmable bulbs), and sync
individual light sliders whenever a row is clicked in `lights_table`.
