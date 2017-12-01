import { connect } from 'react-redux'
import { getAppReview } from './selectors'
import { hideAppReviewModal, approveApp, declineApp } from './actions'
import AppReviewModal from './AppReviewModal'

export default connect(
  getAppReview,
  { hideAppReviewModal, approveApp, declineApp }
)(AppReviewModal)
