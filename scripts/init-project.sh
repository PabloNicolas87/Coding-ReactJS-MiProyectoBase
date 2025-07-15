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

# Directorio destino (en el host, montado en /output)
TARGET_DIR="/output/$PROJECT_NAME"

echo "📦 Creando proyecto: $PROJECT_NAME"
echo "🔖 Versión: $VERSION"
echo "🐳 Docker user: $DOCKER_USER"
echo

# 1) Crear carpeta destino
mkdir -p "$TARGET_DIR"

# 2) Copiar template completo
cp -R /usr/src/template/. "$TARGET_DIR"

# 3) Reemplazar placeholders en todos los ficheros relevantes
#    Buscaremos archivos de texto (.json, .yml, .md, .gitignore, etc.)
find "$TARGET_DIR" -type f \( -name "*.json" -o -name "*.yml" -o -name "*.md" -o -name ".gitignore" \) \
  -exec sed -i \
    -e "s/__PROJECT_NAME__/$PROJECT_NAME/g" \
    -e "s/__VERSION__/$VERSION/g" \
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
