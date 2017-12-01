import React, { PropTypes } from 'react'
import { connect } from 'react-redux'
import { getCurrentTimeZone } from 'app/timeZone/selectors'
import { formatTime } from './helpers'

function Time({ value, format, tz }) {
  return (
    <span>{formatTime(value, format, tz)}</span>
  )
}

Time.propTypes = {
  value: PropTypes.string.isRequired,
  format: PropTypes.string.isRequired,
  tz: PropTypes.string.isRequired,
}

export default connect(state => ({ tz: getCurrentTimeZone(state) }))(Time)
