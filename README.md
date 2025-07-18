# Proyecto Base Front‑End

Este repositorio contiene un **proyecto base** para aplicaciones Front‑End modernas, con todo lo necesario para arrancar rápido y garantizar calidad, performance y despliegue automatizado.

---

## 🚀 Características principales

* **Stack**: React (con Vite), TypeScript, Redux Toolkit, React‑Redux y Tailwind CSS.
* **Testing**: Vitest y Testing Library para tests unitarios e integración.
* **Calidad**: ESLint y Prettier configurados por defecto.
* **Backend ligero**: Configuración base de Firebase (autenticación y almacenamiento) opcional.
* **Docker**: Dockerfile multi‑stage para build y producción con Nginx.
* **CI/CD**: Pipeline en GitHub Actions que:

  1. Instala dependencias (`npm ci`).
  2. Ejecuta tests.
  3. Compila la aplicación (`npm run build`).
  4. Construye y publica imágenes Docker (builder y runtime) en Docker Hub.
  5. Limpia imágenes colgantes para no acumular espacio.

---

## 🏗️ Estructura del proyecto

```text
/ (raíz)
├─ src/                       # Código fuente (componentes, páginas, estilos)
├─ public/                    # Archivos estáticos (index.html, favicon)
├─ Dockerfile                 # Multi‑stage: build y servidor (Nginx)
├─ nginx.conf                 # Configuración para servir SPA correctamente
├─ package.json               # Dependencias y scripts
├─ vite.config.ts             # Configuración de Vite
├─ tsconfig.json              # Configuración de TypeScript
├─ .eslintrc.js               # Reglas de ESLint
├─ .prettierrc                # Configuración de Prettier
├─ .github/
│  └─ workflows/
│     └─ deploy.yml           # CI/CD: build, Docker, push
├─ README.md                  # Documentación (este archivo)
└─ ...
```

---

## 📦 Dependencias y herramientas instaladas

* **Dependencias de ejecución**:

  * `react`, `react-dom`
  * `@reduxjs/toolkit`, `react-redux`
  * `firebase`
* **Herramientas de desarrollo y pruebas**:

  * `vitest`, `@testing-library/react`
  * `typescript`, `eslint`, `prettier`
  * Plugins para Vite y React
  * `tailwindcss`, autoprefixer, postcss

Con estas herramientas obtienes un entorno listo para programar en React con tipado estático, estilos mediante Tailwind y pruebas automáticas.

---

## 🐳 Docker Multi‑stage build

En el `Dockerfile` se definen dos etapas:

1. **builder** (`node:20-alpine`):

   * Instala Git y SSH.
   * Copia el código y `package*.json`, ejecuta `npm install`.
   * Ejecuta `npm run build` para generar `/app/dist`.
   * Copia todo el proyecto a `/usr/src/base` y añade el script `init-project.sh`.
2. **production** (`nginx:stable-alpine`):

   * Copia el build estático (`/app/dist`) a `/usr/share/nginx/html`.
   * Usa `nginx.conf` personalizado.
   * Expone el puerto 80 y arranca Nginx.

Esto produce dos imágenes:

* `*-builder`: contiene la plantilla y script de scaffolding.
* `*-runtime`: imagen mínima con Nginx para servir la aplicación.

---

## ⚙️ CI/CD con GitHub Actions

El workflow `.github/workflows/deploy.yml` se ejecuta en cada push a `main` o tag `v*`. Sus pasos:

1. Checkout del código.
2. Determina la versión (tag o `latest`).

* La CI/CD generada en `.github/workflows/deploy.yml` construye y publica únicamente la imagen **runtime**, no la **builder**.

3. Configura Node.js v20.
4. Instala dependencias (`npm ci`).
5. Ejecuta tests.
6. Compila el proyecto.
7. Configura Docker Buildx y logueo en Docker Hub.
8. Construye y publica las imágenes `builder` y `runtime` con tags `version` y `latest`.
9. Limpia imágenes colgantes.

---

## 🔧 Requisitos previos

* Node.js v20+
* npm
* Docker Desktop o Docker Engine
* Cuenta en Docker Hub
* Git
* (Opcional) GitHub CLI (`gh`)

---

## 🛠️ Uso como plantilla (scaffolding)

Sigue estos pasos para crear un nuevo proyecto a partir de esta plantilla:

1. **Descarga la imagen builder**

   ```bash
   docker pull pablonicolas87/proyectobase-builder:latest
   ```

2. **Genera el proyecto**

   ```bash
   docker run --rm \
     -u "$(id -u):$(id -g)" \
     -v "$(pwd)":/output \
     -e GIT_USER_NAME="<TuNombre>" \
     -e GIT_USER_EMAIL="<TuEmail>" \
     pablonicolas87/proyectobase-builder:latest \
     init-project.sh <PROJECT_NAME> <VERSION> <DOCKER_USER>
   ```

3. **Inicializa tu repositorio en GitHub** (opcional):

   ```bash
   gh repo create <GIT_USER_NAME>/<PROJECT_NAME> \
     --public \
     --source=. \
     --remote=origin \
     --push
   ```

4. **Configura secrets** en GitHub:

   * `DOCKERHUB_USERNAME`
   * `DOCKERHUB_TOKEN`

5. **¡Empieza a desarrollar!**

   ```bash
   cd <PROJECT_NAME>
   npm install
   npm run dev
   ```

---

## 🤝 Contribuir

Si quieres mejorar o sugerir cambios:

1. Crea una **issue** o **pull request**.
2. Sigue el flujo `dev → pull request → main`.

> *Proyecto base de Front‑End con Docker & CI/CD para arrancar aplicaciones modernas de manera consistente y escalable.*
