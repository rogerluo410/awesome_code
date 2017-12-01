import { createEntityListReducer } from 'app/api/reducers'
import { WEEKLY_PLAN } from './actions'

export default createEntityListReducer({
  actions: [
    WEEKLY_PLAN.FETCH,
    WEEKLY_PLAN.FETCH_SUCCESS,
    WEEKLY_PLAN.FETCH_FAIL,
  ],
})
