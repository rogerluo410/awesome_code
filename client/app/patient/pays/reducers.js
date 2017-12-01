import { PAYS } from './actions'

const initState = {
  visiable: false,
  submitting: false,
}

export default function paysReducer(state = initState, action) {
  switch (action.type) {
    case PAYS.SET_MODAL_VISIABLE:
      return {
        ...state,
        visiable: action.payload,
      }
    case PAYS.SUBMIT_ENABLED:
      return {
        ...state,
        submitting: action.payload,
      }
    default:
      return state
  }
}
