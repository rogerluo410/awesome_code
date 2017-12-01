import { connect } from 'react-redux'
import { getDoctorsSelector, getDoctorsTotalCountSelector } from './selectors'
import { appoint } from 'app/patient/appointments/actions'
import DoctorList from './DoctorList'

function mapStateToProps(state) {
  return {
    doctorList: getDoctorsSelector(state),
    totalCount: getDoctorsTotalCountSelector(state),
  }
}

export default connect(mapStateToProps, { appoint })(DoctorList)
