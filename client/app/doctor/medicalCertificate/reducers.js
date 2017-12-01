import { MEDICAL_CERTIFICATE } from './actions'

const initState = {
  isFetching: false,
  id: '',
}

export default function medicalCertificateReducer(state = initState, action) {
  switch (action.type) {
    case MEDICAL_CERTIFICATE.FETCH:
      return {
        ...state,
        isFetching: true,
      }
    case MEDICAL_CERTIFICATE.FETCH_SUCCESS:
      return {
        ...state,
        isFetching: false,
        id: action.payload && action.payload.id,
      }
    case MEDICAL_CERTIFICATE.FETCH_FAILURE:
      return {
        ...state,
        isFetching: false,
      }
    case MEDICAL_CERTIFICATE.SAVE_SUCCESS:
      return {
        ...state,
        id: action.payload.id,
      }
    case MEDICAL_CERTIFICATE.DESTROY_SUCCESS:
      return {
        ...state,
        id: '',
      }
    default:
      return state
  }
}
