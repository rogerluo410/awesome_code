import { createEntityListReducer } from 'app/api/reducers'
import { APP_SCHEDULE } from './actions'

export default createEntityListReducer({
  actions: [
    APP_SCHEDULE.FETCH,
    APP_SCHEDULE.FETCH_SUCCESS,
    APP_SCHEDULE.FETCH_FAIL,
  ],
})
