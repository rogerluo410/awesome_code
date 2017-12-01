import React, { Component, PropTypes } from 'react'
import { Glyphicon } from 'react-bootstrap'
import TimeAgo from 'react-timeago'

export default class FinishedAppointmentItem extends Component {
  static propTypes = {
    appointment: PropTypes.shape({
      id: PropTypes.string.isRequired,
      patientFullName: PropTypes.string.isRequired,
      conferenceEndTime: PropTypes.string,
    }).isRequired,
    showCommentsModal: PropTypes.func.isRequired,
    showPrescriptionsModal: PropTypes.func.isRequired,
  }

  showComments = () => {
    this.props.showCommentsModal(this.props.appointment.id)
  }

  showPrescriptions = () => {
    this.props.showPrescriptionsModal(this.props.appointment.id)
  }

  render() {
    const { appointment } = this.props
    return (
      <tr key={appointment.id}>
        <td>{appointment.patientFullName}</td>
        <td><TimeAgo date={appointment.conferenceEndTime} /></td>
        {appointment.status === 'finished' &&
          <td onClick={this.showComments}>
            <span><Glyphicon glyph="bullhorn" /></span>
          </td>
        }
        {appointment.status === 'finished' &&
          <td onClick={this.showPrescriptions}>
            <a className="u-link">Prescriptions</a>
          </td>
        }
      </tr>
    )
  }
}
