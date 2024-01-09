#!/bin/bash 

# General Passwords - Script to generate random passwords + customizable lengths
# Store Passwords - Users should be able to add and store passwords. Contains the following information
# - Password itself
# - Service (ex: google, github - password associated with)
# - Email address / username with service
# - An id
# List Passwords: Create an option to list all stored passwords

# Example usage - password.sh -p '' -c 'service' -e 'email'


# This is a function called usage which states a number of different print (echo) statements.
usage() {
  # Defines how to use the program 
  echo "Usage: ${0} [-v] [-l LENGTH] [-p PASSWORD] [-c SERVICE] [-e EMAIL] [-s]" >&2
  # These are just help messages which define what its suppose to do
  echo 'Generate a random password.'
  echo ' -v display output in verbose mode'
  echo ' -l LENGTH specify the password length.'
  echo ' -p Set a password, if you leave the field as blank quotes it will generate one for you'
  echo ' -c List what service this password is applied to'
  echo ' -e List what email this password is applied to'
  echo ' -s Append a special character to the password.'

  # exit error code of 1 
  exit 1
}


# This is a function called log. 
# log will only run the messages if VERBOSE variable is set to true.  
log() {
  local MESSAGE="${@}"
  # if verbose flag is set to true
  if [[ "${VERBOSE}" = 'true' ]]; then
    # then we will echo the message necessary 
    echo "${MESSAGE}"
  fi
}


# set a default password length - I changed the command a bit to generate passwords between lengths of 12 to 48. 
LENGTH=$(shuf -i 12-48 -n 1)
# LENGTH=48


# getopts is used to parse command line options 
while getopts :vl:p:c:e:s OPTION; do
  case ${OPTION} in
    # Enable VERBOSE mode - gives additional information from the log() function
    v)
      VERBOSE='true'
      log 'Verbose mode on.'
      ;;
    # Allows the user to specify the password length
    l)
      LENGTH="${OPTARG}"
      ;;
    # Sets a specified password 
    p)
      PASSWORD="${OPTARG}"
      ;;
    # Sets specified service
    c) 
      SERVICE="${OPTARG}"
      ;;
    # Sets specified email
    e) 
      EMAIL="${OPTARG}"
      ;;
    # Appends special character to the generated password
    s)
      USE_SPECIAL_CHARACTER='true'
      ;;
    ?)
      usage
      ;;
  esac
done

if [[ -z "${PASSWORD}" ]]; then
  log 'Generating a password'
  # Generate a random password
  # Concatenates current timestamp in nanoseconds, 2 random numbers
  # Calculates SHA-256 hash of resulting string
  # Takes the length to limit output to first 'LENGTH' characters of hash
  PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

  #Append a special character
  if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]; then
    log 'Selecting a random special character.'
    SPECIAL_CHARACTER=$(echo '!@#$%^&*()-=+' | fold -w1 | shuf | head -c1)
    PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
  fi


fi

# if the service field is blank 
if [[ -z "${SERVICE}" ]]; then
  # send an error message
  echo "Service cannot be a blank field"
  # do not complete the code
  exit 1
fi

# If the email field is blank
if [[ -z "${EMAIL}" ]]; then
  # send an error message
  echo "Email cannot be a blank field"
  # do not complete the code 
  exit 1
fi


# Generate a unique random ID
unique_id=$(($(date +%s%N) + $RANDOM))
# echo "Unique ID: $unique_id"


log 'Done'

log 'Here is your password'
# display password
# echo "password: ${PASSWORD}"

# display additional items
# echo "service: ${SERVICE}"
# echo "email: ${EMAIL}"

# Creation of a file that stores passwords 
FILEWRITE=/etc/personalpasswords/passlog
# FILEWRITE=passlog.csv
# Creation of a string that shows all the information on one line 
DATA="password : ${PASSWORD} | service : ${SERVICE} | email : ${EMAIL} | ID : ${unique_id}" 
#DATA="${PASSWORD},${SERVICE},${EMAIL},${unique_id}"
# Writing to the passlog.txt file using the variable FILEWRITE, append to keep former changes
# echo "password,service,email,id" > $FILEWRITE
echo "${DATA}" >> "$FILEWRITE"


# list out all the passwords
# cat passlog.txt
echo "Password created" 


# indication of successful execution with 0 code
exit 0

