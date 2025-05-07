# Markdown Keywords Frontmatter Script

This script adds `keywords` metadata to the frontmatter of Markdown files in a specified directory and its subdirectories.

## Purpose

The script automatically adds the following frontmatter to Markdown files that don't already have it:

```yaml
---
keywords:
  - B2B
---
```

## Requirements

- Python 3.x
- No additional dependencies required

## Usage

Run the script from the command line, providing the target directory path as an argument:

```bash
python add_keywords_frontmatter.py <directory_path>
```

### Example

To process all Markdown files in the `commerce-frontend-core/src/pages/page-builder` directory:

```bash
python add_keywords_frontmatter.py commerce-frontend-core/src/pages/page-builder
```

## Behavior

The script will:

1. Recursively find all `.md` files in the specified directory and its subdirectories
2. For each file:
   - If it has no frontmatter, add new frontmatter with the keywords
   - If it has frontmatter but no keywords, add the keywords to the existing frontmatter
   - If it already has keywords, skip the file
3. Print a summary showing:
   - Total number of Markdown files found
   - Number of files that were modified

## Output

The script will print the path of each file it modifies and provide a summary at the end:

```
Added keywords frontmatter to: path/to/file1.md
Added keywords frontmatter to: path/to/file2.md
...

Summary:
Total markdown files found: X
Files modified: Y
```

## Error Handling

- The script will skip any files it cannot read or write
- Error messages will be printed for any files that cause issues
- The script will continue processing remaining files even if some files fail 