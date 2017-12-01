import React, { Component, PropTypes } from 'react'
import Link from 'react-router/lib/Link'
import Loading from '../workspace/Loading'
import NoRecord from '../workspace/NoRecord'
import SurveyPanel from '../workspace/SurveyPanel'

export default class UpcomingAppointment extends Component {
  static propTypes = {
    isFetching: PropTypes.bool.isRequired,
    appointment: PropTypes.object,
    survey: PropTypes.object,
    fetchUpcomingAppointment: PropTypes.func.isRequired,
  }

  componentWillMount() {
    this.props.fetchUpcomingAppointment()
  }

  renderBody() {
    const { isFetching, survey, appointment } = this.props
    if (isFetching) return <Loading />
    if (!survey) return <NoRecord>Take a coffee, get some rest.</NoRecord>
    return <UpcomingAppointmentBody survey={survey} appointmentId={appointment.id} />
  }

  render() {
    return (
      <div className="doc-schedule">
        <div className="doc-schedule-header">
          <div className="title">Upcomming Appointment</div>
        </div>
        <div className="doc-schedule-body">
          {this.renderBody()}
        </div>
      </div>
    )
  }
}

UpcomingAppointmentBody.propTypes = {
  survey: PropTypes.object.isRequired,
  appointmentId: PropTypes.string.isRequired,
}

function UpcomingAppointmentBody({ survey, appointmentId }) {
  return (
    <div>
      <SurveyPanel survey={survey} />
      <div className="row dashboard-links">
        <div className="col-lg-7 col-md-7 col-sm-12 col-xs-12 col-md-offset-2 col-lg-offset-2">
          <Link
            to={`/d/conference/${appointmentId}`}
            className="btn m-btn is-greenLight"
          >
            Commence Consultation
          </Link>
        </div>

      </div>
    </div>
  )
}
