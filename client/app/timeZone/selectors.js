import moment from 'moment-timezone'
import { createSelector } from 'reselect'
import { getCurrentUserSelector } from 'app/auth/selectors'

function getBrowserTimeZone() {
  // moment already cached the time zone so no worries.
  return moment.tz.guess()
}

const getUserTimeZone = createSelector(
  getCurrentUserSelector,
  user => user.time_zone
)

export const getCurrentTimeZone = createSelector(
  getUserTimeZone,
  getBrowserTimeZone,
  (tzUser, tzBrowser) => {
    const tz = tzUser || tzBrowser
    // This is a trick for development, because in China the moment guessed time zone is Shanghai
    // but the doctor list API only supports Australia time zones. So we transform it to Perth.
    // It's the same as China time and has no DST.
    return tz === 'Asia/Shanghai' ? 'Australia/Perth' : tz
  }
)

// Returns lowercased weekday full name, i.e. "monday"
export const getCurrentWeekday = createSelector(
  getCurrentTimeZone,
  tz => moment.tz(tz).format('dddd').toLowerCase()
)

export const getCurrentDate = createSelector(
  getCurrentTimeZone,
  tz => moment.tz(tz).format()
)
