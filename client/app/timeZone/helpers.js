import moment from 'moment-timezone'

export function formatTime(value, fmt, tz) {
  return moment.tz(value, tz).format(fmt)
}
