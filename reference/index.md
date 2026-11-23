# Package index

## Bridge Connection, Discovery & Auth

Connect to a local Philips Hue Bridge, discover bridges, and manage
keys.

- [`hue_bridge()`](https://michael-cw.github.io/huer/reference/hue_bridge.md)
  : Create a Philips Hue Bridge Client Configuration
- [`hue_auth()`](https://michael-cw.github.io/huer/reference/hue_auth.md)
  : Configure Session Credentials for a Philips Hue Bridge
- [`hue_discover()`](https://michael-cw.github.io/huer/reference/hue_discover.md)
  : Discover Philips Hue Bridges on the Local Network
- [`hue_create_app_key()`](https://michael-cw.github.io/huer/reference/hue_create_app_key.md)
  : Create a Philips Hue Application Key
- [`hue_get_application_id()`](https://michael-cw.github.io/huer/reference/hue_get_application_id.md)
  : Retrieve the Hue Application Identifier

## Core Resources & Real-Time Streaming

Inspect all 41 endpoints, call generic CLIP v2 CRUD routes, and stream
SSE events.

- [`hue_endpoints()`](https://michael-cw.github.io/huer/reference/hue_endpoints.md)
  : List All Supported Philips Hue CLIP API v2 and Bridge Pro Endpoints
- [`hue_get_resources()`](https://michael-cw.github.io/huer/reference/hue_resources.md)
  [`hue_resource_get()`](https://michael-cw.github.io/huer/reference/hue_resources.md)
  [`hue_resource_post()`](https://michael-cw.github.io/huer/reference/hue_resources.md)
  [`hue_resource_put()`](https://michael-cw.github.io/huer/reference/hue_resources.md)
  [`hue_resource_delete()`](https://michael-cw.github.io/huer/reference/hue_resources.md)
  : Generic CLIP API v2 Resource Operations
- [`hue_eventstream()`](https://michael-cw.github.io/huer/reference/hue_eventstream.md)
  : Stream Real-Time Events from a Philips Hue Bridge (SSE)

## Lighting, Groups & Scenes

Control lights, grouped lights, rooms, zones, bridge homes, service
groups, and scenes.

- [`hue_get_lights()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)
  [`hue_get_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)
  [`hue_update_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)
  [`hue_get_grouped_lights()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)
  [`hue_get_grouped_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)
  [`hue_update_grouped_light()`](https://michael-cw.github.io/huer/reference/hue_lighting.md)
  : Light and Grouped Light Endpoints
- [`hue_get_rooms()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_get_room()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_create_room()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_update_room()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_delete_room()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_get_zones()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_get_zone()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_create_zone()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_update_zone()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_delete_zone()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_get_bridge_homes()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_get_bridge_home()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_update_bridge_home()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_get_service_groups()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_get_service_group()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_create_service_group()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_update_service_group()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  [`hue_delete_service_group()`](https://michael-cw.github.io/huer/reference/hue_groups.md)
  : Rooms, Zones, Bridge Home, and Service Group Endpoints
- [`hue_get_scenes()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)
  [`hue_get_scene()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)
  [`hue_create_scene()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)
  [`hue_update_scene()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)
  [`hue_delete_scene()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)
  [`hue_recall_scene()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)
  [`hue_get_smart_scenes()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)
  [`hue_get_smart_scene()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)
  [`hue_create_smart_scene()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)
  [`hue_update_smart_scene()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)
  [`hue_delete_smart_scene()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)
  [`hue_recall_smart_scene()`](https://michael-cw.github.io/huer/reference/hue_scenes.md)
  : Scene and Smart Scene Endpoints

## Devices, Sensors & Bridge Pro MotionAware

Manage hardware devices, firmware, sensors, and Bridge Pro MotionAware
areas.

- [`hue_get_devices()`](https://michael-cw.github.io/huer/reference/hue_devices.md)
  [`hue_get_device()`](https://michael-cw.github.io/huer/reference/hue_devices.md)
  [`hue_update_device()`](https://michael-cw.github.io/huer/reference/hue_devices.md)
  [`hue_delete_device()`](https://michael-cw.github.io/huer/reference/hue_devices.md)
  [`hue_get_device_powers()`](https://michael-cw.github.io/huer/reference/hue_devices.md)
  [`hue_get_device_power()`](https://michael-cw.github.io/huer/reference/hue_devices.md)
  [`hue_get_device_software_updates()`](https://michael-cw.github.io/huer/reference/hue_devices.md)
  [`hue_get_device_software_update()`](https://michael-cw.github.io/huer/reference/hue_devices.md)
  [`hue_update_device_software_update()`](https://michael-cw.github.io/huer/reference/hue_devices.md)
  [`hue_get_bridges()`](https://michael-cw.github.io/huer/reference/hue_devices.md)
  [`hue_get_bridge()`](https://michael-cw.github.io/huer/reference/hue_devices.md)
  [`hue_update_bridge()`](https://michael-cw.github.io/huer/reference/hue_devices.md)
  : Device, Power, Firmware Update, and Bridge Endpoints
- [`hue_get_motions()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_motion()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_update_motion()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_grouped_motions()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_grouped_motion()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_update_grouped_motion()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_camera_motions()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_camera_motion()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_update_camera_motion()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_temperatures()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_temperature()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_update_temperature()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_light_levels()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_light_level()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_update_light_level()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_grouped_light_levels()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_grouped_light_level()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_update_grouped_light_level()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_buttons()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_button()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_bell_buttons()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_bell_button()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_relative_rotaries()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_relative_rotary()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_contacts()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_contact()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_update_contact()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_tampers()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_get_tamper()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  [`hue_update_tamper()`](https://michael-cw.github.io/huer/reference/hue_sensors.md)
  : Sensor and Physical Control Endpoints
- [`hue_get_motion_area_configurations()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  [`hue_get_motion_area_configuration()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  [`hue_create_motion_area_configuration()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  [`hue_update_motion_area_configuration()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  [`hue_delete_motion_area_configuration()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  [`hue_get_motion_area_candidates()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  [`hue_get_motion_area_candidate()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  [`hue_get_convenience_area_motions()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  [`hue_get_convenience_area_motion()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  [`hue_update_convenience_area_motion()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  [`hue_get_security_area_motions()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  [`hue_get_security_area_motion()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  [`hue_update_security_area_motion()`](https://michael-cw.github.io/huer/reference/hue_motion_areas.md)
  : MotionAware and Motion Area Endpoints (Hue Bridge Pro)

## Connectivity, Entertainment & Automation

Manage Zigbee/Wi-Fi connectivity, Entertainment streaming, speakers,
behaviors, HomeKit, and Matter.

- [`hue_get_zigbee_connectivities()`](https://michael-cw.github.io/huer/reference/hue_connectivity.md)
  [`hue_get_zigbee_connectivity()`](https://michael-cw.github.io/huer/reference/hue_connectivity.md)
  [`hue_get_zgp_connectivities()`](https://michael-cw.github.io/huer/reference/hue_connectivity.md)
  [`hue_get_zgp_connectivity()`](https://michael-cw.github.io/huer/reference/hue_connectivity.md)
  [`hue_get_wifi_connectivities()`](https://michael-cw.github.io/huer/reference/hue_connectivity.md)
  [`hue_get_wifi_connectivity()`](https://michael-cw.github.io/huer/reference/hue_connectivity.md)
  [`hue_update_wifi_connectivity()`](https://michael-cw.github.io/huer/reference/hue_connectivity.md)
  [`hue_get_zigbee_device_discoveries()`](https://michael-cw.github.io/huer/reference/hue_connectivity.md)
  [`hue_get_zigbee_device_discovery()`](https://michael-cw.github.io/huer/reference/hue_connectivity.md)
  [`hue_update_zigbee_device_discovery()`](https://michael-cw.github.io/huer/reference/hue_connectivity.md)
  : Connectivity and Zigbee Device Discovery Endpoints
- [`hue_get_entertainments()`](https://michael-cw.github.io/huer/reference/hue_entertainment.md)
  [`hue_get_entertainment()`](https://michael-cw.github.io/huer/reference/hue_entertainment.md)
  [`hue_get_entertainment_configurations()`](https://michael-cw.github.io/huer/reference/hue_entertainment.md)
  [`hue_get_entertainment_configuration()`](https://michael-cw.github.io/huer/reference/hue_entertainment.md)
  [`hue_create_entertainment_configuration()`](https://michael-cw.github.io/huer/reference/hue_entertainment.md)
  [`hue_update_entertainment_configuration()`](https://michael-cw.github.io/huer/reference/hue_entertainment.md)
  [`hue_delete_entertainment_configuration()`](https://michael-cw.github.io/huer/reference/hue_entertainment.md)
  [`hue_get_speakers()`](https://michael-cw.github.io/huer/reference/hue_entertainment.md)
  [`hue_get_speaker()`](https://michael-cw.github.io/huer/reference/hue_entertainment.md)
  [`hue_update_speaker()`](https://michael-cw.github.io/huer/reference/hue_entertainment.md)
  : Entertainment and Speaker Endpoints
- [`hue_get_behavior_scripts()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_behavior_script()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_behavior_instances()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_behavior_instance()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_create_behavior_instance()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_update_behavior_instance()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_delete_behavior_instance()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_geofence_clients()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_geofence_client()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_create_geofence_client()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_update_geofence_client()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_delete_geofence_client()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_geolocations()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_geolocation()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_update_geolocation()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_homekits()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_homekit()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_update_homekit()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_matters()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_matter()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_update_matter()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_matter_fabrics()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_get_matter_fabric()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  [`hue_delete_matter_fabric()`](https://michael-cw.github.io/huer/reference/hue_automation.md)
  : Automation, Geofencing, HomeKit, and Matter Endpoints

## Payload Builders & JSON Helpers

Construct validated JSON payloads and explore nested CLIP v2 responses
as tidy tibbles.

- [`hue_payload_light()`](https://michael-cw.github.io/huer/reference/hue_payload_light.md)
  : Build a Light or Grouped Light State Update Payload
- [`hue_resource_identifier()`](https://michael-cw.github.io/huer/reference/hue_resource_identifier.md)
  : Build a Philips Hue Resource Identifier Reference
- [`hue_parse_response()`](https://michael-cw.github.io/huer/reference/hue_parse_response.md)
  : Parse a Philips Hue CLIP API v2 JSON Response
- [`hue_unnest_array()`](https://michael-cw.github.io/huer/reference/hue_unnest_array.md)
  : Unnest a Nested JSON Array Column from a Hue Response
