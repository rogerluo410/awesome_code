import { combineReducers } from 'redux'
import { APPOINTMENTS } from './actions'
import { paginateReducer } from 'app/shared/pagination/helpers'

export default combineReducers({
  entities: entitiesReducer,
  activeAppointment,
  finishedAppointments: paginateReducer({
    actions: [
      APPOINTMENTS.FINISHED_REQUEST,
      APPOINTMENTS.FINISHED_SUCCESS,
      APPOINTMENTS.FINISHED_FAILURE,
    ],
  }),
})

function entitiesReducer(state = {}, { type, entities }) {
  switch (type) {
    case APPOINTMENTS.ACTIVE_SUCCESS:
    case APPOINTMENTS.FINISHED_SUCCESS:
    case APPOINTMENTS.PAID_SUCCESS:
    case APPOINTMENTS.RECEIVE:
      return entities ? { ...state, ...entities } : state
    default:
      return state
  }
}

function activeAppointment(state = { id: null, isFetching: false }, { type, payload }) {
  switch (type) {
    case APPOINTMENTS.ACTIVE_REQUEST:
    case APPOINTMENTS.ACTIVE_FAILURE:
      return {
        ...state,
        isFetching: true,
      }
    case APPOINTMENTS.ACTIVE_SUCCESS:
      return {
        ...state,
        isFetching: false,
        id: (payload && payload.id),
      }
    default:
      return state
  }
}
