import React, { PropTypes } from 'react'
import { Modal } from 'react-bootstrap'
import SurveyForm from './SurveyForm'

SurveyModal.propTypes = {
  visiable: PropTypes.bool.isRequired,
  isFetching: PropTypes.bool.isRequired,
  survey: PropTypes.object.isRequired,
  reasons: PropTypes.array.isRequired,
  save: PropTypes.func.isRequired,
  cancel: PropTypes.func.isRequired,
}

export default function SurveyModal(props) {
  const { visiable, cancel } = props

  return (
    <Modal dialogClassName="modal-lg" show={visiable} onHide={cancel}>
      <Modal.Header closeButton>
        <Modal.Title>Fill out your survey detail first</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        {renderForm(props)}
      </Modal.Body>
    </Modal>
  )
}

function renderForm(props) {
  // eslint-disable-next-line react/prop-types
  const { isFetching, survey, reasons, save, cancel } = props

  if (isFetching) return <div>Loading...</div>
  return (
    <SurveyForm
      initialValues={survey}
      reasons={reasons}
      onSubmit={save}
      onCancel={cancel}
    />
  )
}
