#!/bin/bash

# Prompt the user for a file path
echo "Enter the path to a .docx file:"
read filePath

# Convert the .docx file to .md using pandoc
mdPath="${filePath%.*}.md"
pandoc -t markdown_strict --extract-media="./assets/" "$filePath" -o "$mdPath"

echo "Converted .docx file to .md and saved it as $mdPath"