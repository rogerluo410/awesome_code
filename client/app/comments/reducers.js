import { COMMENTS } from './actions'

const initState = {
  visiable: false,
  submitting: false,
  isFetching: false,
  ids: [],
  appointmentId: '',
}

export default function commentsReducer(state = initState, action) {
  switch (action.type) {
    case COMMENTS.SET_MODAL_VISIABLE:
      return {
        ...state,
        visiable: action.payload,
      }
    case COMMENTS.SET_APPOINTMENT:
      return {
        ...state,
        appointmentId: action.payload,
      }
    case COMMENTS.FETCH_REQUEST:
      return {
        ...state,
        isFetching: true,
      }
    case COMMENTS.FETCH_SUCCESS:
      return {
        ...state,
        isFetching: false,
        ids: action.payload.map(i => i.id),
      }
    case COMMENTS.FETCH_FAIL:
      return {
        ...state,
        isFetching: false,
      }
    case COMMENTS.SAVE_SUCCESS:
      return {
        ...state,
        ids: [...state.ids, action.payload.id],
      }
    default:
      return state
  }
}
