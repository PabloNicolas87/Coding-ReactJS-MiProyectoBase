#!/usr/bin/env sh
set -e

# Parámetros
PROJECT_NAME="$1"
VERSION="$2"
DOCKER_USER="${3:-${USER:-dockeruser}}"

if [ -z "$PROJECT_NAME" ] || [ -z "$VERSION" ]; then
  echo "Uso: init-project.sh <project-name> <version> [docker-user]"
  exit 1
fi

TARGET_DIR="/output/$PROJECT_NAME"
echo "📦 Creando proyecto: $PROJECT_NAME"
echo "🔖 Versión: $VERSION"
echo "🐳 Docker user: $DOCKER_USER"
echo

# 1) Crear carpeta destino
mkdir -p "$TARGET_DIR"

# 2) Copiar TODO el proyecto base
cp -R /usr/src/base/. "$TARGET_DIR"

# 2b) Limpiar carpetas que no queremos en el scaffold
rm -rf "$TARGET_DIR/dist"
rm -rf "$TARGET_DIR/node_modules"

# 2b) Limpiar carpetas que no queremos en el scaffold
rm -rf "$TARGET_DIR/dist"
rm -rf "$TARGET_DIR/node_modules"

# 2c) Reescribir name y version en package.json, eliminar lock viejo
#    y así no arrastrar los valores del proyecto base
sed -i -E "s/\"name\": *\"[^\"]+\"/\"name\": \"$PROJECT_NAME\"/" "$TARGET_DIR/package.json"
sed -i -E "s/\"version\": *\"[^\"]+\"/\"version\": \"$VERSION\"/"    "$TARGET_DIR/package.json"
rm -f "$TARGET_DIR/package-lock.json"

# 3) Reemplazar placeholders en resto de ficheros relevantes
find "$TARGET_DIR" -type f \
  \( \
    -name "*.json" -o \
    -name "package-lock.json" -o \
    -name "*.yml"  -o \
    -name "*.md"   -o \
    -name ".gitignore" -o \
    -name "Dockerfile" \
  \) \
  -exec sed -i \
    -e "s/__DOCKER_USER__/$DOCKER_USER/g" {} \;

# 4) Inicializar git (opcional)
if command -v git >/dev/null 2>&1; then
  echo "🔧 Inicializando repositorio Git en $TARGET_DIR"
  cd "$TARGET_DIR"
  git init
  git add .
  git commit -m "chore: init $PROJECT_NAME@$VERSION"
fi

echo
echo "✅ Proyecto '$PROJECT_NAME' creado en $TARGET_DIR"
