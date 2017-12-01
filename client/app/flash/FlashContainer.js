import { connect } from 'react-redux'
import Flash from './Flash'

function mapStateToProps(state) {
  return { flash: state.flash }
}

export default connect(mapStateToProps)(Flash)
