import { connect } from 'react-redux'
import { fetchDoctor } from './actions'
import Doctor from './Doctor'
import { getDoctor } from './selectors'

function mapStateToProps(state) {
  return {
    ...getDoctor(state),
  }
}

export default connect(mapStateToProps, { fetchDoctor })(Doctor)
