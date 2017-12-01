import { connect } from 'react-redux'
import { fetchBankAccount, showBankAccountForm, destroy } from './actions'
import { getBankAccountSelector } from './selectors'
import BankAccount from './BankAccount'

function mapStateToProps(state) {
  return {
    ...getBankAccountSelector(state),
  }
}

function mapDispatchToProps(dispatch) {
  return {
    fetchBankAccount: (appointmentId) =>
      dispatch(fetchBankAccount(appointmentId)),
    destroy: () => dispatch(destroy()),
    showBankAccountForm: () => dispatch(showBankAccountForm()),
  }
}

export default connect(mapStateToProps,
  mapDispatchToProps
)(BankAccount)
