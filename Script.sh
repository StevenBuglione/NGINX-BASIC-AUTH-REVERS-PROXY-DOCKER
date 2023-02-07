#!/bin/bash

# Check if a file name was provided as an argument
if [ $# -eq 0 ]; then
  echo "No file name was provided. Please specify a file name."
  exit 1
fi

# Read the log messages from the file
while read -r line; do
  if echo "$line" | grep -q "Fail"; then
    echo "The word 'Fail' was found in the logging message. Terminating pipeline."
    exit 1
  fi
done < "$1"

echo "The logging messages do not contain the word 'Fail'. Continuing pipeline."

#!/bin/bash

# Save the output of the script to a variable
script_output=$(./script.sh)

# Read the log messages from the output of the script
while read -r line; do
  if echo "$line" | grep -q "Fail"; then
    echo "The word 'Fail' was found in the logging message. Terminating pipeline."
    exit 1
  fi
done <<< "$script_output"

echo "The logging messages do not contain the word 'Fail'. Continuing pipeline."


