import { CONFERENCE } from './actions'

const initState = {
  token: null,
  submitting: false,
  user: null,
  conferenceId: null,
  serverError: '',
  declinedCallFrom: null,
}

export default function conferenceReducer(state = initState, action) {
  switch (action.type) {
    case CONFERENCE.GENERATE_TOKEN_SUCCESS:
      return {
        ...state,
        token: action.payload,
      }
    case CONFERENCE.REQUEST_DOCTOR_PROFILE_SUCCESS:
      return {
        ...state,
        user: action.payload,
      }
    case CONFERENCE.CREATE_CONFERENCE_SUCCESS:
      return {
        ...state,
        conferenceId: action.payload.conference_id,
        user: action.payload.patient,
      }
    case CONFERENCE.FINISH_CONFERENCE_REQUEST:
      return {
        ...state,
        submitting: true,
      }
    case CONFERENCE.FINISH_CONFERENCE_FAILED:
      return {
        ...state,
        submitting: false,
      }
    case CONFERENCE.STOP_PROCESS:
      return {
        ...state,
        serverError: action.payload,
      }
    case CONFERENCE.REFUND_CONFERENCE_REQUEST:
      return {
        ...state,
        submitting: true,
      }
    case CONFERENCE.REFUND_CONFERENCE_FAILED:
      return {
        ...state,
        submitting: false,
      }
    case CONFERENCE.RECEIVE_NOTIFICATION:
      return {
        ...state,
        declinedCallFrom: {
          appointmentId: action.payload.appointment_id,
          patientId: action.payload.patient_id,
        },
      }
    case CONFERENCE.RESET_DATA:
      return initState
    default:
      return state
  }
}
