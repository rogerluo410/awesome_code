import { connect } from 'react-redux'
import Dashboard from './Dashboard'
import { fetchActiveAppointment, fetchFinishedAppointments } from '../appointments/actions'

export default connect(
  null,
  { fetchActiveAppointment, fetchFinishedAppointments }
)(Dashboard)
