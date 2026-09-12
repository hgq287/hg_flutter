#!/bin/bash

NEW_NAME=$1
OLD_NAME="hg_flutter"
OLD_CAMEL="hgFlutter"
OLD_LEGACY_SNAKE="dt_flutter"
OLD_LEGACY_CAMEL="dtFlutter"
OUT_DIR="out"

if [ -z "$NEW_NAME" ]; then
  echo "Usage: ./generate_project.sh new_project_name"
  exit 1
fi

to_camel() {
  echo "$1" | awk -F_ '{
    printf "%s", $1
    for (i = 2; i <= NF; i++) {
      printf "%s", toupper(substr($i, 1, 1)) substr($i, 2)
    }
    print ""
  }'
}

NEW_CAMEL="$(to_camel "$NEW_NAME")"

echo "Cloning template into $OUT_DIR/$NEW_NAME..."
mkdir -p "$OUT_DIR"
rm -rf "$OUT_DIR/$NEW_NAME"

rsync -avq . "$OUT_DIR/$NEW_NAME" \
    --exclude .git \
    --exclude build \
    --exclude .dart_tool \
    --exclude "$OUT_DIR" \
    --exclude generate_project.sh \
    --exclude Makefile

cd "$OUT_DIR/$NEW_NAME" || exit

echo "Replacing '$OLD_NAME' / leftover IDs with '$NEW_NAME' ($NEW_CAMEL)..."

replace_in_tree() {
  local from="$1"
  local to="$2"
  find . -type f -not -name "generate_project.sh" -not -name "Makefile" -print0 | while IFS= read -r -d '' file; do
    if LC_ALL=C grep -q "$from" "$file"; then
      sed -i '' "s/$from/$to/g" "$file"
    fi
  done
}

replace_in_tree "$OLD_LEGACY_CAMEL" "$NEW_CAMEL"
replace_in_tree "$OLD_LEGACY_SNAKE" "$NEW_NAME"
replace_in_tree "$OLD_CAMEL" "$NEW_CAMEL"
replace_in_tree "$OLD_NAME" "$NEW_NAME"

echo "Running compatibility check (flutter pub get)..."
flutter clean > /dev/null 2>&1
flutter pub get

echo "------------------------------------------------"
echo "SUCCESS: Project $NEW_NAME generated in /out"
