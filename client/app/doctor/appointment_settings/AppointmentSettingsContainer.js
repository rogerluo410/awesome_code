import { connect } from 'react-redux'
import { fetchAppointmentSettings } from './actions'
import AppointmentSettings from './AppointmentSettings'

export default connect(null, { fetchAppointmentSettings })(AppointmentSettings)
