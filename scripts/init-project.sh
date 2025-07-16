#!/usr/bin/env sh
set -e

# Parámetros
PROJECT_NAME="$1"
VERSION="$2"
DOCKER_USER="${3:-${USER:-dockeruser}}"
GITHUB_VISIBILITY="${4:-public}"    # Opcional: public o private

if [ -z "$PROJECT_NAME" ] || [ -z "$VERSION" ]; then
  echo "Uso: init-project.sh <project-name> <version> [docker-user] [public|private]"
  exit 1
fi

TARGET_DIR="/output/$PROJECT_NAME"

echo "📦 Creando proyecto: $PROJECT_NAME"
echo "🔖 Versión: $VERSION"
echo "🐳 Docker user: $DOCKER_USER"
echo "🌐 Visibilidad GitHub: $GITHUB_VISIBILITY"
echo

# 1) Crear carpeta destino
mkdir -p "$TARGET_DIR"

# 2) Copiar TODO el proyecto base
cp -R /usr/src/base/. "$TARGET_DIR"

# 2b) Limpiar carpetas que no queremos en el scaffold
rm -rf "$TARGET_DIR/dist"
rm -rf "$TARGET_DIR/node_modules"

# 2c) Reescribir name y version en package.json, eliminar lock viejo
sed -i -E "s/\"name\": *\"[^\"]+\"/\"name\": \"$PROJECT_NAME\"/" "$TARGET_DIR/package.json"
sed -i -E "s/\"version\": *\"[^\"]+\"/\"version\": \"$VERSION\"/"    "$TARGET_DIR/package.json"
rm -f "$TARGET_DIR/package-lock.json"

# 3) Reemplazar placeholders en resto de ficheros relevantes
find "$TARGET_DIR" -type f \
  \( \
    -name "*.yml"  -o \
    -name "*.md"   -o \
    -name ".gitignore" -o \
    -name "Dockerfile" \
  \) \
  -exec sed -i \
    -e "s/__DOCKER_USER__/$DOCKER_USER/g" {} \;

# 4) Inicializar git local
cd "$TARGET_DIR"
git init
git add .
git commit -m "chore: init $PROJECT_NAME@$VERSION"

# 5) Crear repo remoto en GitHub con gh CLI y hacer push
if command -v gh >/dev/null 2>&1; then
  echo "🌐 Creando repositorio GitHub: $DOCKER_USER/$PROJECT_NAME ($GITHUB_VISIBILITY)"
  gh repo create "$DOCKER_USER/$PROJECT_NAME" \
    --"$GITHUB_VISIBILITY" \
    --source="$TARGET_DIR" \
    --remote=origin \
    --push
  echo "✅ Repo remoto creado y push inicial completado"
else
  echo "⚠️  GitHub CLI no encontrado. Para vincular manualmente:"
  echo "   cd \"$TARGET_DIR\""
  echo "   git remote add origin git@github.com:$DOCKER_USER/$PROJECT_NAME.git"
  echo "   git push -u origin main"
fi

echo
echo "✅ Proyecto '$PROJECT_NAME' listo en $TARGET_DIR"
