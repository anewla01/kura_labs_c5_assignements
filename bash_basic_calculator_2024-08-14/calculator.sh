#!/bin/bash
# Purpose: Basic calculator that takes input values from a user via the CLI.# User will provide two integers, and then choose from available operators

OPERATORS=("*" "+" "/" "-")
function log(){
  echo $@ >&2
}

function calculate(){
	local v1=$1
	local v2=$2
	local operator=$3
  # NOTE: manually sending to stderr to handle edge case where
  # op="*", and the echo is leading to path expansion
  echo "Equation: (${v1}) " "$op" " (${v2})" >&2

  # NOTE: bc, by default provides a reasonable exception for division by 0
	local rtn_value=$(echo "${v1} ${operator} ${v2}" | bc)
  log "Return: ${rtn_value}"
}


function get_user_numeric(){
  log "Please provide the ${1} numeric value: " 

  local return_value=""
  while [[ -z "${return_value}" ]];
  do
    read response

    local is_valid_number="false"
    # integer check
    if [[ "${response}"  =~ ^-?[0-9]+$ ]]
    then
      is_valid_number="true"

    # float check
    elif [[ "${response}" =~ ^-?[0-9]+\.[0-9]+$ ]]
    then
      is_valid_number="true"
    fi


    case "${is_valid_number}" in 
      "true") return_value="${response}" ;;
      *) log "Found '${response}', however this is not a valid numeric value! Please try again!" ;;
    esac
  done
  echo "$return_value"
}

function get_user_operator(){
  local return_value=""
  log "Please provide the operator (Options: +, /, -, +): "
  while [[ -z "${return_value}" ]];
  do
    read response
    
    case "${response}" in
      "*") return_value="*";;
      "/") return_value="/";;
      "-") return_value="-";;
      "+") return_value="+";;
      *) log "Found '${response}', however this is not a valid operator! Please try again!" ;;
    esac
done
  echo "$return_value"
}


function execute(){
  log "Welcome to basic calculator!"

  local v1=$(get_user_numeric "first")
  local v2=$(get_user_numeric "second")
  local op=$(get_user_operator)
  calculate "${v1}" "${v2}" "${op}"
}

execute
