import React from 'react'
import { reduxForm, propTypes, Field } from 'redux-form'
import validate from './validate'

CommentForm.propTypes = {
  ...propTypes,
}

function CommentForm(props) {
  const { handleSubmit, submitting } = props

  return (
    <form onSubmit={handleSubmit}>
      <div className="u-commentsbody is-owner">
        <div className="form-group">
          <div className="title">
            Notes<code>*</code>
          </div>
          <div className="body">
            <Field
              placeholder="Note some thing here"
              component={TextArea}
              name="body"
            />
          </div>
          <a
            className="doc-btn is-blueline"
            disabled={submitting}
            onClick={handleSubmit}
          >
            Save
          </a>
        </div>
      </div>
    </form>
  )
}

function TextArea(field) {
  return (
    <div>
      <textarea type="textarea" cols="30" rows="5" {...field.input} />
      {field.touched && field.error && <code>{field.error}</code>}
    </div>
  )
}

export default reduxForm({ form: 'comment', validate })(CommentForm)
