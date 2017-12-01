import React, { PropTypes } from 'react'

InputField.PropTypes = {
  field: PropTypes.object.isRequired,
}

export default function InputField(field) {
  return (
    <div className="input-row">
      <input type="text" className="form-control u-input" {...field.input} />
      {field.touched && field.error && <code>{field.error}</code>}
    </div>
  )
}

export function TextArea(field) {
  return (
    <div className="form-group">
      <textarea type="textarea" cols="30" rows="5" {...field.input} />
      {field.touched && field.error && <code>{field.error}</code>}
    </div>
  )
}
