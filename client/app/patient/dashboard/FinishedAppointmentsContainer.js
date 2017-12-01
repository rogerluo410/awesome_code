import { connect } from 'react-redux'
import FinishedAppointments from './FinishedAppointments'
import { fetchFinishedAppointments } from '../appointments/actions'
import { showCommentsModal } from 'app/comments/actions'
import { getFinishedAppointmentsSelector } from '../appointments/selectors'

function mapStateToProps(state) {
  return getFinishedAppointmentsSelector(state)
}

export default connect(mapStateToProps,
  { fetchFinishedAppointments, showCommentsModal }
)(FinishedAppointments)
