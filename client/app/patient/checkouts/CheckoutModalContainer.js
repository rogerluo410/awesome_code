import { connect } from 'react-redux'
import { saveCheckout, closeModal } from './actions'
import CheckoutModal from './CheckoutModal'

function mapStateToProps(state) {
  return {
    visiable: state.patient.checkouts.visiable,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    save: (data) => saveCheckout(data, dispatch),
    cancel: () => dispatch(closeModal()),
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(CheckoutModal)
