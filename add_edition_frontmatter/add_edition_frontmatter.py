#!/usr/bin/env python3

import os
import re
import sys
from pathlib import Path

def add_edition_frontmatter(file_path):
    """Add edition: paas to frontmatter if it doesn't exist."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check if file already has edition: pass
    if 'edition: paas' in content:
        print(f"Skipping {file_path} - already has edition: paas")
        return
    
    # Check if file has frontmatter
    frontmatter_match = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
    if not frontmatter_match:
        print(f"Skipping {file_path} - no frontmatter found")
        return
    
    # Add edition: paas to frontmatter
    frontmatter = frontmatter_match.group(1)
    new_frontmatter = f"{frontmatter}\nedition: paas"
    new_content = content.replace(frontmatter, new_frontmatter)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print(f"Added edition: paas to {file_path}")

def process_directory(directory):
    """Process all markdown files in directory and its subdirectories."""
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.md'):
                file_path = os.path.join(root, file)
                add_edition_frontmatter(file_path)

def main():
    if len(sys.argv) < 2:
        print("Usage: python add_edition_frontmatter.py <directory1> [directory2 ...]")
        sys.exit(1)
    
    for directory in sys.argv[1:]:
        if not os.path.isdir(directory):
            print(f"Error: {directory} is not a valid directory")
            continue
        process_directory(directory)

if __name__ == "__main__":
    main()