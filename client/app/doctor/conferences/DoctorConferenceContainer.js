import { connect } from 'react-redux'
import {
  updateConference,
  createConference,
  postNotification,
  receiveNotification,
  resetConferenceData,
} from 'app/conferences/actions'
import DoctorConference from './DoctorConference'

function mapStateToProps(state) {
  return {
    token: state.conference.token,
    patient: state.conference.user,
    conferenceId: state.conference.conferenceId,
    serverError: state.conference.serverError,
    declinedCallFrom: state.conference.declinedCallFrom,
  }
}

export default connect(mapStateToProps, {
  updateConference,
  createConference,
  postNotification,
  receiveNotification,
  resetConferenceData,
})(DoctorConference)
