# Etapa 1: Build del proyecto
FROM node:20-alpine AS builder

WORKDIR /app

# Copiamos solo lo necesario para instalar deps
COPY package*.json ./
RUN npm install

# Copiamos el resto del código
COPY . .

# Ejecutamos el build de producción
RUN npm run build

# Etapa 2: Servir el build con NGINX
FROM nginx:stable-alpine

# Copiamos el build generado desde el paso anterior
COPY --from=builder /app/dist /usr/share/nginx/html

# Copiamos config para NGINX
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
