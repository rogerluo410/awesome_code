import { connect } from 'react-redux'
import { closeModal, saveComment } from './actions'
import CommentListModal from './CommentListModal'
import { getCommentsSelector } from './selectors'
import { getCurrentUserSelector } from 'app/auth/selectors'


function mapStateToProps(state) {
  const { isFetching, comments } = getCommentsSelector(state)
  return {
    visiable: state.comments.visiable,
    appointmentId: state.comments.appointmentId,
    currentUserId: getCurrentUserSelector(state).id || 0,
    isFetching,
    comments,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    cancel: () => dispatch(closeModal()),
    save: (data) => saveComment(data, dispatch),
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(CommentListModal)
