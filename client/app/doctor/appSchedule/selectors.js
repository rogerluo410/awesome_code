import { getEntityList, getAssocEntity } from 'app/api/selectors'

export function getSchedule(state) {
  const schedule = state.doctor.appSchedule
  let appointmentProducts

  if (schedule.ids && schedule.ids.length) {
    appointmentProducts =
      getEntityList(state, 'appointmentProducts', schedule.ids)
        .map(ap => {
          const scheduledAppointments = getAssocEntity(state, ap, 'scheduledAppointments')
          return { ...ap, scheduledAppointments }
        })
  } else {
    appointmentProducts = []
  }

  return {
    isFetching: schedule.isFetching,
    errorMessage: schedule.errorMessage,
    appointmentProducts,
  }
}
