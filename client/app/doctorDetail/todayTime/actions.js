import { camelizeKeys } from 'humps'
import { callAPI } from 'app/api/actions'
import { arrayToHash } from 'app/utils/common'

export const TODAY_TIMES = {
  FETCH: 'DOCTOR_DETAIL/TODAY_TIMES/FETCH',
  FETCH_SUCCESS: 'DOCTOR_DETAIL/TODAY_TIMES/FETCH_SUCCESS',
  FETCH_FAIL: 'DOCTOR_DETAIL/TODAY_TIMES/FETCH_DOCTOR_FAIL',
}

export function fetchDoctorTodayTime(params) {
  return callAPI({
    url: `/v1/doctors/${params.id}/appointment_periods`,
    params,
    method: 'get',
    actions: [
      TODAY_TIMES.FETCH,
      TODAY_TIMES.FETCH_SUCCESS,
      TODAY_TIMES.FETCH_FAIL,
    ],
    normalizer: normalizeTodayTime,
  })
}

function normalizeTodayTime({ data }) {
  const d = camelizeKeys(data)
  return {
    result: d.map(i => ({ id: i.id })),
    entities: { todayTime: arrayToHash(d) },
  }
}

