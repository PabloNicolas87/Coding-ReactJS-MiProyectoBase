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

echo
echo "📦 Creando proyecto: $PROJECT_NAME"
echo "🔖 Versión: $VERSION"
echo "🐳 Docker user: $DOCKER_USER"
echo

# 1) Scaffold básico...
mkdir -p "$TARGET_DIR"
cp -R /usr/src/base/. "$TARGET_DIR"
rm -rf "$TARGET_DIR/.git" "$TARGET_DIR/dist" "$TARGET_DIR/node_modules"
sed -i -E "s/\"name\": *\"[^\"]+\"/\"name\": \"$PROJECT_NAME\"/" "$TARGET_DIR/package.json"
sed -i -E "s/\"version\": *\"[^\"]+\"/\"version\": \"$VERSION\"/"      "$TARGET_DIR/package.json"
rm -f "$TARGET_DIR/package-lock.json"
rm -rf "$TARGET_DIR/scripts"

# 2e) Runtime-only Dockerfile
sed -n '/^FROM nginx:stable-alpine/,$p' "$DOCKERFILE" > "$DOCKERFILE.tmp"
mv "$DOCKERFILE.tmp" "$DOCKERFILE"

# 2f) Workflow: quitar builder + corregir login + añadir build/runtime

# Eliminar bloque builder
sed -i '/name: 🔨 Build & Push BUILDER image/,/uses: docker\/login-action@v2/d' "$WORKFLOW"

# Insertar 'with:' justo después del login-action line
sed -i '/uses: docker\/login-action@v2/a\
        with:\
          username: ${{ secrets.DOCKERHUB_USERNAME }}\
          password: ${{ secrets.DOCKERHUB_TOKEN }}' "$WORKFLOW"

# Insertar paso runtime justo después de las credenciales
sed -i '/password:.*DOCKERHUB_TOKEN/a\
\
      - name: 🔨 Build & Push '"$PROJECT_NAME"'-runtime image\
        run: |\
          docker build --target production \\ 
            -t '"$DOCKER_USER"'/'"$PROJECT_NAME"'-runtime:${{ env.VERSION }} \\ 
            -t '"$DOCKER_USER"'/'"$PROJECT_NAME"'-runtime:latest .\
          docker push '"$DOCKER_USER"'/'"$PROJECT_NAME"'-runtime:${{ env.VERSION }} \\ 
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

La imagen runtime se publica automáticamente y se sirve con Nginx.
EOF

# 3) Reemplazar placeholders
find "$TARGET_DIR" -type f \
  \( -name "*.yml" -o -name "*.md" -o -name ".gitignore" -o -name "Dockerfile" \) \
  -exec sed -i "s/__DOCKER_USER__/$DOCKER_USER/g" {} \;

# 4) Git init + commit
cd "$TARGET_DIR"
git init
GIT_NAME="${GIT_USER_NAME:-PabloNicolas87}"
GIT_EMAIL="${GIT_USER_EMAIL:-gironepablo@gmail.com}"
git config user.name  "$GIT_NAME"
git config user.email "$GIT_EMAIL"
git add .
git commit -m "chore: init $PROJECT_NAME@$VERSION"

echo "✅ Proyecto '$PROJECT_NAME' creado en $TARGET_DIR"

