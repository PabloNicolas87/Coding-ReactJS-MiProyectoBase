// src/features/user/userSlice.ts
import { createSlice, type PayloadAction } from '@reduxjs/toolkit'

interface UserState {
  name: string
  email: string
  loggedIn: boolean
}

const initialState: UserState = {
  name: '',
  email: '',
  loggedIn: false
}

const userSlice = createSlice({
  name: 'user',
  initialState,
  reducers: {
    login: (state, action: PayloadAction<{ name: string; email: string }>) => {
      state.name = action.payload.name
      state.email = action.payload.email
      state.loggedIn = true
    },
    logout: (state) => {
      state.name = ''
      state.email = ''
      state.loggedIn = false
    }
  }
})

export const { login, logout } = userSlice.actions
export default userSlice.reducer
