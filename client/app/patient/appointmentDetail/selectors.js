import { getEntity, getAssocEntity } from 'app/api/selectors'

export function getAppointmentDetail(state) {
  const appointmentDetail = state.patient.appointmentDetail

  const appointment = appointmentDetail.id ?
    getEntity(state, 'patAppointments', appointmentDetail.id) : null
  const comments = appointment ? getAssocEntity(state, appointment, 'comments') : []
  const prescriptions = appointment ? getAssocEntity(state, appointment, 'prescriptions') : []
  const medicalCertificate = appointment ?
    getAssocEntity(state, appointment, 'medicalCertificate') : null

  const result = {
    isFetching: appointmentDetail.isFetching,
    errorMessage: appointmentDetail.errorMessage,
    appointment,
    comments,
    prescriptions,
    medicalCertificate,
  }
  return result
}
