import React, { PropTypes } from 'react'
import BankAccountForm from './BankAccountForm'

bankAccountFormModal.propTypes = {
  visiable: PropTypes.bool.isRequired,
  cancel: PropTypes.func.isRequired,
  save: PropTypes.func.isRequired,
}

export default function bankAccountFormModal(props) {
  const { visiable, cancel, save } = props
  const initialValues = {
    number: '',
    country: 'Australia',
    currency: 'AUD',
  }

  return (
    <BankAccountForm
      onSubmit={save}
      onCancel={cancel}
      visiable={visiable}
      initialValues={initialValues}
    />
  )
}
