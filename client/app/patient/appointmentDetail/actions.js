import { callAPI } from 'app/api/actions'

export const APPOINTMENT_DETAIL = {
  FETCH: 'PATIENT/APPOINTMENT_DETAIL/FETCH',
  FETCH_SUCCESS: 'PATIENT/APPOINTMENT_DETAIL/FETCH_SUCCESS',
  FETCH_FAIL: 'PATIENT/APPOINTMENT_DETAIL/FETCH_FAIL',
}

export function fetchAppointmentDetail(appointmentId) {
  return callAPI({
    url: `/v1/p/appointments/${appointmentId}/`,
    method: 'get',
    actions: [
      APPOINTMENT_DETAIL.FETCH,
      APPOINTMENT_DETAIL.FETCH_SUCCESS,
      APPOINTMENT_DETAIL.FETCH_FAIL,
    ],
  })
}
