import axios from 'axios'

let isRedirectingToSignIn = false

// It's a lightly customized axios instance.
// Check APIs here: https://github.com/mzabriskie/axios
const api = axios.create({
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json',
    'X-Session-Auth': true,
  },
  responseType: 'json',
})

// Temporary handle 401, currently we use full page redirection
api.interceptors.response.use(response => response, err => {
  if (err.response && err.response.status === 401) {
    handle401()
  }
  if (err.response) {
    // eslint-disable-next-line no-param-reassign
    err.errorData = { message: err.response.data.error.message }
  } else {
    // eslint-disable-next-line no-param-reassign
    err.errorData = { message: err.message }
  }
  return Promise.reject(err)
})

function handle401() {
  if (isRedirectingToSignIn) return

  isRedirectingToSignIn = true
  location.href = '/users/sign_in'
}

export default api
