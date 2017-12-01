import { getEntityList } from 'app/api/selectors'

export function getRecentAppointments(state) {
  const recent = state.doctor.recentAppointments

  const appointments = getEntityList(state, 'docAppointments', recent.ids)

  return {
    isFetching: recent.isFetching,
    errorMessage: recent.errorMessage,
    appointments,
  }
}
