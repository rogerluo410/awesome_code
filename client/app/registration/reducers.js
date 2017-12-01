import { REGISTRATION } from './actions'

const initState = {
  visiable: false,
  enabled: true,
  errorMessage: '',
}

function registrationReducer(state = initState, action) {
  switch (action.type) {
    case REGISTRATION.SET_MODAL_VISIABLE:
      return {
        visiable: action.payload,
        enabled: true,
        errorMessage: '',
      }
    case REGISTRATION.REQUEST_REGISTER:
      return {
        ...state,
        enabled: false,
      }
    case REGISTRATION.RESET_MODAL:
      return {
        visiable: false,
        enabled: true,
        errorMessage: '',
      }
    case REGISTRATION.REGISTER_FAILED:
      return {
        ...state,
        enabled: false,
        errorMessage: action.payload,
      }
    default:
      return state
  }
}

export default registrationReducer
