export function getActiveAppointmentSelector(state) {
  const obj = state.patient.appointments.activeAppointment

  return {
    isFetching: obj.isFetching,
    appointment: obj.id ? state.patient.appointments.entities[obj.id] : null,
  }
}

export function getFinishedAppointmentsSelector(state) {
  const obj = state.patient.appointments.finishedAppointments

  return {
    isFetching: obj.isFetching,
    appointments: obj.ids.map(id => state.patient.appointments.entities[id]),
  }
}
