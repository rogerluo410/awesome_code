import React from 'react'
import { reduxForm, propTypes, Field } from 'redux-form'
import InputField from 'app/shared/common/InputField'
import { monthList, yearList } from 'app/utils/common'
import validate from './validate'

CheckoutForm.propTypes = {
  ...propTypes,
}

function CheckoutForm(props) {
  const { handleSubmit, submitting } = props

  return (
    <form onSubmit={handleSubmit}>
      <div className="doc-setting-panel u-clearFix">
        <div className="doc-setting-panel-form is-patient">
          <div className="col-lg-12 col-md-12 col-sm-12 col-xs-12 ">
            <div className="row">
              <div className="u-formGroup">
                <div className="title">
                  Number<code>*</code>
                </div>
                <div className="body">
                  <Field
                    type="text"
                    component={InputField}
                    name="number"
                  />
                </div>
              </div>
            </div>
          </div>

          <div className="col-lg-12 col-md-12 col-sm-12 col-xs-12 ">
            <div className="row">
              <div className="u-formGroup">
                <div className="title">
                  Exp month<code>*</code>
                </div>
                <div className="body">
                  <Field
                    name="favoriteColor"
                    component="select"
                    className="form-control u-input"
                    name="expMonth"
                  >
                    {monthList.map(i =>
                      <option key={i} value={i}>{i}</option>
                    )}
                  </Field>
                </div>
              </div>
            </div>
          </div>

          <div className="col-lg-12 col-md-12 col-sm-12 col-xs-12 ">
            <div className="row">
              <div className="u-formGroup">
                <div className="title">
                  Exp year<code>*</code>
                </div>
                <div className="body">
                  <Field
                    name="favoriteColor"
                    component="select"
                    className="form-control u-input"
                    name="expYear"
                  >
                    {yearList.map(i =>
                      <option key={i} value={i}>{i}</option>
                    )}
                  </Field>
                </div>
              </div>
            </div>
          </div>

          <div className="col-lg-12 col-md-12 col-sm-12 col-xs-12 ">
            <div className="row">
              <div className="u-formGroup">
                <div className="title">
                  CVC<code>*</code>
                </div>
                <div className="body">
                  <Field
                    type="text"
                    component={InputField}
                    name="cvc"
                  />
                </div>
              </div>
            </div>
          </div>

          <div className="u-clearFix"></div>
          <div className="col-lg-12 col-md-12 col-sm-12 col-xs-12 ">
            <div className="row">
              <button
                className="btn m-btn is-green is-right"
                disabled={submitting}
              >
                Save
              </button>
            </div>
          </div>
        </div>
      </div>
    </form>
  )
}

export default reduxForm({ form: 'checkout', validate })(CheckoutForm)
