import { SURVEYS } from './actions'

const initState = {
  isFetching: false,
  survey: {},
  reasons: [],
  visiable: false,
}

export default function surveysReducer(state = initState, action) {
  switch (action.type) {
    case SURVEYS.SET_MODAL_VISIABLE:
      return {
        ...state,
        visiable: action.payload,
      }
    case SURVEYS.FETCH_REQUEST:
      return {
        ...state,
        isFetching: true,
      }
    case SURVEYS.FETCH_SUCCESS:
      return {
        ...state,
        isFetching: false,
        survey: action.payload,
      }
    case SURVEYS.FETCH_FAILURE:
      return { ...state, isFetching: false }
    case SURVEYS.UPDATE_SUCCESS:
      return {
        ...state,
        visiable: false,
      }
    case SURVEYS.FETCH_REASONS_SUCCESS:
      return {
        ...state,
        reasons: action.payload,
      }
    case SURVEYS.FETCH_REASONS_FAILURE:
      return {
        ...state,
        visiable: false,
      }
    default:
      return state
  }
}
