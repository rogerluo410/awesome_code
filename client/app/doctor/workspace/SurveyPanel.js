import React, { PropTypes } from 'react'

SurveyPanel.propTypes = {
  survey: PropTypes.object.isRequired,
}
export default function SurveyPanel({ survey }) {
  return (
    <div className="doc-schedule-body">
      <h3 className="name">
        {survey.fullName}
        <span>{survey.gender}</span>
      </h3>
      <p className="address">
        {withDefault(survey.streetAddress, 'Address not provided')}
      </p>

      <div className="summary u-clearFix row">
        <div className="col-lg-3 col-md-3 col-sm-3 col-xs-3 feature-item is-age">
          <div className="summary-header is-yellow">
            {withDefault(survey.age, '--')}
          </div>
          <div className="summary-dsc">
            Age
          </div>
        </div>
        <div className="col-lg-3 col-md-3 col-sm-3 col-xs-3 feature-item is-weight">
          <div className="summary-header is-blue">
            {withDefault(survey.weight, '--')}<span>kg</span>
          </div>
          <div className="summary-dsc">
            Weight
          </div>
        </div>
        <div className="col-lg-3 col-md-3 col-sm-3 col-xs-3 feature-item is-height">
          <div className="summary-header is-purple">
            {withDefault(survey.height, '--')}<span>cm</span>
          </div>
          <div className="summary-dsc">
            Height
          </div>
        </div>
        <div className="col-lg-3 col-md-3 col-sm-3 col-xs-3 feature-item is-athlete">
          <div className="summary-header summary-occupation is-green">
            {withDefault(survey.occupation, '--')}
          </div>
          <div className="summary-dsc">
            Occupation
          </div>
        </div>
        <div className="clearfix"></div>
      </div>

      <div className="other-info">
        <p>
          Any existing medical conditions
          <br />
          <span>{withDefault(survey.medicalCondition)}</span>
        </p>
        <p>
          Any existing medications
          <br />
          <span>{withDefault(survey.medications)}</span>
        </p>
        <p>
          Any Allergies
          <br />
          <span>{withDefault(survey.allergies)}</span>
        </p>
        <p>
          Reason for visit
          <br />
          <span>Need some help</span>
        </p>
      </div>
    </div>
  )
}

function withDefault(value, defaultValue = 'None') {
  return value || defaultValue
}
