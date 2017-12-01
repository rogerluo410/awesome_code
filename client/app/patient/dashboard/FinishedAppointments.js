import React, { Component, PropTypes } from 'react'

import FinishedAppointmentsPaginator from './FinishedAppointmentsPaginator'
import FinishedAppointmentItem from './FinishedAppointmentItem'

export default class FinishedAppointments extends Component {
  static propTypes = {
    isFetching: PropTypes.bool.isRequired,
    appointments: PropTypes.array.isRequired,
    page: PropTypes.string,
    fetchFinishedAppointments: PropTypes.func.isRequired,
    showCommentsModal: PropTypes.func.isRequired,
  }

  componentWillMount() {
    const { page } = this.props
    this.props.fetchFinishedAppointments({ page })
  }

  componentWillReceiveProps({ page }) {
    if (this.props.page !== page) {
      this.props.fetchFinishedAppointments({ page })
    }
  }

  render() {
    const { appointments, showCommentsModal } = this.props
    return (
      <div className="u-container tableBox">
        <div className="tableBox-title">History</div>

        <table className="table table-striped">
          <thead>
            <tr>
              <th>Name</th>
              <th>Appointment date</th>
              <th>Time</th>
              <th>Status</th>
              <th>Actions</th>
              <th>Payment</th>
              <th>Notes</th>
            </tr>
          </thead>
          <tbody>
            {appointments.map(a =>
              <FinishedAppointmentItem
                key={a.id}
                appointment={a}
                showCommentsModal={showCommentsModal}
              />
            )}
          </tbody>
        </table>

        <FinishedAppointmentsPaginator />
      </div>
    )
  }
}
