export function getDoctorsSelector(state) {
  const { doctorsById, ids } = state.doctors
  return ids.map(id => doctorsById[id])
}

export function getDoctorsTotalCountSelector(state) {
  const { totalCount } = state.doctors
  return totalCount
}
