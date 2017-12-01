import { createEntityReducer } from 'app/api/reducers'
import { DOCTOR } from './actions'

export default createEntityReducer({
  actions: [
    DOCTOR.FETCH,
    DOCTOR.FETCH_SUCCESS,
    DOCTOR.FETCH_FAIL,
  ],
})
