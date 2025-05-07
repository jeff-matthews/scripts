#!/usr/bin/env python3

import os
import re
import sys
from pathlib import Path

def add_keywords_frontmatter(file_path):
    """Add keywords frontmatter to a markdown file if it doesn't exist."""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()

        # Check if file already has frontmatter
        if not content.startswith('---'):
            # No frontmatter exists, add new frontmatter at the beginning
            new_content = '---\nkeywords:\n  - B2B\n---\n\n' + content
        else:
            # Frontmatter exists, check if keywords is already present
            if 'keywords:' not in content:
                # Find the end of existing frontmatter
                end_of_frontmatter = content.find('---', 3)
                if end_of_frontmatter != -1:
                    # Insert keywords before the end of frontmatter
                    new_content = (
                        content[:end_of_frontmatter] +
                        'keywords:\n  - B2B\n' +
                        content[end_of_frontmatter:]
                    )
                else:
                    # Invalid frontmatter, add new one at the beginning
                    new_content = '---\nkeywords:\n  - B2B\n---\n\n' + content
            else:
                # Keywords already exists, skip
                return False

        # Write the modified content back to the file
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(new_content)
        return True

    except Exception as e:
        print(f"Error processing {file_path}: {str(e)}")
        return False

def process_directory(directory_path):
    """Process all markdown files in the given directory and its subdirectories."""
    directory = Path(directory_path)
    if not directory.exists():
        print(f"Directory not found: {directory_path}")
        return

    modified_files = 0
    total_files = 0

    for file_path in directory.rglob('*.md'):
        total_files += 1
        if add_keywords_frontmatter(file_path):
            modified_files += 1
            print(f"Added keywords frontmatter to: {file_path}")

    print(f"\nSummary:")
    print(f"Total markdown files found: {total_files}")
    print(f"Files modified: {modified_files}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python add_keywords_frontmatter.py <directory_path>")
        sys.exit(1)

    directory_path = sys.argv[1]
    process_directory(directory_path)