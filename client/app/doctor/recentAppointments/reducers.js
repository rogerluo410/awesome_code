import { createEntityListReducer } from 'app/api/reducers'
import { RECENT_APPOINTMENTS } from './actions'

export default createEntityListReducer({
  actions: [
    RECENT_APPOINTMENTS.FETCH,
    RECENT_APPOINTMENTS.FETCH_SUCCESS,
    RECENT_APPOINTMENTS.FETCH_FAIL,
  ],
})
