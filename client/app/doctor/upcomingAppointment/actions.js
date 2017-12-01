import { callAPI } from 'app/api/actions'
import { getUpcomingScope } from './selectors'

export const UPCOMING_APPOINTMENT = {
  FETCH: 'DOCTOR/UPCOMING_APPOINTMENT/FETCH',
  FETCH_SUCCESS: 'DOCTOR/UPCOMING_APPOINTMENT/FETCH_SUCCESS',
  FETCH_FAIL: 'DOCTOR/UPCOMING_APPOINTMENT/FETCH_FAIL',
}

export function fetchUpcomingAppointment(opts = { bg: false }) {
  return callAPI({
    url: '/v1/d/appointments/upcoming',
    method: 'get',
    actions: [
      (opts.bg ? null : UPCOMING_APPOINTMENT.FETCH),
      UPCOMING_APPOINTMENT.FETCH_SUCCESS,
      UPCOMING_APPOINTMENT.FETCH_FAIL,
    ],
  })
}

export function refreshUpcoming(updatedAppId) {
  return (dispatch, getState) => {
    const appId = getUpcomingScope(getState()).id
    if (appId === updatedAppId) {
      dispatch(fetchUpcomingAppointment({ bg: true }))
    }
  }
}
