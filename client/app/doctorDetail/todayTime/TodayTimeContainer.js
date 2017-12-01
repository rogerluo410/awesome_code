import { connect } from 'react-redux'
import { fetchDoctorTodayTime } from './actions'
import { appoint } from 'app/patient/appointments/actions'
import { getDoctorTodayTime } from './selectors'
import { getCurrentTimeZone, getCurrentDate } from 'app/timeZone/selectors'
import TodayTime from './TodayTime'

function mapStateToProps(state) {
  return {
    ...getDoctorTodayTime(state),
    timeZone: getCurrentTimeZone(state),
    date: getCurrentDate(state),
  }
}

export default connect(mapStateToProps, { fetchDoctorTodayTime, appoint })(TodayTime)
