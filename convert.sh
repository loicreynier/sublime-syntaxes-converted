#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <input_file> <output_directory>"
  exit 1
fi

input_file=$1
output_directory=$2
convertor="sublime_syntax_convertor"

if ! command -v "$convertor" >/dev/null 2>&1; then
  echo "Error: '$convertor' command not found. Make sure it is installed and available in your PATH."
  exit 1
fi

if [ ! -f "$input_file" ]; then
  echo "Error: Input file '$input_file' not found"
  exit 1
fi

if [ "${input_file##*.}" != "tmLanguage" ]; then
  echo "Error: Input file '$input_file' does not have a '.tmLanguage' extension"
  exit 1
fi

if [ ! -d "$output_directory" ]; then
  echo "Error: Output directory '$output_directory' not found"
  exit 1
fi

output_file="$output_directory/$(basename "$input_file")"

# Replace single quotes by doubles quotes as advised by:
# https://pitkley.dev/blog/atom-grammar-to-sublime-syntax/
sed "s/'/\"/g" "$input_file" >"$output_file"

$convertor "$output_file"

sublime_syntax_file="${output_file%.*}.sublime-syntax"
if [ -f "$sublime_syntax_file" ]; then
  # echo "Sublime-syntax file created: $sublime_syntax_file"
  rm "$output_file"
else
  echo "Error: Sublime-syntax file not created"
  exit 1
fi
