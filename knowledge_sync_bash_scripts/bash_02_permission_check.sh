#!/bin/bash
# Purpose: Write a script to check if a file is readable, writable, and executable.

# Mac osx
# perms=`stat -f '%A' "${1}"`
# Linux
perms=`stat -c '%a' "${1}"`


if [[ "${perms}" =~ "7" ]]
then
  echo "${1} is readable, writeable, and executable, for at least one user/group. Permissions: ${perms}"
else
  echo "${1} is not readable, writeable and executable for any user/group. Permissions: ${perms}"
fi
