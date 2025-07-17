#!/usr/bin/env sh
set -e

# Parámetros
PROJECT_NAME="$1"
VERSION="$2"
DOCKER_USER="${3:-pablonicolas87}"

if [ -z "$PROJECT_NAME" ] || [ -z "$VERSION" ]; then
  echo "Uso: init-project.sh <project-name> <version> [docker-user]"
  exit 1
fi

TARGET_DIR="/output/$PROJECT_NAME"
WORKFLOW="$TARGET_DIR/.github/workflows/deploy.yml"
DOCKERFILE="$TARGET_DIR/Dockerfile"

echo "📦 Creando proyecto: $PROJECT_NAME"
echo "🔖 Versión: $VERSION"
echo "🐳 Docker user: $DOCKER_USER"
echo

# 1) Crear carpeta destino
mkdir -p "$TARGET_DIR"

# 2) Copiar TODO el proyecto base
cp -R /usr/src/base/. "$TARGET_DIR"

# 2a) Quitar cualquier repo Git heredado
rm -rf "$TARGET_DIR/.git"

# 2b) Limpiar carpetas que no queremos en el scaffold
rm -rf "$TARGET_DIR/dist" "$TARGET_DIR/node_modules"

# 2c) Reescribir name y version en package.json, eliminar lock viejo
sed -i -E "s/\"name\": *\"[^\"]+\"/\"name\": \"$PROJECT_NAME\"/" "$TARGET_DIR/package.json"
sed -i -E "s/\"version\": *\"[^\"]+\"/\"version\": \"$VERSION\"/" "$TARGET_DIR/package.json"
rm -f "$TARGET_DIR/package-lock.json"

# 2d) Eliminar carpeta de scripts
rm -rf "$TARGET_DIR/scripts"

# 2e) Ajustar Dockerfile para runtime-only
sed -n -e '1,/^FROM nginx:stable-alpine/!d' "$DOCKERFILE" > "$DOCKERFILE.tmp"
mv "$DOCKERFILE.tmp" "$DOCKERFILE"

# 2f) Ajustar workflow de GitHub Actions
#   1) Borrar TODO el bloque de builder + antiguo runtime
sed -i '/name: 🔨 Build & Push BUILDER image/,/docker image prune -f/d' "$WORKFLOW"
#   2) Insertar el nuevo bloque runtime justo antes de la limpieza de imágenes
sed -i '/docker image prune -f/i\
      - name: 🔨 Build & Push '"$PROJECT_NAME"'-runtime image\n\
        run: |\n\
          docker build --target production \\\n\
            -t '"$DOCKER_USER"'/'"$PROJECT_NAME"'-runtime:${{ env.VERSION }} \\\n\
            -t '"$DOCKER_USER"'/'"$PROJECT_NAME"'-runtime:latest .\n\
          docker push '"$DOCKER_USER"'/'"$PROJECT_NAME"'-runtime:${{ env.VERSION }} \\\n\
          docker push '"$DOCKER_USER"'/'"$PROJECT_NAME"'-runtime:latest' "$WORKFLOW"

# 2g) Regenerar README.md mínimo
rm -f "$TARGET_DIR/README.md"
cat > "$TARGET_DIR/README.md" << EOF
# $PROJECT_NAME

Proyecto iniciado desde Proyecto Base Front-End.

## 🚀 Desarrollo

\`\`\`bash
npm install
npm run dev
\`\`\`

## 🐳 Despliegue

Se publica una imagen runtime en Docker Hub y se sirve con Nginx.
EOF

# 3) Reemplazar placeholders en resto de ficheros relevantes
find "$TARGET_DIR" -type f \
  \( -name "*.yml" -o -name "*.md" -o -name ".gitignore" -o -name "Dockerfile" \) \
  -exec sed -i -e "s/__DOCKER_USER__/$DOCKER_USER/g" {} \;

# 4) Inicializar git local
echo "🔧 Inicializando repositorio Git en $TARGET_DIR"
cd "$TARGET_DIR"
git init

# Configurar identidad Git
GIT_NAME="${GIT_USER_NAME:-PabloNicolas87}"
GIT_EMAIL="${GIT_USER_EMAIL:-gironepablo@gmail.com}"
echo "✏️  Configurando Git user.name=$GIT_NAME user.email=$GIT_EMAIL"
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"

git add .
git commit -m "chore: init $PROJECT_NAME@$VERSION"

echo
echo "✅ Proyecto '$PROJECT_NAME' creado en $TARGET_DIR"
echo "🚀 Listo para desarrollo y despliegue."