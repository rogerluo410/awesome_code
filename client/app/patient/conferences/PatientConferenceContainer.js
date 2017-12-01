import { connect } from 'react-redux'
import {
	startCall,
	getDoctorProfile,
	finishConference,
	refundConference,
	resetConferenceData,
} from 'app/conferences/actions'

import PatientConference from './PatientConference'

function mapStateToProps(state) {
  return {
    token: state.conference.token,
    submitting: state.conference.submitting,
    doctor: state.conference.user,
    serverError: state.conference.serverError,
  }
}

export default connect(mapStateToProps, {
  startCall,
  getDoctorProfile,
  finishConference,
  refundConference,
  resetConferenceData,
})(PatientConference)
