# 🚀 Mi Proyecto Base - Frontend Moderno

Plantilla moderna para iniciar cualquier proyecto Front-End con el stack:

- Vite  
- React + TypeScript  
- Redux Toolkit  
- Tailwind CSS  
- Firebase  
- Vitest  
- Docker (por configurar)  
- GitHub Actions (por configurar)  

---

## 📦 Stack tecnológico

| Herramienta     | Rol                              |
|-----------------|-----------------------------------|
| Vite            | Bundler ultrarrápido              |
| React + TS      | UI + tipado estricto              |
| Redux Toolkit   | Manejo de estado global           |
| Tailwind CSS    | Estilos utilitarios               |
| Firebase        | Backend (auth, db, storage)       |
| Vitest          | Testing rápido con jsdom          |
| Docker 🐳       | Entorno reproducible (próximamente) |
| GitHub Actions  | CI/CD automático (próximamente)   |

## 🛠️ Instalación

```bash
# Clonar el repositorio
git clone <tu-repo>
cd Coding-MiProyectoBase

# Instalar dependencias
npm install

# Ejecutar en desarrollo
npm run dev
```

## 📝 Scripts disponibles

```bash
npm run dev      # Servidor de desarrollo
npm run build    # Build de producción
npm run preview  # Preview del build
npm run test     # Ejecutar tests
npm run lint     # Linter ESLint
```

## 🏗️ Estructura del proyecto

```
src/
├── app/          # Store de Redux
├── components/   # Componentes reutilizables
├── features/     # Features con slices de Redux
├── hooks/        # Custom hooks
├── pages/        # Páginas/rutas
├── services/     # APIs y servicios
└── utils/        # Utilidades
```

## 🔥 Características

- ⚡ **Vite** - Build tool ultrarrápido
- 🎯 **TypeScript** - Tipado estático
- 🔄 **Redux Toolkit** - Estado global simplificado
- 🎨 **Tailwind CSS** - Estilos utilitarios
- 🔐 **Firebase** - Autenticación y base de datos
- 🧪 **Vitest** - Testing moderno
- 📱 **Responsive** - Diseño adaptable
- 🚀 **Hot Reload** - Recarga instantánea

## 🚧 Próximas mejoras

- [ ] Configuración de Docker
- [ ] Pipeline de CI/CD con GitHub Actions
- [ ] PWA (Progressive Web App)
- [ ] Internacionalización (i18n)
- [ ] Storybook para componentes