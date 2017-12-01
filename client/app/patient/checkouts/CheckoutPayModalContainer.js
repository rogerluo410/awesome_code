import { connect } from 'react-redux'
import { saveCheckout, closeToPayModal } from './actions'
import CheckoutModal from './CheckoutModal'

function mapStateToProps(state) {
  return {
    visiable: state.patient.checkouts.visiablePay,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    save: (data) => saveCheckout(data, dispatch, 'toPay'),
    cancel: () => dispatch(closeToPayModal()),
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(CheckoutModal)
