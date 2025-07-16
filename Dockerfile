# —————— Etapa 1: Build del proyecto ——————
FROM node:20-alpine AS builder

# Instalar Git, SSH y GitHub CLI
RUN apk update && apk add --no-cache \
    git \
    openssh-client \
    curl \
  && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
     | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "https://cli.github.com/packages alpine main" \
     | tee /etc/apk/repositories \
  && apk add --no-cache gh

WORKDIR /app

# Copiamos solo lo necesario para instalar deps
COPY package*.json ./
RUN npm install

# Copiamos el resto del código y generamos el build
COPY . .
RUN npm run build

# — Copiamos TODO el proyecto base como plantilla “base” —
RUN mkdir -p /usr/src/base
RUN cp -R /app/. /usr/src/base/

# Añade el script de scaffolding para proyectos nuevos
COPY scripts/init-project.sh /usr/local/bin/init-project.sh
RUN chmod +x /usr/local/bin/init-project.sh

# —————— Etapa 2: Servir el build con NGINX ——————
FROM nginx:stable-alpine AS production

# Copiamos el artefacto compilado desde la etapa builder
COPY --from=builder /app/dist /usr/share/nginx/html

# (Opcional) Si tienes configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
