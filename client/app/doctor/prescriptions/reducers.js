import { PRESCRIPTIONS } from './actions'

const initState = {
  isFetching: false,
  ids: [],
}

export default function prescriptionsReducer(state = initState, action) {
  switch (action.type) {
    case PRESCRIPTIONS.FETCH:
      return {
        ...state,
        isFetching: true,
      }
    case PRESCRIPTIONS.FETCH_SUCCESS:
      return {
        ...state,
        isFetching: false,
        ids: action.payload.map(i => i.id),
      }
    case PRESCRIPTIONS.FETCH_FAILURE:
      return {
        ...state,
        isFetching: false,
      }
    case PRESCRIPTIONS.SAVE_SUCCESS:
      return {
        ...state,
        ids: [action.payload.id, ...state.ids],
      }
    case PRESCRIPTIONS.DESTROY_SUCCESS:
      return {
        ...state,
        ids: state.ids.filter(id => id !== action.payload),
      }
    default:
      return state
  }
}
