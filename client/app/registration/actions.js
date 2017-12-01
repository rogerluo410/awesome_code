import api from 'app/api/api'
import { signInSuccess } from 'app/auth/actions'
import { addFlashMessage } from 'app/flash/actions'

const REGISTRATION = {
  SET_MODAL_VISIABLE: 'REGISTRATION/SET_MODAL_VISIABLE',
  REGISTER: 'REGISTRATION/REGISTER',
  REQUEST_REGISTER: 'REGISTRATION/REQUEST_REGISTER',
  RESET_MODAL: 'REGISTRATION/RESET_MODAL',
  REGISTER_FAILED: 'REGISTRATION/REGISTER_FAILED',
}

function showModal() {
  return {
    type: REGISTRATION.SET_MODAL_VISIABLE,
    payload: true,
  }
}

function closeModal() {
  return {
    type: REGISTRATION.SET_MODAL_VISIABLE,
    payload: false,
  }
}

function register(params) {
  return dispatch => {
    dispatch(requestRegister())
    api.post('/v1/auth/register', params).then((resp) => {
      dispatch(regiserSuccess(resp.data.data))
    }).catch(err => {
      dispatch(registerFailed(err))
    })
  }
}

function requestRegister() {
  return {
    type: REGISTRATION.REQUEST_REGISTER,
  }
}

function regiserSuccess(user) {
  return dispatch => {
    dispatch(resetRegistrationModal())
    dispatch(signInSuccess(user))
    dispatch(addFlashMessage({
      message: 'You have successfully registered! Now you can continue the appointment.',
      level: 'success',
    }))
  }
}

function resetRegistrationModal() {
  return {
    type: REGISTRATION.RESET_MODAL,
  }
}

function registerFailed(error) {
  return {
    type: REGISTRATION.REGISTER_FAILED,
    payload: error.data.error.message,
    error: true,
  }
}
export {
  REGISTRATION,
  showModal,
  closeModal,
  register,
}
