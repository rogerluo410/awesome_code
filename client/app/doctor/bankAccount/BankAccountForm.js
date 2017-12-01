import React, { PropTypes } from 'react'
import { Modal } from 'react-bootstrap'
import { reduxForm, propTypes, Field } from 'redux-form'
import validate from './validate'

BankAccountForm.propTypes = {
  ...propTypes,
  visiable: PropTypes.bool.isRequired,
}

function BankAccountForm(props) {
  const { handleSubmit, submitting, onCancel, visiable } = props

  return (
    <form onSubmit={handleSubmit}>
      <Modal show={visiable} onHide={onCancel}>
        <Modal.Header closeButton>
          <Modal.Title><h4>New Bank Account</h4></Modal.Title>
        </Modal.Header>
        <Modal.Body className="u-greybg">
          <div className="doc-signup-item">
            <label>Number</label>
            <Field
              type="text"
              placeholder="Account Number"
              component={InputField}
              name="number"
            />
          </div>
          <div className="doc-signup-item">
            <label>Country</label>
            <Field
              name="favoriteColor"
              component="select"
              className="form-control u-select"
              name="country"
              disabled
            >
              <option value="Australia">Australia</option>
            </Field>
          </div>
          <div className="doc-signup-item ">
            <label>Currency</label>
            <Field
              name="favoriteColor"
              component="select"
              className="form-control u-select"
              name="currency"
              disabled
            >
              <option value="AUD">AUD</option>
            </Field>
          </div>
        </Modal.Body>
        <Modal.Footer>
          <a
            className="btn doc-btn is-green"
            disabled={submitting}
            onClick={handleSubmit}
          >
            Save
          </a>
        </Modal.Footer>
      </Modal>
    </form>

  )
}

function InputField(field) {
  return (
    <div className="input-row">
      <input type="text" className="form-control" {...field.input} />
      {field.touched && field.error && <code>{field.error}</code>}
    </div>
  )
}

export default reduxForm({ form: 'bankAccount', validate })(BankAccountForm)
