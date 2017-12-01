import { connect } from 'react-redux'
import { getCheckoutsSelector } from './selectors'
import {
  fetchCheckouts,
  showNewCheckoutModal,
  destroyCheckout,
  setDefaultCheckout,
} from './actions'
import CheckoutList from './CheckoutList'

export default connect(
  getCheckoutsSelector,
  { fetchCheckouts, showNewCheckoutModal, destroyCheckout, setDefaultCheckout }
)(CheckoutList)
