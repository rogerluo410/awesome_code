import { connect } from 'react-redux'
import Workspace from './Workspace'
import { fetchSchedule } from '../appSchedule/actions'
import { refreshUpcoming } from '../upcomingAppointment/actions'

export default connect(
  null,
  { fetchSchedule, refreshUpcoming }
)(Workspace)
