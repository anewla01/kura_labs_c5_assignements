#!/bin/bash
# Purpose: functions to collect user input

function get_user_input() {
  local input
  local valid_set=("$@")
  local valid_resp=0
  while [[ "${valid_resp}" -ne 1 ]]; do
    read -r -p "Enter your input (Options: ${valid_set[*]}): " input

    # Check if the input is within the valid set
    for valid in "${valid_set[@]}"; do
      if [[ "$input" == "$valid" ]]; then
        echo "$input"
        valid_resp=1
      fi
    done
    
    if [[ "${valid_resp}" -ne -1 ]]
    then
      echo "Invalid input, please enter one of the following options: ${valid_set[*]}" >&2
    fi
  done
}

function get_user_input_yn(){
  get_user_input $1 "Y" "N"
}


