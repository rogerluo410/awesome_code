import { AUTH } from './actions'

const initState = {
  isSignedIn: false,
  user: {},
}

function authReducer(state = initState, action) {
  switch (action.type) {
    case AUTH.SIGN_IN:
      return {
        isSignedIn: true,
        user: action.payload,
      }
    case AUTH.SIGN_OUT:
      return {
        isSignedIn: false,
        user: {},
      }
    default:
      return state
  }
}

export default authReducer
