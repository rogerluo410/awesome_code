import { PROMPT } from './actions'

const initState = {
  isShown: false,
  appointmentId: null,
  doctor: {},
  isDisabled: false,
}

export default function promptReducer(state = initState, action) {
  switch (action.type) {
    case PROMPT.RECEIVE:
      return {
        ...state,
        isShown: true,
        appointmentId: action.payload.appointment_id,
        doctor: action.payload.doctor,
      }
    case PROMPT.CLOSE_MODAL:
      return {
        ...state,
        isShown: false,
        isDisabled: false,
        appointmentId: null,
        doctor: {},
      }
    case PROMPT.DECLINE_CALL_REQUEST:
      return {
        ...state,
        isDisabled: true,
      }
    case PROMPT.DECLINE_CALL_SUCCESS:
      return {
        ...state,
        isDisabled: false,
        isShown: false,
      }
    case PROMPT.DECLINE_CALL_FAILED:
      return {
        ...state,
        isDisabled: false,
      }
    default:
      return state
  }
}
