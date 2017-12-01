import { getEntityList } from 'app/api/selectors'

export function getWeeklyPlans(state) {
  const subState = state.doctor.weeklyPlan
  const weeklyPlans = subState.ids ? getEntityList(state, 'weeklyPlans', subState.ids) : []

  return {
    isFetching: subState.isFetching,
    errorMessage: subState.errorMessage,
    weeklyPlans,
  }
}
