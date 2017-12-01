import { BANK_ACCOUNT } from './actions'

const initState = {
  isFetching: false,
  id: '',
  visiable: false,
  deleting: false,
}

export default function bankAccountReducer(state = initState, action) {
  switch (action.type) {
    case BANK_ACCOUNT.SET_MODAL_VISIABLE:
      return {
        ...state,
        visiable: action.payload,
      }
    case BANK_ACCOUNT.FETCH:
      return {
        ...state,
        isFetching: true,
      }
    case BANK_ACCOUNT.FETCH_SUCCESS:
      return {
        ...state,
        isFetching: false,
        id: action.payload && action.payload.id,
      }
    case BANK_ACCOUNT.FETCH_FAILURE:
      return {
        ...state,
        isFetching: false,
      }
    case BANK_ACCOUNT.SAVE_SUCCESS:
      return {
        ...state,
        id: action.payload.id,
      }
    case BANK_ACCOUNT.DESTROY_SUCCESS:
      return {
        ...state,
        id: '',
        deleting: false,
      }
    case BANK_ACCOUNT.TOGGLE_DELETE:
      return {
        ...state,
        deleting: true,
      }
    default:
      return state
  }
}
