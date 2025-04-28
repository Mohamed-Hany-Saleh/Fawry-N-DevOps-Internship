#!/bin/bash

# Function to print help message
print_help() {
    echo "Usage: $0 [OPTIONS] search_string filename"
    echo ""
    echo "Options:"
    echo "  -n      Show line numbers for matches."
    echo "  -v      Invert match (show lines that do NOT match)."
    echo "  --help  Show this help message."
}

# If no arguments, print error and help
if [[ $# -eq 0 ]]; then
    echo "Error: No arguments provided."
    print_help
    exit 1
fi

# Special case: if first arg is --help
if [[ "$1" == "--help" ]]; then
    print_help
    exit 0
fi

# Initialize option flags
show_line_numbers=false
invert_match=false

# Parse options using getopts
while getopts ":nv" opt; do
  case ${opt} in
    n )
      show_line_numbers=true
      ;;
    v )
      invert_match=true
      ;;
    \? )
      echo "Error: Invalid option -$OPTARG"
      print_help
      exit 1
      ;;
  esac
done

# Shift parsed options
shift $((OPTIND -1))

# After options, two arguments must remain: search_string and filename
if [[ $# -lt 2 ]]; then
    echo "Error: Missing search string or filename."
    print_help
    exit 1
fi

search_string="$1"
filename="$2"

# Check if file exists
if [[ ! -f "$filename" ]]; then
    echo "Error: File '$filename' not found."
    exit 1
fi

# Read file line by line
line_number=0
while IFS= read -r line; do
    ((line_number++))
    should_print=false

    if echo "$line" | grep -iq "$search_string"; then
        should_print=true
    fi

    # Invert logic if -v is set
    if $invert_match; then
        if $should_print; then
            should_print=false
        else
            should_print=true
        fi
    fi

    if $should_print; then
        if $show_line_numbers; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi
done < "$filename"

