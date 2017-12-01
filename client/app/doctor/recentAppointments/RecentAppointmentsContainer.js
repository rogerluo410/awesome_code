import { connect } from 'react-redux'
import RecentAppointments from './RecentAppointments'
import { fetchRecentAppointments } from './actions'
import { getRecentAppointments } from './selectors'
import { showCommentsModal } from 'app/comments/actions'
import { showPrescriptionsModal } from '../attachments/actions'


export default connect(getRecentAppointments, {
  fetchRecentAppointments, showCommentsModal, showPrescriptionsModal,
})(RecentAppointments)
