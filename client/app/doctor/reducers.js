import { combineReducers } from 'redux'
import appointmentSettings from './appointment_settings/reducers'
import upcomingAppointment from './upcomingAppointment/reducers'
import recentAppointments from './recentAppointments/reducers'
import appSchedule from './appSchedule/reducers'
import appReview from './appReview/reducers'
import weeklyPlan from './weeklyPlan/reducers'
import attachments from './attachments/reducers'
import prescriptions from './prescriptions/reducers'
import medicalCertificate from './medicalCertificate/reducers'
import bankAccount from './bankAccount/reducers'

export default combineReducers({
  appointmentSettings,
  upcomingAppointment,
  recentAppointments,
  appSchedule,
  appReview,
  weeklyPlan,
  attachments,
  medicalCertificate,
  bankAccount,
  prescriptions,
})
