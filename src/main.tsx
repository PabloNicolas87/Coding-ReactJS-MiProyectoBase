import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import './styles/global.css'
import { store } from './app/store'
import { Provider } from 'react-redux'
import React from 'react'


createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <Provider store={store}>
      <App />
    </Provider>
  </React.StrictMode>,
)
