test_that("hue_endpoints returns all 41 CLIP v2 and Bridge Pro resources", {
  ep <- hue_endpoints()
  expect_s3_class(ep, "tbl_df")
  expect_identical(nrow(ep), 41L)
  expect_true(all(c("motion_area_configuration", "motion_area_candidate",
                    "convenience_area_motion", "security_area_motion",
                    "service_group", "wifi_connectivity", "speaker",
                    "bell_button", "contact", "tamper", "camera_motion") %in%
                    ep$resource))
  expect_true(all(ep$get))
})

test_that("root resource and generic CRUD functions dispatch correct verbs and paths", {
  b <- hue_bridge(ip = "192.168.1.50", app_key = "secret-key", verify_ssl = FALSE)
  seen <- list()

  httr2::local_mocked_responses(function(req) {
    seen[[length(seen) + 1L]] <<- list(
      method = req$method,
      url = req$url,
      key = req$headers[["hue-application-key"]]
    )
    httr2::response_json(
      status_code = 200L,
      body = list(errors = list(), data = list(list(id = "res-1", type = "light")))
    )
  })

  hue_get_resources(bridge = b)
  hue_resource_get("light", bridge = b)
  hue_resource_get("light", id = "id-1", bridge = b)
  hue_resource_post("room", body = list(metadata = list(name = "Den")), bridge = b)
  hue_resource_put("room", id = "id-2", body = list(metadata = list(name = "Den 2")), bridge = b)
  hue_resource_delete("room", id = "id-2", bridge = b)

  expect_identical(seen[[1]]$method, "GET")
  expect_identical(seen[[1]]$url, "https://192.168.1.50/clip/v2/resource")
  expect_identical(seen[[2]]$url, "https://192.168.1.50/clip/v2/resource/light")
  expect_identical(seen[[3]]$url, "https://192.168.1.50/clip/v2/resource/light/id-1")
  expect_identical(seen[[4]]$method, "POST")
  expect_identical(seen[[4]]$url, "https://192.168.1.50/clip/v2/resource/room")
  expect_identical(seen[[5]]$method, "PUT")
  expect_identical(seen[[5]]$url, "https://192.168.1.50/clip/v2/resource/room/id-2")
  expect_identical(seen[[6]]$method, "DELETE")
  expect_identical(seen[[6]]$url, "https://192.168.1.50/clip/v2/resource/room/id-2")
  expect_true(all(vapply(seen, function(x) identical(x$key, "secret-key"), logical(1L))))
})

