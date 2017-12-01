import api from 'app/api/api'

export const AUTH = {
  SIGN_IN: 'AUTH/SIGN_IN',
  SIGN_OUT: 'AUTH/SIGN_OUT',
}

function signOut() {
  return () => {
    api.delete('/users/sign_out').then(() => {
      // TODO add sign out when sign in/out are implemented in React
      // dispatch(signOutSuccess())
      location.href = '/'
    })
  }
}

// TODO add sign out when sign in/out are implemented in React
// function signOutSuccess() {
//   return {
//     type: AUTH.SIGN_OUT,
//   }
// }

function signInSuccess(user) {
  return {
    type: AUTH.SIGN_IN,
    payload: user,
  }
}
export {
  signOut,
  signInSuccess,
}
