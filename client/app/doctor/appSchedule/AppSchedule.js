import React, { Component, PropTypes } from 'react'
import Time from 'app/timeZone/Time'
import Loading from '../workspace/Loading'
import NoRecord from '../workspace/NoRecord'

export default class AppSchedule extends Component {
  static propTypes = {
    isFetching: PropTypes.bool.isRequired,
    appointmentProducts: PropTypes.array,
    fetchSchedule: PropTypes.func.isRequired,
    showAppReviewModal: PropTypes.func.isRequired,
  }

  componentWillMount() {
    this.props.fetchSchedule()
  }

  renderBody() {
    const { isFetching, appointmentProducts, showAppReviewModal } = this.props
    if (isFetching) return <Loading />
    if (!appointmentProducts.length) return <NoRecord>No appointment yet</NoRecord>
    return (
      <AppScheduleTable
        appointmentProducts={appointmentProducts}
        showAppReviewModal={showAppReviewModal}
      />
    )
  }

  render() {
    return (
      <div className="doc-schedule">
        <div className="doc-schedule-header">
          <div className="title">Appointment</div>
          <div className="dsc">Click blue item to approve or decline</div>
        </div>
        <div className="doc-schedule-body">
          {this.renderBody()}
        </div>
      </div>
    )
  }
}

AppScheduleTable.propTypes = {
  appointmentProducts: PropTypes.array.isRequired,
  showAppReviewModal: PropTypes.func.isRequired,
}
function AppScheduleTable({ appointmentProducts, showAppReviewModal }) {
  return (
    <div className="appointment">
      {appointmentProducts.map(ap =>
        <AppScheduleRow
          key={ap.id}
          appointmentProduct={ap}
          showAppReviewModal={showAppReviewModal}
        />
      )}
    </div>
  )
}

AppScheduleRow.propTypes = {
  appointmentProduct: PropTypes.object.isRequired,
  showAppReviewModal: PropTypes.func.isRequired,
}
function AppScheduleRow({ appointmentProduct, showAppReviewModal }) {
  return (
    <div className="appointment-item">
      <div className="time">
        <Time value={appointmentProduct.startTime} format="HH:mm" />
      </div>
      <div className="content u-clearFix">
        {appointmentProduct.scheduledAppointments.map(a =>
          <AppScheduleTile key={a.id} appointment={a} onClick={showAppReviewModal} />
        )}
      </div>
    </div>
  )
}

// eslint-disable-next-line react/no-multi-comp
class AppScheduleTile extends Component {
  static propTypes = {
    appointment: PropTypes.object.isRequired,
    onClick: PropTypes.func.isRequired,
  }

  handleClick = () => {
    const { appointment, onClick } = this.props
    onClick(appointment.id)
  }

  render() {
    const { appointment } = this.props
    const className = `btn m-btn ${appointment.status === 'pending' ? 'is-yellowLight' : 'is-blue'}`

    return (
      <div
        className={className}
        onClick={this.handleClick}
      >
        {appointment.patientShortName}
      </div>
    )
  }
}
