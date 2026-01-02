#!/bin/bash

NEW_NAME=$1
OLD_NAME="hg_flutter"
OUT_DIR="out"

if [ -z "$NEW_NAME" ]; then
  echo "Usage: ./generate_project.sh new_project_name"
  exit 1
fi

# Create the /out directory and clone
echo "Cloning template into $OUT_DIR/$NEW_NAME..."
mkdir -p "$OUT_DIR"
rm -rf "$OUT_DIR/$NEW_NAME"

# Copy source only
rsync -avq . "$OUT_DIR/$NEW_NAME" \
    --exclude .git \
    --exclude build \
    --exclude .dart_tool \
    --exclude "$OUT_DIR"

cd "$OUT_DIR/$NEW_NAME" || exit

# The "Search and Replace" (Optimized for macOS M2)
echo "Replacing all occurrences of '$OLD_NAME' with '$NEW_NAME'..."

# We use a loop to ensure sed touches every single file including pubspec.yaml
find . -type f -not -name "generate_project.sh" -not -name "Makefile" -print0 | while IFS= read -r -d '' file; do
    # LC_ALL=C handles potential encoding issues on macOS
    if LC_ALL=C grep -q "$OLD_NAME" "$file"; then
        sed -i '' "s/$OLD_NAME/$NEW_NAME/g" "$file"
    fi
done

# Compatibility Check (Regenerate Flutter files)
echo "Running compatibility check (flutter pub get)..."
flutter clean > /dev/null 2>&1
flutter pub get

echo "------------------------------------------------"
echo "SUCCESS: Project $NEW_NAME generated in /out"