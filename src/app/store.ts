// src/app/store.ts
import { configureStore } from '@reduxjs/toolkit'
import userReducer from '../features/user/userSlice'

export const store = configureStore({
  reducer: {
    user: userReducer
  }
})

// Inferimos tipos para usar en hooks
export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
