#!/bin/bash

# Prompt the user for a file path
echo -e "\033[0;33mEnter an absolute path to a .docx file:\033[0m"
read filePath

# Convert the .docx file to .md using pandoc
mdPath="${filePath%.*}.md"

# Get the size of the input file
size=$(stat -f%z "$filePath")

# Convert the file and display a progress bar
pandoc -t markdown_strict --extract-media="./assets/" "$filePath" | pv -s "$size" > "$mdPath"

echo -e "\033[0;32mConverted .docx file to .md and saved it as $mdPath\032[0m"