import React, { Component, PropTypes } from 'react'
import TimePeriod from 'app/timeZone/TimePeriod'

class AppointmentPeriod extends Component {
  static propTypes = {
    period: PropTypes.shape({
      id: PropTypes.number.isRequired,
      start_time: PropTypes.string.isRequired,
      end_time: PropTypes.string.isRequired,
      available_slots: PropTypes.number.isRequired,
    }).isRequired,
    appoint: PropTypes.func.isRequired,
  }

  canAppoint() {
    return !!this.props.period.available_slots
  }

  appoint = () => {
    if (this.canAppoint()) this.props.appoint(this.props.period)
  }

  markClassName() {
    const className = [
      'mark', 'mark--float',
      this.canAppoint() ? 'is-blue' : 'is-gray',
    ]
    return className.join(' ')
  }

  render() {
    const { start_time: startTime, end_time: endTime } = this.props.period
    return (
      <TimePeriod
        className={this.markClassName()}
        onClick={this.appoint}
        startTime={startTime}
        endTime={endTime}
      />
    )
  }
}

export default AppointmentPeriod
