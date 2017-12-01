import React, { Component, PropTypes } from 'react'
import RecentAppointmentItem from './RecentAppointmentItem'
import Loading from '../workspace/Loading'
import NoRecord from '../workspace/NoRecord'

export default class RecentAppointments extends Component {
  static propTypes = {
    isFetching: PropTypes.bool.isRequired,
    appointments: PropTypes.array.isRequired,
    errorMessage: PropTypes.string,
    fetchRecentAppointments: PropTypes.func.isRequired,
    showCommentsModal: PropTypes.func.isRequired,
    showPrescriptionsModal: PropTypes.func.isRequired,
  }

  componentWillMount() {
    this.props.fetchRecentAppointments()
  }

  renderBody() {
    const { isFetching, appointments, showCommentsModal, showPrescriptionsModal } = this.props
    if (isFetching) return <Loading />
    if (!appointments.length) return <NoRecord>No patient today</NoRecord>
    return (
      <table>
        <tbody>
          {appointments.map(app =>
            <RecentAppointmentItem
              key={app.id}
              appointment={app}
              showCommentsModal={showCommentsModal}
              showPrescriptionsModal={showPrescriptionsModal}
            />
          )}
        </tbody>
      </table>
    )
  }

  render() {
    return (
      <div className="doc-schedule">
        <div className="doc-schedule-header">
          <div className="title">Patient History</div>
        </div>
        <div className="doc-schedule-body">
          {this.renderBody()}
        </div>
      </div>
    )
  }
}
