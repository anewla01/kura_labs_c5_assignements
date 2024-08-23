#!/bin/bash
# Purpose: Small turn based game about going to the beach!
# NOTE: script was designed to play with some different functionality in bash
# - reading and writing from a json file
# - random number generation
source ./utils/logging.sh
source ./utils/user_input.sh
source ./utils/metadata_tracker.sh

function random_yes(){
  local choice=$(( $RANDOM % 2 ))
  if [[ "${choice}" -eq 1 ]]
  then 
    echo "Y"
  else
    echo "N"
  fi
}
function random_invalid_beach_reason(){
  local reasons=("it's not sunny enough" "it's too cloudy" "too many people out")
  declare -i length="${#reasons[@]}"
  local index=$(( $RANDOM % $length ))
  echo "${reasons[${index}]}"
}

function func_selector_yn(){
  local func_yes="${1}"
  local func_no="${2}"
  local resp="${3}"
  
  log_debug "func_selector_yn ${resp}"
  if [[ "${resp}" == "Y" ]]
  then
    eval "${func_yes}"
  elif [[ "${resp}" == "N" ]]
  then
    eval "${func_no}"
  fi
}

function step_1_evaluate_beach_success(){
  local user_reason=$(metadata_file_read ".reason")
  local user_name=$(metadata_file_read ".user_name" | sed 's/"//g')
  local valid_reason=$(echo "${user_reason}" | grep "sun")
  local override=$(random_yes)

  local go_to_beach=$([[ ! -z "${valid_reason}"  || "${override}" == "Y" ]] && echo 1 || echo 0)
  go_to_beach=0

  if [[ "${go_to_beach}" -eq 1 ]]
    then
      echo "Awesome, ${user_name}, everything looks good to us, lets go to the beach!"
  else
    invalid_beach_reason=$(random_invalid_beach_reason)
    echo "Sorry ${user_name}. We can't go to the beach today, ${invalid_beach_reason}"
  fi

}

function step_0a_yes_adventure_begins(){
  echo "Excellent! Let the adventure begin!"
  read -r -p "Who are you stranger, tell me your name? " name 
  read -r -p "Why do you yearn for the beach? " reason
  metadata_file_update ". + {\"user_name\": \"${name}\", \"reason\": \"${reason}\"}"

  step_1_evaluate_beach_success
}


function step_0b_no_adventure_exit(){
  echo "Maybe next time then, see you soon!"
}

function step_0_are_you_ready(){
  echo "Are you ready for an adventure?"
  user_input=$(get_user_input_yn)
  func_selector_yn step_0a_yes_adventure_begins step_0b_no_adventure_exit "${user_input}"
}

function main(){
  install_dependences
  metadata_file_create

  echo "Welcome to Beach Adventure 1.0"
  step_0_are_you_ready

  echo "*****"
  metadata_file_cleanup
}
main
