# Edition Frontmatter Adder

This script adds the `edition: pass` frontmatter to Markdown files in specified directories.

## Requirements

- Python 3.x
- No additional dependencies required

## Usage

Run the script by specifying one or more directories as arguments:

```bash
python add_edition_frontmatter.py directory1 directory2 ...
```

For example, to process the page-builder directory and its subdirectories:

```bash
python add_edition_frontmatter.py commerce-frontend-core/src/pages/page-builder/
```

## What the Script Does

The script will:

1. Recursively search through all subdirectories
2. Find all Markdown files (`.md` extension)
3. Check if they already have `edition: pass` in their frontmatter
4. If not, add it to the frontmatter
5. Skip files that:
   - Don't have frontmatter
   - Already have the edition field

## Output

The script will print messages for each file it processes:

- `Added edition: pass to [file_path]` - When it successfully adds the edition field
- `Skipping [file_path] - already has edition: pass` - When the file already has the field
- `Skipping [file_path] - no frontmatter found` - When the file has no frontmatter
- `Error: [directory] is not a valid directory` - When an invalid directory is specified

## Example

```bash
$ python add_edition_frontmatter.py commerce-frontend-core/src/pages/page-builder/
Added edition: pass to commerce-frontend-core/src/pages/page-builder/index.md
Skipping commerce-frontend-core/src/pages/page-builder/migration/index.md - already has edition: pass
Skipping commerce-frontend-core/src/pages/page-builder/migration/how-content-migration-works.md - already has edition: pass
```

## Notes

- The script preserves the existing frontmatter structure
- It adds `edition: pass` as a new line at the end of the frontmatter
- Files without frontmatter (no `---` delimiters) are skipped
- The script is safe to run multiple times on the same files 