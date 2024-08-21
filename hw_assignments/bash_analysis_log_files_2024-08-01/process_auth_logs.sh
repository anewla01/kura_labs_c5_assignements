#!/bin/bash
# Purpose: process auth_log for suspicious activity, generating a suspicious log file for future analyisis
# NOTE on potential future optimizations:
# - System could also create historical log files, denoted with a date_suffix
# - System could generate some high level metrics when processing the log file e.g:
#   - Number of users seen (along with full list of unique users)
#   - Ratio of successful access to failed access attempts
#   - Stats on number of access by user/by/ip
#   - All metrics above, cross sectioned by time frame
# - As long as the log file contiues to remain small (<1GB) -> its likely tennable to have these kinds
# of analysis performed from bash.
#   - NOTE: Mileage may vary depending on how many of these metrics are needed at once. it may more reasonable to perform this kind of analysis within another language OR lean into running background child processes from a bash script
# NOTE: see mock_crontab for how this could be scheduled nightly to provide snapshot analysis

AUTH_LOG_FILE="/var/log/auth_log.log"
OUTPUT_FILE_SUSPICIOUS="/var/log/suspicious_activity.log"

SUSPICOUS_KEY_WORDS=(failure failed unauthorized invalid)

function generate_suspicious_logs(){
  local auth_log_file=$1
  local output_log_file=$2
  
  if [[ -z "${auth_log_file}" ]]
  then
    auth_log_file="${AUTH_LOG_FILE}"
    output_log_file="${OUTPUT_FILE_SUSPICIOUS}"
  fi
  
  local grep_text=""
  for w in "${SUSPICOUS_KEY_WORDS[@]}"
  do 
    if [[ -z "${grep_text}" ]]
    then
      grep_text="${w}"
    else
      grep_text="${grep_text}\|${w}"
    fi
  done
  # echo "debug: grep phrase: ${grep_text}"
  sudo grep "${grep_text}" "${auth_log_file}" > "${output_log_file}"
}

generate_suspicious_logs
