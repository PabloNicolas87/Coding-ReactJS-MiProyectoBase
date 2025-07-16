#!/usr/bin/env sh
set -e

PROJECT_NAME="$1"
VERSION="$2"
DOCKER_USER="${3:-${USER:-dockeruser}}"

if [ -z "$PROJECT_NAME" ] || [ -z "$VERSION" ]; then
  echo "Uso: init-project.sh <project-name> <version> [docker-user]"
  exit 1
fi

TARGET_DIR="/output/$PROJECT_NAME"

echo "📦 Creando proyecto: $PROJECT_NAME"
mkdir -p "$TARGET_DIR"
cp -R /usr/src/base/. "$TARGET_DIR"
rm -rf "$TARGET_DIR/dist" "$TARGET_DIR/node_modules"
sed -i -E "s/\"name\": *\"[^\"]+\"/\"name\": \"$PROJECT_NAME\"/" "$TARGET_DIR/package.json"
sed -i -E "s/\"version\": *\"[^\"]+\"/\"version\": \"$VERSION\"/" "$TARGET_DIR/package.json"
rm -f "$TARGET_DIR/package-lock.json"
find "$TARGET_DIR" -type f \( -name "*.yml" -o -name "*.md" -o -name ".gitignore" -o -name "Dockerfile" \) \
  -exec sed -i -e "s/__DOCKER_USER__/$DOCKER_USER/g" {} \;
cd "$TARGET_DIR"
git init
git add .
git commit -m "chore: init $PROJECT_NAME@$VERSION"
echo "✅ Scaffold listo en $TARGET_DIR"
