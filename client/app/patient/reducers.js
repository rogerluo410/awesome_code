import { combineReducers } from 'redux'
import appointments from './appointments/reducers'
import surveys from './surveys/reducers'
import pays from './pays/reducers'
import checkouts from './checkouts/reducers'
import appointmentDetail from './appointmentDetail/reducers'
import pharmacies from './pharmacies/reducers'

export default combineReducers({
  appointments,
  surveys,
  pays,
  checkouts,
  appointmentDetail,
  pharmacies,
})
