import React, { Component, PropTypes } from 'react'
import { locationShape } from 'react-router/lib/PropTypes'
import get from 'lodash/get'
import cable from 'app/cable'
import ActiveAppointmentContainer from './ActiveAppointmentContainer'
import FinishedAppointmentsContainer from './FinishedAppointmentsContainer'

export default class Dashboard extends Component {
  static propTypes = {
    location: locationShape,
    fetchActiveAppointment: PropTypes.func.isRequired,
    fetchFinishedAppointments: PropTypes.func.isRequired,
  }

  componentWillMount() {
    this.subscription = cable.subscriptions.create('PatientDashboardChannel', {
      received: (json) => {
        if (json.op === 'app_accepted') {
          this.props.fetchActiveAppointment({ bg: true })
        } else if (json.op === 'app_declined') {
          this.props.fetchActiveAppointment({ bg: true })
          const page = get(this.props, 'location.query.page')
          this.props.fetchFinishedAppointments({ bg: true, page })
        }
      },
    })
  }

  componentWillUnmount() {
    if (this.subscription) {
      this.subscription.unsubscribe()
      delete this.subscription
    }
  }

  render() {
    const page = get(this.props, 'location.query.page')

    return (
      <div>
        <ActiveAppointmentContainer />
        <FinishedAppointmentsContainer page={page} />
      </div>
    )
  }
}
