#!/bin/bash
# Purpose: utilities for tracking user metadata within a json file
METADATA_FILE="./.metadata_trace.json"

function install_dependences(){
  if [[ -z $(which jq) ]]
  then
    apt-get install jq
  fi
}

function metadata_file_create(){
  echo "{}" > "${METADATA_FILE}"
}

function metadata_file_cleanup(){
  rm "${METADATA_FILE}"
}

function metadata_file_update(){
  local jq_command="${1}" 
  local curr_data=$(cat "${METADATA_FILE}")
  curr_data=$(jq "${jq_command}" <<< "${curr_data}")
  echo "${curr_data}" > "${METADATA_FILE}"
}

function metadata_file_read(){
  local jq_command="${1}" 
  jq "${jq_command}" "$METADATA_FILE"
}
