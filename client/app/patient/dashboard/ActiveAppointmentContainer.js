import { connect } from 'react-redux'
import ActiveAppointment from './ActiveAppointment'
import { getActiveAppointmentSelector } from '../appointments/selectors'
import { fetchActiveAppointment, receiveAppointment } from '../appointments/actions'
import { showSurveyModal } from '../surveys/actions'
import { showPayModal } from '../pays/actions'

function mapStateToProps(state) {
  return getActiveAppointmentSelector(state)
}

export default connect(
  mapStateToProps,
  { fetchActiveAppointment, showSurveyModal, showPayModal, receiveAppointment }
)(ActiveAppointment)
