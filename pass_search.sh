#!/bin/bash


# Example use - pass_search.sh -s "Matrix"

# Set the ALL variable to false on standard
ALL=false

# Usage function denotes how to use the program
usage() {
  # Statement on how to call the file
  echo "Usage: ${0} [-a ALL] [-s SERVICE]" >&2
  echo 'List the passwords'
  # Explanation of OPTARG 
  echo ' -a display all passwords'
  echo ' -s specify what service you want to see passwords'
  # Exit the file with error code 1 to stop the script here
  exit 1
}


# only takes either option, that being a service for the file 
while getopts :as: OPTION; do
  # this is denoting the service OPTARG flag 
  case ${OPTION} in
     a)
      ALL='true'
      ;;
     s)
      SERVICE="${OPTARG}"
      ;;
     ?)
      usage
      ;;
  esac
done

# Check if the ALL tag is set to true
if [ "${ALL}" = 'true' ]; then
  # Show all the passwords that are listed in the passlog
  cat /etc/personalpasswords/passlog
  # Exit out of the code with no errors
  exit 0
fi

# Now we are checking that the field is not empty
if [[ -z "${SERVICE}" ]]; then 
  # If it is, then we need to put in an error message
  echo "You need to input a SERVICE to search."
  # and exit code of 1 for error
  exit 1
fi

grep -n " service : ${SERVICE} " /etc/personalpasswords/passlog


# Exit out of the code with no errors 
exit 0
