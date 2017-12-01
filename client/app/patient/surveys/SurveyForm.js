import React, { PropTypes } from 'react'
import { reduxForm, propTypes, Field } from 'redux-form'
import validate from './validate'
import InputField from 'app/shared/common/InputField'

SurveyForm.propTypes = {
  ...propTypes,
  onCancel: PropTypes.func.isRequired,
}

function SurveyForm(props) {
  const { handleSubmit, submitting, onCancel, reasons } = props

  return (
    <form onSubmit={handleSubmit}>
      <div className="doc-setting-panel u-clearFix">
        <div className="doc-setting-panel-form is-patient">
          <div className="row">
            <div className="col-lg-3 col-md-3 col-sm-12 col-xs-12 ">
              <div className="row">
                <div className="u-formGroup">
                  <div className="title">
                    Full Name<code>*</code>
                  </div>
                  <div className="body">
                    <Field
                      name="full_name"
                      component={InputField}
                      type="text"
                      placeholder="Messi"
                    />
                  </div>
                </div>
              </div>
            </div>
            <div className="col-lg-3 col-md-3 col-sm-12 col-xs-12 ">
              <div className="row">
                <div className="u-formGroup">
                  <div className="title">
                    Suburb<code>*</code>
                  </div>
                  <div className="body">
                    <Field
                      type="text"
                      placeholder="Sydeney"
                      component={InputField}
                      name="suburb"
                    />
                  </div>
                </div>
              </div>
            </div>
            <div className="col-lg-6 col-md-6 col-sm-12 col-xs-12 ">
              <div className="row">
                <div className="u-formGroup">
                  <div className="title">
                    Address<code>*</code>
                  </div>
                  <div className="body">
                    <Field
                      type="text"
                      component={InputField}
                      name="street_address"
                      placeholder="xxxx"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-lg-3 col-md-3 col-sm-6 col-xs-6 ">
              <div className="row">
                <div className="u-formGroup">
                  <div className="title">
                    HEIGHT
                  </div>
                  <div className="body u-inputWithText">
                    <Field
                      type="number"
                      component="input"
                      name="height"
                      placeholder="180"
                      className="form-control u-input"
                    />
                    <span>CM</span>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-lg-3 col-md-3 col-sm-6 col-xs-6 ">
              <div className="row">
                <div className="u-formGroup">
                  <div className="title">
                    WEIGHT
                  </div>
                  <div className="body u-inputWithText">
                    <Field
                      type="number"
                      name="weight"
                      component="input"
                      className="form-control u-input"
                      placeholder="70"
                    />
                    <span>KG</span>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-lg-3 col-md-3 col-sm-12 col-xs-12">
              <div className="row">
                <div className="u-formGroup">
                  <div className="title">
                    GENDER
                  </div>
                  <div className="body">
                    <div className="u-btnGroup is-hasTwo" data-toggle="buttons">
                      <label>
                        <Field
                          name="gender"
                          component="input"
                          type="radio"
                          value="male"
                        />
                        Male
                      </label>
                      <label>
                        <Field
                          name="gender"
                          component="input"
                          type="radio"
                          value="female"
                        />
                        Female
                      </label>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-lg-3 col-md-3 col-sm-12 col-xs-12 ">
              <div className="row">
                <div className="u-formGroup">
                  <div className="title">
                    AGE
                  </div>
                  <div className="body">
                    <Field
                      component="input"
                      type="number"
                      name="age"
                      placeholder="18"
                      className="form-control u-input"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="u-clearFix"></div>
          <div className="row">
            <div className="col-lg-6 col-md-6 col-sm-6 col-xs-6 ">
              <div className="row">
                <div className="u-formGroup">
                  <div className="title">
                    Any existing medical conditions
                  </div>
                  <div className="body">
                    <Field
                      className="form-control u-input"
                      component="textarea"
                      name="medical_condition"
                      placeholder="Medications conditions"
                    />
                  </div>
                </div>
              </div>
            </div>

            <div className="col-lg-6 col-md-6 col-sm-6 col-xs-6 ">
              <div className="row">
                <div className="u-formGroup">
                  <div className="title">
                    Any existing medications
                  </div>
                  <div className="body">
                    <Field
                      className="form-control u-input"
                      component="textarea"
                      name="medications"
                      placeholder="Medications"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-lg-12 col-md-12 col-sm-12 col-xs-12 ">
              <div className="row">
                <div className="u-formGroup">
                  <div className="title">
                    Any Allergies
                  </div>
                  <div className="body">
                    <Field
                      className="form-control u-input"
                      component="textarea"
                      name="allergies"
                      placeholder="Allergies"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-lg-12 col-md-12 col-sm-12 col-xs-12 ">
              <div className="row">
                <div className="u-formGroup">
                  <div className="title">
                    Reason for visit
                  </div>
                  <div className="body">
                    <Field
                      name="favoriteColor"
                      component="select"
                      className="form-control u-select"
                      name="reason_id"
                    >
                      {reasons.map(reason =>
                        <option key={reason.id} value={reason.id}>{reason.text}</option>
                      )}
                    </Field>
                  </div>
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
                PAYMENT & START
              </button>
              <a
                className="btn m-btn is-green is-right"
                disabled={submitting}
                onClick={onCancel}
              >
                SKIP
              </a>
            </div>
          </div>
        </div>
      </div>
    </form>
  )
}

export default reduxForm({ form: 'survey', validate })(SurveyForm)
