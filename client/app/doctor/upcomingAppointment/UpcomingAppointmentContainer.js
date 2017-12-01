import { connect } from 'react-redux'
import UpcomingAppointment from './UpcomingAppointment'
import { getUpcomingAppointment } from './selectors'
import { fetchUpcomingAppointment } from './actions'

function mapStateToProps(state) {
  return getUpcomingAppointment(state)
}

export default connect(mapStateToProps, { fetchUpcomingAppointment })(UpcomingAppointment)
