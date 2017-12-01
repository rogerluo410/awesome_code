import { connect } from 'react-redux'
import { closeModal } from './actions'
import AttachmentsModal from './AttachmentsModal'

function mapStateToProps(state) {
  return {
    visiable: state.doctor.attachments.visiable,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    cancel: () => { dispatch(closeModal()) },
  }
}

export default connect(
  mapStateToProps, mapDispatchToProps
)(AttachmentsModal)
