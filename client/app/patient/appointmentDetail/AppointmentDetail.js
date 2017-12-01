import React, { Component, PropTypes } from 'react'
import Link from 'react-router/lib/Link'
import Time from 'app/timeZone/Time'
import { Glyphicon } from 'react-bootstrap'
import Loading from 'app/doctor/workspace/Loading'
import CommentForm from 'app/comments/CommentForm'
import CommentItem from 'app/comments/CommentItem'

export default class AppointmentDetail extends Component {
  static propTypes = {
    isFetching: PropTypes.bool.isRequired,
    appointment: PropTypes.object,
    errorMessage: PropTypes.string,
    fetchAppointmentDetail: PropTypes.func.isRequired,
    params: PropTypes.object.isRequired,
    comments: PropTypes.array.isRequired,
    prescriptions: PropTypes.array.isRequired,
    medicalCertificate: PropTypes.object,
    currentUserId: PropTypes.number.isRequired,
    save: PropTypes.func.isRequired,
  }

  componentWillMount() {
    const { fetchAppointmentDetail, params } = this.props
    fetchAppointmentDetail(params.appointmentId)
  }

  renderAppointmentInfo() {
    const { appointment } = this.props

    if (!appointment) return null

    return (
      <div>
        <div className="col-md-4">
          <div className="doc-card-imgBox u-cricleImg is-dashboard">
            <img alt="Doctor Avatar" src={appointment.doctorAvatarUrl} />
          </div>
          <div className="u-info">
            <div className="fullName">{appointment.doctorName}</div>
            <div className="appellation u-textPadding">
              {appointment.doctorSpecialtyName}
            </div>
          </div>
        </div>

        <div className="doc-card-freeNow col-md-4">
          <div className=" col-xs-1"></div>
          <div className=" col-xs-10">
            {this.renderPrescriptionStatus()}
          </div>
        </div>

        <div className="dashboard-time col-md-4">
          <div className="timer">
            <Time value={appointment.conferenceEndTime || ''} format="Y-M-D HH:mm" />
          </div>
        </div>
        <div className="u-clearFix"></div>
        <div className="dashboard-links">
          <Link
            className="u-link is-white"
            to={`/doctors/${appointment.doctorId}`}
          >
            View Doctor
          </Link>
          <Link
            className="u-link is-white"
            to="/p/dashboard"
          >
            Back to list
          </Link>
        </div>
      </div>
    )
  }

  renderPrescriptionStatus() {
    const { appointment } = this.props

    if (appointment.prescriptionsStatus === 'delivered') {
      return <Deliverd prescriptionsPharmacyName={appointment.prescriptionsPharmacyName} />
    }
    if (appointment.prescriptionsStatus === 'pending') {
      return <FindPharamcy appointmentId={appointment.id} />
    }
    return <div>No perscription upload yet</div>
  }

  renderCommentsInfo() {
    const { comments, currentUserId } = this.props
    if (!comments) return null

    return (
      <div>
        {comments.map(comment =>
          <CommentItem
            key={comment.id}
            comment={comment}
            currentUserId={currentUserId}
          />
        )}
        <div className="clearfix"></div>
      </div>
    )
  }

  renderPrescriptionsInfo() {
    const { prescriptions } = this.props
    if (!prescriptions) return null

    return (
      <div className="u-presbody">
        {prescriptions.map(prescription =>
          <div key={prescription.id} className="u-filescontent is-recordfiles">
            <a className="is-paperclip" href="#">
              <Glyphicon glyph="paperclip" />
            </a>
            <a className="is-filename" target="blank" href={prescription.fileUrl}>
              {prescription.fileIdentifier}
            </a>
          </div>
        )}
      </div>
    )
  }

  renderMedCertificate() {
    const { medicalCertificate } = this.props
    if (!medicalCertificate) return null

    return (
      <div className="u-presbody">
        <div className="u-filescontent is-recordfiles">
          <a className="is-paperclip" href="#">
            <Glyphicon glyph="paperclip" />
          </a>
          <a className="is-filename" href={medicalCertificate.fileUrl}>
            {medicalCertificate.fileIdentifier}
          </a>
        </div>
      </div>
    )
  }

  renderRelationbody() {
    const { appointment, save, params } = this.props
    const initialValues = {
      body: '',
      appointmentId: params.appointmentId,
    }

    if (!appointment) return null
    if (appointment.status !== 'finished') return null

    return (
      <div className="u-container tableBox">
        <div className="row u-patientRecord">
          <div className="col-md-6 col-sm-6 col-xs-12 u-recordcomments">
            <h4 className="u-commentstitle">Comments</h4>
            {this.renderCommentsInfo()}

            <div className="u-commentsbody">
              <CommentForm
                onSubmit={save}
                initialValues={initialValues}
              />
            </div>
          </div>
          <div className="col-md-offset-3 col-md-3 col-sm-3 col-xs-12 u-recordpres">
            <h4 className="u-prestitle">Prescriptions</h4>
            {this.renderPrescriptionsInfo()}
            <h4 className="u-prestitle is-second">medical certificates</h4>
            {this.renderMedCertificate()}
          </div>
          <div className="clearfix"></div>
        </div>
      </div>
    )
  }

  render() {
    const { isFetching } = this.props
    if (isFetching) return <Loading />

    return (
      <div>
        <div className="doc-detail-masthead">
          <div className="doc-card doc-card--masthead dashboard">
            <div className="u-container u-clearFix">
              <div className="dashboard-title">
                Record
              </div>
              {this.renderAppointmentInfo()}
            </div>
          </div>
        </div>
        {this.renderRelationbody()}
      </div>
    )
  }
}

Deliverd.propTypes = {
  prescriptionsPharmacyName: PropTypes.string.isRequired,
}

function Deliverd({ prescriptionsPharmacyName }) {
  return (
    <div>
      <div>
        <Glyphicon glyph="ok" />
      </div>
      perscription has send to <a>{prescriptionsPharmacyName}</a>
    </div>
  )
}

FindPharamcy.propTypes = {
  appointmentId: PropTypes.string.isRequired,
}

function FindPharamcy({ appointmentId }) {
  return (
    <Link to={`/p/appointments/${appointmentId}/pharmacies`}>
      <div className="doc-btn btn doc-btn--patientblue">
        <span className="icon icon-seeDoc"></span>
        Find pharmacy
      </div>
    </Link>
  )
}
