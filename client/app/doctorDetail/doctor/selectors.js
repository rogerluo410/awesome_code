import { getEntity } from 'app/api/selectors'

export function getDoctor(state) {
  const obj = state.doctorDetail.doctor
  const doctor = obj.id && getEntity(state, 'doctor', obj.id)

  return {
    isFetching: obj.isFetching,
    doctor,
  }
}
