import { callAPI } from 'app/api/actions'

export const RECENT_APPOINTMENTS = {
  FETCH: 'DOCTOR/RECENT_APPOINTMENTS/FETCH',
  FETCH_SUCCESS: 'DOCTOR/RECENT_APPOINTMENTS/FETCH_SUCCESS',
  FETCH_FAIL: 'DOCTOR/RECENT_APPOINTMENTS/FETCH_FAIL',
}

export function fetchRecentAppointments() {
  return callAPI({
    url: '/v1/d/appointments/finished',
    params: { limit: 10 },
    method: 'get',
    actions: [
      RECENT_APPOINTMENTS.FETCH,
      RECENT_APPOINTMENTS.FETCH_SUCCESS,
      RECENT_APPOINTMENTS.FETCH_FAIL,
    ],
  })
}