test_that("all typed GET, POST, PUT, DELETE endpoint wrappers map to exact CLIP v2 paths", {
  b <- hue_bridge(ip = "192.168.1.50", app_key = "secret-key", verify_ssl = FALSE)
  last_req <- NULL

  httr2::local_mocked_responses(function(req) {
    last_req <<- req
    httr2::response_json(
      status_code = 200L,
      body = list(errors = list(), data = list(list(id = "u-1", type = "ok")))
    )
  })

  check_call <- function(fn, args, expected_method, expected_path) {
    do.call(fn, c(args, list(bridge = b)))
    expect_identical(last_req$method, expected_method, info = expected_path)
    expect_identical(
      last_req$url,
      paste0("https://192.168.1.50/clip/v2/resource/", expected_path),
      info = expected_path
    )
  }

  payload <- list(enabled = TRUE)

  # All 41 resources: plural GET & singular GET/{id}
  get_specs <- list(
    list(hue_get_lights, hue_get_light, "light"),
    list(hue_get_grouped_lights, hue_get_grouped_light, "grouped_light"),
    list(hue_get_rooms, hue_get_room, "room"),
    list(hue_get_zones, hue_get_zone, "zone"),
    list(hue_get_bridge_homes, hue_get_bridge_home, "bridge_home"),
    list(hue_get_service_groups, hue_get_service_group, "service_group"),
    list(hue_get_scenes, hue_get_scene, "scene"),
    list(hue_get_smart_scenes, hue_get_smart_scene, "smart_scene"),
    list(hue_get_devices, hue_get_device, "device"),
    list(hue_get_device_powers, hue_get_device_power, "device_power"),
    list(hue_get_device_software_updates, hue_get_device_software_update, "device_software_update"),
    list(hue_get_bridges, hue_get_bridge, "bridge"),
    list(hue_get_motions, hue_get_motion, "motion"),
    list(hue_get_grouped_motions, hue_get_grouped_motion, "grouped_motion"),
    list(hue_get_camera_motions, hue_get_camera_motion, "camera_motion"),
    list(hue_get_temperatures, hue_get_temperature, "temperature"),
    list(hue_get_light_levels, hue_get_light_level, "light_level"),
    list(hue_get_grouped_light_levels, hue_get_grouped_light_level, "grouped_light_level"),
    list(hue_get_buttons, hue_get_button, "button"),
    list(hue_get_bell_buttons, hue_get_bell_button, "bell_button"),
    list(hue_get_relative_rotaries, hue_get_relative_rotary, "relative_rotary"),
    list(hue_get_contacts, hue_get_contact, "contact"),
    list(hue_get_tampers, hue_get_tamper, "tamper"),
    list(hue_get_motion_area_configurations, hue_get_motion_area_configuration, "motion_area_configuration"),
    list(hue_get_motion_area_candidates, hue_get_motion_area_candidate, "motion_area_candidate"),
    list(hue_get_convenience_area_motions, hue_get_convenience_area_motion, "convenience_area_motion"),
    list(hue_get_security_area_motions, hue_get_security_area_motion, "security_area_motion"),
    list(hue_get_zigbee_connectivities, hue_get_zigbee_connectivity, "zigbee_connectivity"),
    list(hue_get_zgp_connectivities, hue_get_zgp_connectivity, "zgp_connectivity"),
    list(hue_get_wifi_connectivities, hue_get_wifi_connectivity, "wifi_connectivity"),
    list(hue_get_zigbee_device_discoveries, hue_get_zigbee_device_discovery, "zigbee_device_discovery"),
    list(hue_get_entertainments, hue_get_entertainment, "entertainment"),
    list(hue_get_entertainment_configurations, hue_get_entertainment_configuration, "entertainment_configuration"),
    list(hue_get_speakers, hue_get_speaker, "speaker"),
    list(hue_get_behavior_scripts, hue_get_behavior_script, "behavior_script"),
    list(hue_get_behavior_instances, hue_get_behavior_instance, "behavior_instance"),
    list(hue_get_geofence_clients, hue_get_geofence_client, "geofence_client"),
    list(hue_get_geolocations, hue_get_geolocation, "geolocation"),
    list(hue_get_homekits, hue_get_homekit, "homekit"),
    list(hue_get_matters, hue_get_matter, "matter"),
    list(hue_get_matter_fabrics, hue_get_matter_fabric, "matter_fabric")
  )

  expect_identical(length(get_specs), nrow(hue_endpoints()))

  for (sp in get_specs) {
    check_call(sp[[1]], list(), "GET", sp[[3]])
    check_call(sp[[2]], list(id = "u-1"), "GET", paste0(sp[[3]], "/u-1"))
  }

  # All POST endpoints
  post_specs <- list(
    list(hue_create_room, "room"),
    list(hue_create_zone, "zone"),
    list(hue_create_service_group, "service_group"),
    list(hue_create_scene, "scene"),
    list(hue_create_smart_scene, "smart_scene"),
    list(hue_create_motion_area_configuration, "motion_area_configuration"),
    list(hue_create_entertainment_configuration, "entertainment_configuration"),
    list(hue_create_behavior_instance, "behavior_instance"),
    list(hue_create_geofence_client, "geofence_client")
  )

  expect_identical(length(post_specs), sum(hue_endpoints()$post))

  for (sp in post_specs) {
    check_call(sp[[1]], list(body = payload), "POST", sp[[2]])
  }

  # All PUT endpoints
  put_specs <- list(
    list(hue_update_light, "light"),
    list(hue_update_grouped_light, "grouped_light"),
    list(hue_update_room, "room"),
    list(hue_update_zone, "zone"),
    list(hue_update_bridge_home, "bridge_home"),
    list(hue_update_service_group, "service_group"),
    list(hue_update_scene, "scene"),
    list(hue_update_smart_scene, "smart_scene"),
    list(hue_update_device, "device"),
    list(hue_update_device_software_update, "device_software_update"),
    list(hue_update_bridge, "bridge"),
    list(hue_update_motion, "motion"),
    list(hue_update_grouped_motion, "grouped_motion"),
    list(hue_update_camera_motion, "camera_motion"),
    list(hue_update_temperature, "temperature"),
    list(hue_update_light_level, "light_level"),
    list(hue_update_grouped_light_level, "grouped_light_level"),
    list(hue_update_contact, "contact"),
    list(hue_update_tamper, "tamper"),
    list(hue_update_motion_area_configuration, "motion_area_configuration"),
    list(hue_update_convenience_area_motion, "convenience_area_motion"),
    list(hue_update_security_area_motion, "security_area_motion"),
    list(hue_update_wifi_connectivity, "wifi_connectivity"),
    list(hue_update_zigbee_device_discovery, "zigbee_device_discovery"),
    list(hue_update_entertainment_configuration, "entertainment_configuration"),
    list(hue_update_speaker, "speaker"),
    list(hue_update_behavior_instance, "behavior_instance"),
    list(hue_update_geofence_client, "geofence_client"),
    list(hue_update_geolocation, "geolocation"),
    list(hue_update_homekit, "homekit"),
    list(hue_update_matter, "matter")
  )

  expect_identical(length(put_specs), sum(hue_endpoints()$put))

  for (sp in put_specs) {
    check_call(sp[[1]], list(id = "u-1", body = payload), "PUT", paste0(sp[[2]], "/u-1"))
  }

  # All DELETE endpoints
  delete_specs <- list(
    list(hue_delete_room, "room"),
    list(hue_delete_zone, "zone"),
    list(hue_delete_service_group, "service_group"),
    list(hue_delete_scene, "scene"),
    list(hue_delete_smart_scene, "smart_scene"),
    list(hue_delete_device, "device"),
    list(hue_delete_motion_area_configuration, "motion_area_configuration"),
    list(hue_delete_entertainment_configuration, "entertainment_configuration"),
    list(hue_delete_behavior_instance, "behavior_instance"),
    list(hue_delete_geofence_client, "geofence_client"),
    list(hue_delete_matter_fabric, "matter_fabric")
  )

  expect_identical(length(delete_specs), sum(hue_endpoints()$delete))

  for (sp in delete_specs) {
    check_call(sp[[1]], list(id = "u-1"), "DELETE", paste0(sp[[2]], "/u-1"))
  }

  # Recall convenience wrappers
  check_call(hue_recall_scene, list(id = "sc-1", action = "active", duration = 400, brightness = 60), "PUT", "scene/sc-1")
  check_call(hue_recall_smart_scene, list(id = "ssc-1", action = "activate"), "PUT", "smart_scene/ssc-1")
})
