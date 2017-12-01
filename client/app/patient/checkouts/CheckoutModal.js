import React, { PropTypes } from 'react'
import { Modal } from 'react-bootstrap'
import CheckoutForm from './CheckoutForm'

CheckoutModal.propTypes = {
  visiable: PropTypes.bool.isRequired,
  save: PropTypes.func.isRequired,
  cancel: PropTypes.func.isRequired,
}

export default function CheckoutModal(props) {
  const { visiable, cancel } = props

  return (
    <Modal show={visiable} onHide={cancel}>
      <Modal.Header closeButton>
        <Modal.Title>New Checkout</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {renderForm(props)}
      </Modal.Body>
    </Modal>
  )
}

function renderForm(props) {
  // eslint-disable-next-line react/prop-types
  const { save, cancel } = props

  const initialValues = {
    expMonth: 1,
    expYear: (new Date).getFullYear(),
  }

  return (
    <CheckoutForm
      onSubmit={save}
      onCancel={cancel}
      initialValues={initialValues}
    />
  )
}
