import { camelizeKeys } from 'humps'
import { callAPI } from 'app/api/actions'

export const DOCTOR = {
  FETCH: 'DOCTOR_DETAIL/DOCTOR/FETCH',
  FETCH_SUCCESS: 'DOCTOR_DETAIL/DOCTOR/FETCH_SUCCESS',
  FETCH_FAIL: 'DOCTOR_DETAIL/DOCTOR/FETCH_DOCTOR_FAIL',
}

export function fetchDoctor(id) {
  return callAPI({
    url: `/v1/doctors/${id}/profile`,
    method: 'get',
    actions: [
      DOCTOR.FETCH,
      DOCTOR.FETCH_SUCCESS,
      DOCTOR.FETCH_FAIL,
    ],
    normalizer: normalizeDocror,
  })
}

function normalizeDocror({ data }) {
  const d = camelizeKeys(data)
  return {
    result: { id: d.id },
    entities: { doctor: { [d.id]: d } },
  }
}

