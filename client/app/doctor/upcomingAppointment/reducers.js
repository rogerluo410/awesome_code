import { UPCOMING_APPOINTMENT } from './actions'
import { createEntityReducer } from 'app/api/reducers'

export default createEntityReducer({
  actions: [
    UPCOMING_APPOINTMENT.FETCH,
    UPCOMING_APPOINTMENT.FETCH_SUCCESS,
    UPCOMING_APPOINTMENT.FETCH_FAIL,
  ],
})
