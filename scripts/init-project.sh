\#!/usr/bin/env sh
set -e

# Parámetros\nPROJECT\_NAME="\$1"

VERSION="\$2"
DOCKER\_USER="\${3:-pablonicolas87}"

if \[ -z "\$PROJECT\_NAME" ] || \[ -z "\$VERSION" ]; then
echo "Uso: init-project.sh <project-name> <version> \[docker-user]"
exit 1
fi

TARGET\_DIR="/output/\$PROJECT\_NAME"

echo "📦 Creando proyecto: \$PROJECT\_NAME"
echo "🔖 Versión: \$VERSION"
echo "🐳 Docker user: \$DOCKER\_USER"
echo

# 1) Crear carpeta destino

mkdir -p "\$TARGET\_DIR"

# 2) Copiar TODO el proyecto base

cp -R /usr/src/base/. "\$TARGET\_DIR"

# 2a) Quitar cualquier repo Git heredado

rm -rf "\$TARGET\_DIR/.git"

# 2b) Limpiar carpetas que no queremos en el scaffold

rm -rf "\$TARGET\_DIR/dist" "\$TARGET\_DIR/node\_modules"

# 2c) Reescribir name y version en package.json, eliminar lock viejo

sed -i -E "s/"name": \*"\[^"]+"/"name": "\$PROJECT\_NAME"/" "\$TARGET\_DIR/package.json"
sed -i -E "s/"version": \*"\[^"]+"/"version": "\$VERSION"/"    "\$TARGET\_DIR/package.json"
rm -f "\$TARGET\_DIR/package-lock.json"

# 2d) Eliminar carpeta de scripts

rm -rf "\$TARGET\_DIR/scripts"

# 2e) Ajustar Dockerfile para runtime-only

DOCKERFILE="\$TARGET\_DIR/Dockerfile"
sed -n '/^FROM nginx\:stable-alpine/,\$p' "\$DOCKERFILE" > "\$DOCKERFILE.tmp"
mv "\$DOCKERFILE.tmp" "\$DOCKERFILE"

# 2f) Ajustar workflow de GitHub Actions

WORKFLOW="\$TARGET\_DIR/.github/workflows/deploy.yml"

# - Eliminar sección de builder completo

sed -i '/name: 🔨 Build & Push BUILDER image/,/name: ⚙️ Build & Push RUNTIME image/{//!d}' "\$WORKFLOW"

# - Renombrar la cabecera runtime

UPPER\_NAME=\$(printf '%s' "\$PROJECT\_NAME" | tr '\[:lower:]' '\[:upper:]')
sed -i "s|name: ⚙️ Build & Push RUNTIME image|name: 🔨 Build & Push \${UPPER\_NAME}-RUNTIME image|g" "\$WORKFLOW"

# - Actualizar comandos Docker para runtime con saltos reales

sed -i "/docker build --target production/ c\\
docker build --target production \\
-t \$DOCKER\_USER/\${PROJECT\_NAME}-runtime:\\\${{ env.VERSION }} \\
-t \$DOCKER\_USER/\${PROJECT\_NAME}-runtime\:latest ." "\$WORKFLOW"

sed -i "/docker push/ c\\
docker push \$DOCKER\_USER/\${PROJECT\_NAME}-runtime:\\\${{ env.VERSION }} \\
docker push \$DOCKER\_USER/\${PROJECT\_NAME}-runtime\:latest" "\$WORKFLOW"

# 2g) Regenerar README.md mínimo

rm -f "\$TARGET\_DIR/README.md"
cat > "\$TARGET\_DIR/README.md" << EOF

# \$PROJECT\_NAME

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

find "\$TARGET\_DIR" -type f&#x20;
$-name "*.yml" -o -name "*.md" -o -name ".gitignore" -o -name "Dockerfile"$&#x20;
-exec sed -i -e "s/**DOCKER\_USER**/\$DOCKER\_USER/g" {} \\

# 4) Inicializar git local

echo "🔧 Inicializando repositorio Git en \$TARGET\_DIR"
cd "\$TARGET\_DIR"
git init

# Configurar identidad Git

GIT\_NAME="\${GIT\_USER\_NAME:-PabloNicolas87}"
GIT\_EMAIL="\${GIT\_USER\_EMAIL:[-gironepablo@gmail.com](mailto:-gironepablo@gmail.com)}"
echo "✏️  Configurando Git user.name=\$GIT\_NAME user.email=\$GIT\_EMAIL"
git config user.name  "\$GIT\_NAME"
git config user.email "\$GIT\_EMAIL"

git add .
git commit -m "chore: init \$PROJECT\_NAME@\$VERSION"

echo

```
```
echo "✅ Proyecto \$PROJECT\_NAME inicializado en \$TARGET\_DIR"
echo "Puedes empezar a desarrollar ejecutando:"
echo "cd \$TARGET\_DIR && npm install && npm run dev"
echo "Y desplegarlo con:"
echo "cd \$TARGET\_DIR && git push origin main"
echo "Recuerda que la imagen runtime se publica automáticamente en Docker Hub."