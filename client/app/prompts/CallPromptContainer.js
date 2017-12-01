import { connect } from 'react-redux'
import CallPrompt from './CallPrompt'
import {
  receiveNotification,
  closeModal,
  declineCall,
} from './actions'

function mapStateToProps(state) {
  return {
    isSignedIn: state.auth.isSignedIn,
    user_type: state.auth.user.type || '',
    isShown: state.prompt.isShown,
    isDisabled: state.prompt.isDisabled,
    appointmentId: state.prompt.appointmentId,
    doctor: state.prompt.doctor,
  }
}
export default connect(mapStateToProps, {
  receiveNotification,
  closeModal,
  declineCall,
})(CallPrompt)
