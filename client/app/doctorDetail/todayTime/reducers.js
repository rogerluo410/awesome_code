import { createEntityListReducer } from 'app/api/reducers'
import { TODAY_TIMES } from './actions'

export default createEntityListReducer({
  actions: [
    TODAY_TIMES.FETCH,
    TODAY_TIMES.FETCH_SUCCESS,
    TODAY_TIMES.FETCH_FAIL,
  ],
})
