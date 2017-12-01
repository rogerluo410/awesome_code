import React, { PropTypes, Component } from 'react'
import Loading from '../workspace/Loading'

export default class BankAccount extends Component {
  static propTypes = {
    isFetching: PropTypes.bool.isRequired,
    deleting: PropTypes.bool.isRequired,
    fetchBankAccount: PropTypes.func.isRequired,
    destroy: PropTypes.func.isRequired,
    bankAccount: PropTypes.object,
    showBankAccountForm: PropTypes.func.isRequired,
  }

  componentWillMount() {
    this.props.fetchBankAccount()
  }

  destroy = () => {
    this.props.destroy()
  }

  bankInfo() {
    const { bankAccount, showBankAccountForm, deleting } = this.props
    if (!bankAccount) return <NoBankAccountInfo showBankAccountForm={showBankAccountForm} />

    return (
      <div className="bankInfo">
        <span>{bankAccount.bankName}</span>
        <span>xxx xxxx xxxx xxxx {bankAccount.last4}</span>
        <span>{bankAccount.country}</span>
        <span>{bankAccount.currency}</span>
        <div
          className="btn btn-danger"
          onClick={this.destroy}
          disabled={deleting}
        >
          Deleted
        </div>
      </div>
    )
  }

  render() {
    const { isFetching } = this.props
    if (isFetching) return <Loading />

    return (
      <div className="row doc-docList u-clearFix">
        <div className="col-lg-8 col-md-8 col-sm-8 col-xs-8 col-md-offset-2">
          <div className="doc-setting-panel u-clearFix">
            <div className="account">
              <div className="account-bank">
                <div className="bankHeader">
                  Bank account
                </div>
                {this.bankInfo()}
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}

// eslint-disable-next-line react/prop-types
function NoBankAccountInfo({ showBankAccountForm }) {
  return (
    <div className="bankInfo">
      <span>There is no bank account, please add</span>
      <div
        className="btn btn-primary"
        onClick={showBankAccountForm}
      >
        Add
      </div>
    </div>
  )
}
