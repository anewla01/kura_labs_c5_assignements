#!/bin/bash
# Purpose: check if a directory named `backup` exists in current directory, if not create it.

curr_wd=$(pwd)
expected_dir="${curr_wd}/backup" 
if [[ -d "${expected_dir}" ]]
then
  echo "Directory: ${expected_dir} already exists"
else
  echo "Directory: ${expected_dir} does not exist, creating" 
  mkdir "${expected_dir}"
fi
