# —————— Etapa 1: Build del proyecto ——————
FROM node:20-alpine AS builder

# 1) Instalamos Git y SSH para que init-project.sh pueda inicializar el repo local.
RUN apk update && apk add --no-cache \
    git \
    openssh-client

WORKDIR /app

# 2) Instalar dependencias y generar build de tu proyecto base
COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# 3) Copiamos TODO el proyecto base como plantilla “base”
RUN mkdir -p /usr/src/base
RUN cp -R /app/. /usr/src/base/

# 4) Copiamos el script de scaffolding y le damos permiso de ejecución
COPY scripts/init-project.sh /usr/local/bin/init-project.sh
RUN chmod +x /usr/local/bin/init-project.sh

# —————— Etapa 2: Servir el build con NGINX ——————
FROM nginx:stable-alpine AS production

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
