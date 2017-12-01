import { createEntityReducer } from 'app/api/reducers'
import { APPOINTMENT_DETAIL } from './actions'

export default createEntityReducer({
  actions: [
    APPOINTMENT_DETAIL.FETCH,
    APPOINTMENT_DETAIL.FETCH_SUCCESS,
    APPOINTMENT_DETAIL.FETCH_FAIL,
  ],
})
