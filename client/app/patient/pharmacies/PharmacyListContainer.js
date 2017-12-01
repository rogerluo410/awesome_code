import { connect } from 'react-redux'
import { sendToPharmacy, fetchPharmacies } from './actions'
import { getPharmaciesSelector } from './selectors'
import PharmacyList from './PharmacyList'

function mapStateToProps(state) {
  return {
    ...getPharmaciesSelector(state),
  }
}

function mapDispatchToProps(dispatch) {
  return {
    fetchPharmacies: (params) => dispatch(fetchPharmacies(params)),
    sendToPharmacy: (data) => sendToPharmacy(data, dispatch),
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(PharmacyList)
