import React, { Component, PropTypes } from 'react'
import includes from 'lodash/includes'
import cable from 'app/cable'

export default class ActiveAppointment extends Component {
  static propTypes = {
    isFetching: PropTypes.bool.isRequired,
    appointment: PropTypes.shape({
      doctorName: PropTypes.string.isRequired,
      doctorSpecialtyName: PropTypes.string.isRequired,
      doctorAvatarUrl: PropTypes.string.isRequired,
      estimateConsultTime: PropTypes.string.isRequired,
      status: PropTypes.string.isRequired,
      paid: PropTypes.bool.isRequired,
    }),
    fetchActiveAppointment: PropTypes.func.isRequired,
    showSurveyModal: PropTypes.func.isRequired,
    showPayModal: PropTypes.func.isRequired,
    receiveAppointment: PropTypes.func.isRequired,
  }

  componentWillMount() {
    this.props.fetchActiveAppointment()
  }

  componentDidMount() {
    this.createSubscription()
  }

  componentWillUnmount() {
    this.removeSubscription()
  }

  createSubscription() {
    const { receiveAppointment } = this.props

    this.subscription = cable.subscriptions.create('PatientAppointmentChannel', {
      received(json) {
        receiveAppointment(json)
      },
    })
  }

  removeSubscription() {
    this.subscription.unsubscribe()
    delete this.subscription
  }

  editSurvey = () => {
    const { appointment } = this.props
    this.props.showSurveyModal(appointment.surveyId)
  }

  payAppointment = () => {
    this.props.showPayModal()
  }

  renderAppointment() {
    const { appointment } = this.props

    if (!appointment) {
      return (
        <div>{"You don't have upcoming appointment"}</div>
      )
    }

    return (
      <ul>
        <li>Doctor Name: {appointment.doctorName}</li>
        <li>Doctor Specialty: {appointment.doctorSpecialtyName}</li>
        <li>Estimate consult time: {appointment.estimateConsultTime}</li>
        <li>Status</li>
        <li>Operations</li>
      </ul>
    )
  }

  renderTitle() {
    let title
    if (this.props.isFetching) {
      title = 'Loading...'
    } else if (this.props.appointment) {
      title = 'Appointment Status'
    } else {
      title = "You don't have upcoming appointment"
    }
    return <div className="dashboard-title">{title}</div>
  }

  renderAppointmentInfo() {
    const { isFetching, appointment } = this.props

    if (isFetching || !appointment) return null

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

        {this.renderStatusInfo()}

        <div className="dashboard-time col-md-4">
          <div className="header">
            Estimate Consult Time
          </div>
          <div className="timer">
            {appointment.estimateConsultTime}
          </div>
        </div>
      </div>
    )
  }

  renderStatusInfo() {
    const { appointment } = this.props
    let text
    let hint

    switch (appointment.status) {
      case 'pending':
        if (!appointment.paid) {
          text = 'Need Payment'
          hint = 'Need payment before your consultation.'
        } else {
          text = 'Awaiting Approval'
          hint = "Your payment has been confirmed. Please wait for your doctor's confirmation."
        }
        break
      case 'accepted':
        text = 'Ready to Call'
        hint = 'Doctor approved and will call you on time.'
        break
      case 'processing':
        text = 'Consulting'
        hint = 'The consultation is in progress.'
        break
      default:
        text = appointment.status
        hint = ''
    }

    return (
      <div className="doc-card-freeNow col-md-4">
        <div className="col-xs-1"></div>
        <div className="col-xs-10">
          {
            appointment.paid
              ? <div className="status-msg">{text}</div>
              : <PayButton onClick={this.payAppointment} />
          }
          <div className="dsc">{hint}</div>
        </div>
      </div>
    )
  }

  renderLinks() {
    const { isFetching, appointment } = this.props

    if (isFetching || !appointment) return null

    const canEditSurvey = includes(['pending', 'accepted', 'processing'], appointment.status)

    return (
      <div className="dashboard-links">
        {canEditSurvey &&
          <a className="u-link is-white" onClick={this.editSurvey}>
            Edit Patient Information
          </a>
        }
      </div>
    )
  }

  render() {
    return (
      <div className="doc-detail-masthead">
        <div className="doc-card doc-card--masthead dashboard">
          <div className="u-container u-clearFix">
            {this.renderTitle()}
            {this.renderAppointmentInfo()}
            <div className="u-clearFix"></div>
            {this.renderLinks()}
          </div>
        </div>
      </div>
    )
  }
}

PayButton.propTypes = {
  onClick: PropTypes.func.isRequired,
}
function PayButton({ onClick }) {
  return (
    <div className="row">
      <div className="doc-btn btn doc-btn--green" onClick={onClick}>
        <i className="fa fa-usd"></i>
        Pay
      </div>
    </div>
  )
}
