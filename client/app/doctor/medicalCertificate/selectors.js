import { getEntity } from 'app/api/selectors'

export function getMedicalCertificateSelector(state) {
  const obj = state.doctor.medicalCertificate
  const medicalCertificate = obj.id ? getEntity(state, 'medicalCertificates', obj.id) : null

  return {
    isFetching: obj.isFetching,
    medicalCertificate,
  }
}
