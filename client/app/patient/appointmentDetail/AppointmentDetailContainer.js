import { connect } from 'react-redux'
import AppointmentDetail from './AppointmentDetail'
import { getCurrentUserSelector } from 'app/auth/selectors'
import { fetchAppointmentDetail } from './actions'
import { saveComment } from 'app/comments/actions'
import { getAppointmentDetail } from './selectors'


function mapStateToProps(state) {
  return {
    currentUserId: getCurrentUserSelector(state).id,
    ...getAppointmentDetail(state),
  }
}

function mapDispatchToProps(dispatch) {
  return {
    save: (data) => saveComment(data, dispatch),
    fetchAppointmentDetail: (appointmentId) => dispatch(
        fetchAppointmentDetail(appointmentId)
      ),
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AppointmentDetail)
