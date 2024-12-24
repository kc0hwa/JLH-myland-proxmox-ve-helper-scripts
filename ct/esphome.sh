#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://esphome.io/

# App Default Values
APP="ESPHome"
var_tags="automation"
var_cpu="2"
var_ram="1024"
var_disk="4"
var_os="debian"
var_version="12"
var_unprivileged="1"

# App Output & Base Settings
header_info "$APP"
base_settings

# Core
variables
color
catch_errors

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -f /etc/systemd/system/esphomeDashboard.service ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi
  msg_info "Stopping ESPHome"
  systemctl stop esphomeDashboard
  msg_ok "Stopped ESPHome"

  msg_info "Updating ESPHome"
  if [[ -d /srv/esphome ]]; then
    source /srv/esphome/bin/activate &>/dev/null
  fi
  pip3 install -U esphome &>/dev/null
  msg_ok "Updated ESPHome"

  msg_info "Starting ESPHome"
  systemctl start esphomeDashboard
  msg_ok "Started ESPHome"
  msg_ok "Updated Successfully"
  exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW} Access it using the following URL:${CL}"
echo -e "${TAB}${GATEWAY}${BGN}http://${IP}:6052${CL}"