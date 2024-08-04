# Assignment Prompt

You are a Junior Security Analyst at Chase Bank, responsible for monitoring the
bank's digital security infrastructure. Recently, you and your team has noticed
an increase in suspicious login attempts on the main server. These incidents
could indicate potential unauthorized access or brute-force attacks targeting
customer accounts.

As part of the cybersecurity team, your task is to investigate these incidents
by analyzing the authentication logs stored on the server. The log file
(/var/log/auth_log.log) records all login attempts, and your job is to identify
any entries that indicate suspicious login attempts.

Instructions: Develop a Bash script to analyze auth_log.logs. Your script should
read through each line of the log file, searching for each keyword, which
indicates potentially suspicious login attempts. if the line contains this
keyword, write the line to a new file called suspicious_activity.log. This file
will store all the entries that match the criteria. Automate the script to run
daily.

# Approach

- [x] Run initial script to generate mock log data
- [x] Investigate the provided log file
- [x] Determine what information needs to be parsed
  - failed
  - unauthorized
  - invalid
  - failure
- [x] Script pseudo code
  - REQUIRED:
    - keep list of key phrases
    - builld regex str that can be leveraged to pull logs and preserve original
      ordering
    - parse valid rows and dump into an output file
- [x] Annotate what should be added to the cron file to have this script run
      daily
  - NOTE: cron should likely run at UTC midnight, the timing could be better
    improved depending on how large the log files are (as there will be spill
    over logging information)
- Useful commands

  ```Bash
  # getting sorted unique list of sshd nums
  cat  /var/log/auth_log.log | grep -o "sshd\[\d*\]" | sort -u

  # getting full set of users
  cat  /var/log/auth_log.log | grep -o "user\d*" | sort -Vu | sed 's/user$/admin/

  # get all unique pieces of text
  cat  /var/log/auth_log.log | awk -F : '{print $NF}' | awk '{for(i=1;  i<NF; i++) print $i}' | tr '[:upper:]' '[:lower:]' | sort -u
  ```
