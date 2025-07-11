// src/features/user/userSelectors.ts
import type { RootState } from '../../app/store'

export const selectUser = (state: RootState) => state.user
export const selectIsLoggedIn = (state: RootState) => state.user.loggedIn
