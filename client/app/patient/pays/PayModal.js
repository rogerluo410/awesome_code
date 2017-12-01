import React, { PropTypes } from 'react'
import { Modal } from 'react-bootstrap'
import PayForm from './PayForm'

PayModal.propTypes = {
  visiable: PropTypes.bool.isRequired,
  submitting: PropTypes.bool.isRequired,
  checkouts: PropTypes.array.isRequired,
  isFetching: PropTypes.bool.isRequired,
  save: PropTypes.func.isRequired,
  cancel: PropTypes.func.isRequired,
  showCheckoutModal: PropTypes.func.isRequired,
  appointment: PropTypes.object,
}

export default function PayModal(props) {
  const { visiable, cancel, appointment } = props

  if (!appointment) return null

  return (
    <Modal show={visiable} onHide={cancel}>
      <Modal.Header closeButton>
        <Modal.Title>Complete Payment</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {renderForm(props)}
      </Modal.Body>
      <Modal.Footer>
        <div className="u-imgText-sm">
          <div className="img">
            <img className="" src="/static/image/lock.png" alt="lock" />
          </div>
          <div className="dsc">
            trusted payment provide by stick
          </div>
        </div>
      </Modal.Footer>
    </Modal>
  )
}

function renderForm(props) {
  // eslint-disable-next-line react/prop-types
  const { isFetching, save, checkouts, appointment, showCheckoutModal, submitting } = props

  if (isFetching || !appointment) return <div>Loading...</div>

  return (
    <PayForm
      save={save}
      checkouts={checkouts}
      appointment={appointment}
      showCheckoutModal={showCheckoutModal}
      submitting={submitting}
    />
  )
}
