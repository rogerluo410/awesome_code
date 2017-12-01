import { callAPI } from 'app/api/actions'

export const APP_SCHEDULE = {
  FETCH: 'DOCTOR/APP_SCHEDULE/FETCH',
  FETCH_SUCCESS: 'DOCTOR/APP_SCHEDULE/FETCH_SUCCESS',
  FETCH_FAIL: 'DOCTOR/APP_SCHEDULE/FETCH_FAIL',
}

export function fetchSchedule(opts = { bg: false }) {
  return callAPI({
    url: '/v1/d/appointment_products/scheduled',
    method: 'get',
    actions: [
      (opts.bg ? null : APP_SCHEDULE.FETCH),
      APP_SCHEDULE.FETCH_SUCCESS,
      APP_SCHEDULE.FETCH_FAIL,
    ],
  })
}
