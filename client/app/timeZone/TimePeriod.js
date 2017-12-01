import React, { PropTypes } from 'react'
import { connect } from 'react-redux'
import { getCurrentTimeZone } from 'app/timeZone/selectors'
import { formatTime } from './helpers'

function TimePeriod({ startTime, endTime, tz, className, onClick }) {
  return (
    <div className={className} onClick={onClick}>
      {`${formatTime(startTime, 'HH:mm', tz)} - ${formatTime(endTime, 'HH:mm', tz)}`}
    </div>
  )
}

TimePeriod.propTypes = {
  startTime: PropTypes.string.isRequired,
  endTime: PropTypes.string.isRequired,
  tz: PropTypes.string.isRequired,
  className: PropTypes.string,
  onClick: PropTypes.func,
}

export default connect(state => ({ tz: getCurrentTimeZone(state) }))(TimePeriod)
