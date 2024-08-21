#!/bin/bash
# Purpose: 
# Create a script that will present the following menu to a user to choose from:
#
# 1. IP Addresses #ex answer: "Your private IP is 172.31.1.150, and you public IP is 3.235.129.224."
# 2. Current User #ex answer: "You are ubuntu."
# 3. CPU Information #ex answer: "The system has 1 CPU." 
# 4. Memory Information #ex answer "There is 330 Mebibyte unused memory of total 957 Mebibyte."
# 5. Top 5 Memory Processes #This can be a table that's produced by a command, ex answer:
#
# "pmem   pid       cmd 
#  2.9        8047    /usr/lib/snapd/snapd
#  2.7        181      /sbin/multipathd -d -s
#  2.3        664      /usr/bin/python3 /usr/share/unattended-upgrades/unattended-upgrade-shutdown --wait-for-signal
#  2.1        516      /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers
#  1.6        524      /snap/amazon-ssm-agent/7993/amazon-ssm-agent"
#
# 6. Top 5 CPU Processes #Same as above
# 7. Network Connectivity #ask user for a website or IP address to connect to first and then produce a statement regarding the network connection, ex answer: "It took 7ms to connect to www.google.com and there was 0% data packet loss."
#
# The script should continue to ask the user to choose from the menu until they want to exit.

function show_menu(){
  echo "************"
  echo "1. IP Addresses"
  echo "2. Current User"
  echo "3. CPU Information"
  echo "4. Memory Information"
  echo "5. Top 5 Processes by Memory Usage"
  echo "6. Top 5 Processes by CPU Usage"
  echo "7. Network Connectivity"
  echo "8. Exit"
  echo "************"
}

function get_public_ip(){
  curl http://169.254.169.254/latest/meta-data/public-ipv4
}

function get_private_ip(){
  curl http://169.254.169.254/latest/meta-data/local-ipv4
}

function get_cpu_count(){
  lscpu | grep -e CPU\(s\): | head -n1 | awk '{print $NF}'
}

function get_memory_info(){
  local search_term=$1
  grep "${search_term}" /proc/meminfo | awk '{print $2}' | xargs -I {} echo "scale=4; {}/1024" | bc
}

function get_top_5_proc_by_mem(){
  ps -eo pmem,user,cmd | sort -k 1 -r | head -5
}

function get_top_5_proc_by_cpu(){
  ps -eo pcpu,user,cmd | sort -k 1 -r | head -5
}

function run_network_connectivity_check(){
  echo "Network Connectivity Check"
  echo "Please provide a url for check!"
  read url
  echo "Running network check for 3 packets against: ${url}"
  ping ${url} -c 3
}

function menu(){
  while true;
  do 
    echo "Choose item from menu - using the integer to select menu item"
    show_menu
    printf "\n\n"
    read response 
    case "${response}" in 
      1) echo "Your Public IP: $(get_public_ip), Private IP: $(get_private_ip)";;
      2) echo "Your User: $(whoami)";;
      3) echo "The system has $(get_cpu_count) CPU";;
      4) echo "Memory Information: $(get_memory_info 'MemFree') MB free memory of a total: $(get_memory_info 'MemTotal') MB";;
      5) echo "Top 5 Processes by Memory Usage"; get_top_5_proc_by_mem;;
      6) echo "Top 5 Processes by CPU Usage"; get_top_5_proc_by_cpu;;
      7) run_network_connectivity_check;;
      8) echo "Exitting!"; break ;;
    esac
    
    printf "\n"
  done
}

menu
