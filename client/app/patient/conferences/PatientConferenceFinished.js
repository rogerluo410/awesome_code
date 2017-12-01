import React, { Component, PropTypes } from 'react'

export default class PatientConferenceFinished extends Component {
  static propTypes = {
    submitting: PropTypes.bool.isRequired,
    user: PropTypes.shape({
      avatar_url: PropTypes.string.isRequired,
      name: PropTypes.string.isRequired,
      specialty_name: PropTypes.string.isRequired,
    }),
    appointmentID: PropTypes.string.isRequired,
    durationTime: PropTypes.string.isRequired,
    finishConference: PropTypes.func.isRequired,
    refundConference: PropTypes.func.isRequired,
  }

  finishAction = () => {
    this.props.finishConference(this.props.appointmentID)
  }

  refundAction = () => {
    this.props.refundConference(this.props.appointmentID)
  }

  render() {
    const { user, durationTime, submitting } = this.props
    return (
      <div className="doc-docList u-clearFix">
        <div className="u-container">
          <div className="doc-popup">
            <div className="doc-popup-head">
              <div className="head-content">
                <div className="doctor-img">
                  <img className="img-responsive" src={user.avatar_url} alt="" />
                </div>
                <div className="doctor-name">
                  <h5>Dr.{user.name}</h5>
                  <em>Exercise {user.specialty_name}</em>
                </div>
                <div className="clearfix"></div>
              </div>
            </div>
            <div className="doc-popup-body">
              <p className="u-firstpage">
                {"Your appointment was completed in "}
                <span>{durationTime}</span>
                . Please confirm the completion of your consultation.
              </p>
              <div className="u-finish">
                <button
                  className="doc-btn btn btn-block is-green"
                  disabled={submitting}
                  onClick={this.finishAction}
                >
                  Finish
                </button>
              </div>
              <p className="u-thirdpage">
                {"If for any reason the consultation was unsatisfactory, please contact us or "}
                <a onClick={this.refundAction} disabled={submitting}>request a refund</a>.
              </p>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
