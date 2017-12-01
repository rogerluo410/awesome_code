import { connect } from 'react-redux'
import AppSchedule from './AppSchedule'
import { fetchSchedule } from './actions'
import { showAppReviewModal } from '../appReview/actions'
import { getSchedule } from './selectors'

export default connect(
  getSchedule,
  { fetchSchedule, showAppReviewModal }
)(AppSchedule)
