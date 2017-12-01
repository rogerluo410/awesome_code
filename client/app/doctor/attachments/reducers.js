import { ATTACHMENTS } from './actions'

const initState = {
  visiable: false,
  appointmentId: 1,
}

export default function attachmentsReducer(state = initState, action) {
  switch (action.type) {
    case ATTACHMENTS.SET_MODAL_VISIABLE:
      return {
        ...state,
        visiable: action.payload,
      }
    case ATTACHMENTS.SET_APPPOINTMENT:
      return {
        ...state,
        appointmentId: action.payload,
      }
    default:
      return state
  }
}
