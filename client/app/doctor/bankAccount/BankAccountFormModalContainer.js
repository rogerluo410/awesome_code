import { connect } from 'react-redux'
import { saveBankAccount, closeBankAccountForm } from './actions'
import BankAccountFormModal from './BankAccountFormModal'

function mapStateToProps(state) {
  return {
    visiable: state.doctor.bankAccount.visiable,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    save: (data) => saveBankAccount(dispatch, data),
    cancel: () => dispatch(closeBankAccountForm()),
  }
}

export default connect(mapStateToProps,
  mapDispatchToProps
)(BankAccountFormModal)
