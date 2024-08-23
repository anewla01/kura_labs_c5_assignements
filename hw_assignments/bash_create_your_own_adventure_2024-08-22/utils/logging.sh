#!/bin/bash
# Purpose: logging helper functions
DEBUG_MODDE=0
if [[ "${DEBUG_MODDE}" -eq 1 ]]
then
  printf "***********************\n"
  printf "***DEBUG MODE IS ON****\n"
  printf "***********************\n\n"
fi


function log_debug(){
  local values=("$@")
  if [[ "${DEBUG_MODDE}" -eq 1 ]]
  then
    echo "value: $values" >&2
    echo "value as array: $values[@]" >&2
    printf "\n\n"
  fi
}


