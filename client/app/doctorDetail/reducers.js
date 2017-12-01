import { combineReducers } from 'redux'
import doctor from './doctor/reducers'
import todayTime from './todayTime/reducers'

export default combineReducers({
  doctor,
  todayTime,
})
