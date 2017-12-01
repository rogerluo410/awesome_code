import { getEntity, getAssocEntity } from 'app/api/selectors'

export function getUpcomingScope(state) {
  return state.doctor.upcomingAppointment
}

export function getUpcomingAppointment(state) {
  const upcoming = state.doctor.upcomingAppointment

  const appointment = upcoming.id && getEntity(state, 'docAppointments', upcoming.id)
  const survey = appointment && getAssocEntity(state, appointment, 'survey')

  const result = {
    isFetching: upcoming.isFetching,
    errorMessage: upcoming.errorMessage,
    appointment,
    survey,
  }

  return result
}
