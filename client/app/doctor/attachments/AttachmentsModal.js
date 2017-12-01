import React, { PropTypes } from 'react'
import { Modal } from 'react-bootstrap'
import PrescriptionListContainer from '../prescriptions/PrescriptionListContainer'
import MedicalCertificateContainer from '../medicalCertificate/MedicalCertificateContainer'

AttachmentsModal.propTypes = {
  visiable: PropTypes.bool.isRequired,
  cancel: PropTypes.func.isRequired,

}

export default function AttachmentsModal(props) {
  const { visiable, cancel } = props

  return (
    <Modal show={visiable} onHide={cancel}>
      <Modal.Header closeButton>
        <Modal.Title>Prescriptions & Medical Certificates</Modal.Title>
      </Modal.Header>
      <Modal.Body className="modal-body u-greybg is-uploadbg">
        <div className="content">
          <PrescriptionListContainer />
          <MedicalCertificateContainer />
        </div>
      </Modal.Body>
      <Modal.Footer className="modal-footer u-upload-done">
      </Modal.Footer>
    </Modal>
  )
}
