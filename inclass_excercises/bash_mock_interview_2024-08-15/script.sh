#!/bin/bash
# Purpose: 
# Directory Size Monitor Problem: 
# Write a script directory_monitor.sh that:
# Asks the user for a directory they'd like to monitor and takes the name as an argument.
# Calculates the total size of the directory. Hint: du command
# Displays a message saying "Warning: Directory exceeds 100MB" if the size is greater than 100MB.
# Extra: Compress the directory (with zip) or the files in the directory (with gzip)

SIZE_THRESHOLD_MB_EXCLUSIVE=100

function check_directory_size_threshold(){
  local file_path=$1

  if [[ -d "${file_path}" ]]
  then
    curr_size=$(du -m "${file_path}" | awk '{print $1}')

    if [[ "${curr_size}" -gt "${SIZE_THRESHOLD_MB_EXCLUSIVE}" ]]
    then
      echo "Warning: Directory (${file_path}) exceeds ${SIZE_THRESHOLD_MB_EXCLUSIVE}MB, found: ${curr_size}"
    else
      echo "size is ok.."
      # 
      # zip <path>, <path_compressed>
    fi
  else
    echo "Please provide a directory, path provide: ${file_path}"
  fi
}
check_directory_size_threshold "${1}"
