import { camelizeKeys } from 'humps'
import { callAPI } from 'app/api/actions'
import { arrayToHash } from 'app/utils/common'

export const WEEKLY_PLAN = {
  FETCH: 'DOCTOR/WEEKLY_PLAN/FETCH',
  FETCH_SUCCESS: 'DOCTOR/WEEKLY_PLAN/FETCH_SUCCESS',
  FETCH_FAIL: 'DOCTOR/WEEKLY_PLAN/FETCH_FAIL',
}

export function fetchWeeklyPlan() {
  return callAPI({
    url: '/v1/d/appointment_settings',
    method: 'get',
    actions: [
      WEEKLY_PLAN.FETCH,
      WEEKLY_PLAN.FETCH_SUCCESS,
      WEEKLY_PLAN.FETCH_FAIL,
    ],
    normalizer: normalizeWeeklyPlan,
  })
}

function normalizeWeeklyPlan({ data }) {
  const d = camelizeKeys(data)
  return {
    result: d.map(i => ({ id: i.id })),
    entities: { weeklyPlans: arrayToHash(d) },
  }
}
