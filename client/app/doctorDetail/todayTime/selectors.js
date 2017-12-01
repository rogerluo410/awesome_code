import { getEntityList } from 'app/api/selectors'

export function getDoctorTodayTime(state) {
  const subState = state.doctorDetail.todayTime
  const todayTime = subState.ids ? getEntityList(state, 'todayTime', subState.ids) : []

  return {
    isFetching: subState.isFetching,
    errorMessage: subState.errorMessage,
    todayTime,
  }
}
