# Proyecto Base Front‑End

Este repositorio contiene un **proyecto base** para aplicaciones Front‑End modernas, con todo lo necesario para arrancar rápido y garantizar calidad, performance y despliegue automatizado.

## 🚀 Características principales

* **Stack**: React (con Vite), TypeScript, Redux Toolkit, Tailwind CSS
* **Testing**: Vitest para tests unitarios y de integración
* **Backend ligero**: Configuración base de Firebase (opcional)
* **Docker**: Dockerfile multi‑stage para build y producción con Nginx
* **CI/CD**: Pipeline en GitHub Actions que:

  1. Instala dependencias
  2. Ejecuta tests
  3. Compila la aplicación
  4. Construye y publica imagen Docker en Docker Hub
  5. Limpia imágenes colgantes para no acumular espacio

## 🏗️ Estructura del proyecto

```text
/ (raíz)
├─ src/                # Código fuente (componentes, páginas, estilos)
├─ public/             # Archivos estáticos (index.html, favicon)
├─ Dockerfile          # Define build y servidor (Nginx)
├─ nginx.conf          # Configuración para servir SPA correctamente
├─ package.json        # Dependencias y scripts
├─ vite.config.ts      # Configuración de Vite
├─ tsconfig.json       # Configuración de TypeScript
├─ .github/
│  └─ workflows/
│     └─ deploy.yml    # CI/CD: build, Docker, push
├─ README.md           # Documentación (este archivo)
└─ ...
```

## 🛠️ Requisitos previos

* Node.js v20+
* npm o yarn
* Docker Desktop (para build y pruebas locales)
* Cuenta en Docker Hub (para publicar imágenes)
* Git y GitHub CLI (opcional)

## 🔧 Instalación y uso

1. **Clonar** el repositorio:

   ```bash
   git clone https://github.com/PabloNicolas87/ProyectoBase.git
   cd ProyectoBase
   ```

2. **Instalar** dependencias:

   ```bash
   npm install
   ```

3. **Desarrollo** con hot‑reload:

   ```bash
   npm run dev
   ```

   * Abre tu navegador en `http://localhost:5173`

4. **Testing**:

   ```bash
   npm run test
   ```

## 🐳 Docker (producción local)

1. **Build** de la imagen:

   ```bash
   docker build -t proyectobase:local .
   ```

2. **Run** del contenedor:

   ```bash
   docker run --rm -p 3000:80 proyectobase:local
   ```

   * Abre `http://localhost:3000` y verás tu aplicación servida con Nginx

## 🚢 Build y despliegue

* **Build de producción**:

  ```bash
  npm run build
  ```

  Genera la carpeta `/dist` optimizada.

* **CI/CD**: cada push a la rama `main` ejecuta el workflow:

  * instalación de dependencias
  * ejecución de tests
  * build en Vite
  * build y push de imagen Docker a Docker Hub

## 📦 Uso como plantilla

Para iniciar un nuevo proyecto (e‑commerce, gestión de alumnos, etc.) sin modificar este repo:

1. Marca este repo como **template** en GitHub (`Settings → Template repository`).

2. En GitHub haz clic en **Use this template** y crea un nuevo repositorio.

3. Clona tu nuevo repo y actualiza:

   * `package.json` (nombre y dependencias extras)
   * `.github/workflows/deploy.yml` (nombre de imagen y repo de Docker Hub)

4. Empieza a desarrollar sobre tu nuevo proyecto, conservando tu pipeline y Dockerfile listos.

5. **Opción adicional – Reutilizar la imagen Docker**: si prefieres no clonar el repositorio, puedes aprovechar directamente la imagen base publicada en Docker Hub. Crea un nuevo proyecto y define un `Dockerfile` que extienda la imagen pública, por ejemplo:



De este modo arrancas tu aplicación con todas las dependencias y configuración preinstalladas sin tocar el proyecto base.

## 🤝 Contribuir

Si quieres mejorar o sugerir cambios:

1. Crea una **issue** o un **pull request**.
2. Sigue el flujo `dev → pull request → main`.

---

> *Proyecto base de Front‑End con Docker & CI/CD diseñado para arrancar cualquier aplicación moderna de manera consistente y escalable.*
