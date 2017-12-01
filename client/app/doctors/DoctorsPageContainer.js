import { connect } from 'react-redux'
import { fetchDoctors } from './actions'
import DoctorsPage from './DoctorsPage'
import { getCurrentTimeZone } from 'app/timeZone/selectors'

function mapStateToProps(state) {
  return {
    tz: getCurrentTimeZone(state),
    isSignedIn: state.auth.isSignedIn,
   }
}

export default connect(mapStateToProps, { fetchDoctors })(DoctorsPage)
