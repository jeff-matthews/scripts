#!/usr/bin/env python3

import os
import re
from pathlib import Path

def add_commerce_only_to_file(file_path):
    """Add CommerceOnly import and component above the first h1 in a markdown file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Check if CommerceOnly is already present
    if 'import CommerceOnly' in content:
        print(f"Skipping {file_path} - CommerceOnly already present")
        return

    # Find the first h1 heading
    h1_pattern = r'^#\s+.*$'
    h1_match = re.search(h1_pattern, content, re.MULTILINE)

    if h1_match:
        # Get the position of the first h1
        h1_pos = h1_match.start()
        
        # Prepare the new content
        commerce_only_content = "import CommerceOnly from '/src/_includes/commerce-only.md'\n\n<CommerceOnly />\n\n"
        
        # Insert the new content before the first h1
        new_content = content[:h1_pos] + commerce_only_content + content[h1_pos:]
        
        # Write the modified content back to the file
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {file_path}")
    else:
        print(f"Skipping {file_path} - No h1 heading found")

def process_directory(directory):
    """Process all markdown files in the given directory and its subdirectories."""
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.md'):
                file_path = os.path.join(root, file)
                add_commerce_only_to_file(file_path)

def main():
    # Get the directory path from command line argument
    import sys
    if len(sys.argv) != 2:
        print("Usage: python add_commerce_only.py <directory_path>")
        sys.exit(1)

    directory = sys.argv[1]
    if not os.path.isdir(directory):
        print(f"Error: {directory} is not a valid directory")
        sys.exit(1)

    process_directory(directory)
    print("Processing complete!")

if __name__ == "__main__":
    main()