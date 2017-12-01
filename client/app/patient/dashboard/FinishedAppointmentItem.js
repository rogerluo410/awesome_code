import React, { Component, PropTypes } from 'react'
import { Glyphicon } from 'react-bootstrap'
import { pascalize } from 'humps'
import Link from 'react-router/lib/Link'
import TimePeriod from 'app/timeZone/TimePeriod'
import Time from 'app/timeZone/Time'

export default class FinishedAppointmentItem extends Component {
  static propTypes = {
    appointment: PropTypes.shape({
      id: PropTypes.number.isRequired,
      doctorId: PropTypes.number.isRequired,
      doctorName: PropTypes.string.isRequired,
      doctorEmail: PropTypes.string.isRequired,
      periodStartTime: PropTypes.string.isRequired,
      periodEndTime: PropTypes.string.isRequired,
      status: PropTypes.string.isRequired,
      consultationFee: PropTypes.string.isRequired,
    }).isRequired,
    showCommentsModal: PropTypes.func.isRequired,
  }

  showComments = () => {
    this.props.showCommentsModal(this.props.appointment.id)
  }

  render() {
    const { appointment } = this.props
    return (
      <tr>
        <td>{appointment.doctorName}</td>
        <td><Time value={appointment.periodStartTime} format="YYYY-MM-DD" /></td>
        <td>
          <TimePeriod startTime={appointment.periodStartTime} endTime={appointment.periodEndTime} />
        </td>
        <td>{pascalize(appointment.status)}</td>
        <td><Link to={`/doctors/${appointment.doctorId}`}>View Doctor</Link></td>
        <td>${appointment.consultationFee}</td>
        {appointment.status === 'finished'
          ? <td onClick={this.showComments}><span><Glyphicon glyph="bullhorn" /></span></td>
          : <td />
        }
        <td><Link to={`/p/appointments/${appointment.id}`}>Detail</Link></td>
      </tr>
    )
  }
}
