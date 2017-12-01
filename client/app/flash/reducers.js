import { FLASH } from './actions'

export default function flashReducer(state = {}, action) {
  switch (action.type) {
    case FLASH.ADD_MESSAGE:
      return action.payload
    default:
      return state
  }
}
