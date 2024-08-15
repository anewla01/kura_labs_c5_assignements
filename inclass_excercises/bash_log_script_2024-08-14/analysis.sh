#!/bin/bash
# Purpose: Processing API log data. Aiming to understand the 404 errors within log
# Key details to parse:
# - IP addresses responsible for errors
# - understanding frequency of errors (and by IP)
# Implementation Details
# Code assumes that spaces are the key seperator, and that all special characters are escaped with quotes
# Example Log Line: ,"54.36.149.41 - - [22/Jan/2019:03:56:14 +0330] ""GET /filter/27|13%20%D9%85%DA%AF%D8%A7%D9%BE%DB%8C%DA%A9%D8%B3%D9%84,27|%DA%A9%D9%85%D8%AA%D8%B1%20%D8%A7%D8%B2%205%20%D9%85%DA%AF%D8%A7%D9%BE%DB%8C%DA%A9%D8%B3%D9%84,p53 HTTP/1.1"" 200 30577 ""-"" ""Mozilla/5.0 (compatible; AhrefsBot/6.1; +http://ahrefs.com/robot/)"" ""-"""
# Future work
# - proper handling of function parameters

function format_status_code(){
  local status_code="${1}"
  status_code=" ${status_code} "
  echo "${status_code}"
}

function get_unique_ips(){
  local file_path="${1}"
  local status_code="${2}"

  return_value=$(grep $(format_status_code "${status_code}") "${file_path}" | grep -o "\d\.\d\d\d\.\d\d\d.\d\d\d" | sort -u)
  

  # NOTE(anewla): returns a string
  echo "${return_value[@]}" 
}

function get_occurrences(){
  local file_path="${1}"
  local status_code="${2}"
  local ip="${3}"
  
  local return_value=$(grep "${ip}" "${file_path}" | grep $(format_status_code "${status_code}") | wc -l | awk '{print $NF}')

  echo "${return_value}"
}

function main(){
  local file_path="${1}"
  local status_code="${2}"

  echo "Search file: ${file_path}, for status_code ${status_code}"

  local ip_candidates=$(get_unique_ips "${file_path}" "${status_code}")
  
  local num_ip_candidates=$(echo "${ip_candidates}" | wc -l | awk '{print $NF}')
  echo "Found ${num_ip_candidates} with logs for status_code: ${status_code}"

  echo "Occurrence analysis"
  while IFS= read -r line; do
    curr_num_occurrences=$(get_occurrences "${file_path}" "${status_code}" "${line}")
    echo "IP: ${line} - num_occurrences: ${curr_num_occurrences}"
  done <<< "${ip_candidates}"
}

