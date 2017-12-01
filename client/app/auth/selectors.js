export function getIsSignedInSelector(state) {
  return state.auth.isSignedIn
}

export function getCurrentUserSelector(state) {
  return state.auth.user
}
