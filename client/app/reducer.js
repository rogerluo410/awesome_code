import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'
import { reducer as formReducer } from 'redux-form'
import apiEntities from './api/reducers'
import flash from './flash/reducers'
import auth from './auth/reducers'
import doctors from './doctors/reducers'
import specialties from './specialties/reducers'
import registration from './registration/reducers'
import notifications from './notifications/reducers'
import comments from './comments/reducers'
import patientRootReducer from './patient/reducers'
import doctorRootReducer from './doctor/reducers'
import conference from './conferences/reducers'
import prompt from './prompts/reducers'
import doctorDetailRootReducer from './doctorDetail/reducers'

export default combineReducers({
  routing: routerReducer,
  form: formReducer,
  apiEntities,
  flash,
  auth,
  doctors,
  specialties,
  registration,
  notifications,
  comments,
  patient: patientRootReducer, // combine all patient domain reducers
  doctor: doctorRootReducer, // combine all doctor domain reducers
  doctorDetail: doctorDetailRootReducer,
  conference,
  prompt,
})
