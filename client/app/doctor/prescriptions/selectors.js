import { getEntityList } from 'app/api/selectors'

export function getPrescriptionsSelector(state) {
  const obj = state.doctor.prescriptions
  const prescriptions = getEntityList(state, 'prescriptions', obj.ids)

  return {
    isFetching: obj.isFetching,
    prescriptions,
  }
}
