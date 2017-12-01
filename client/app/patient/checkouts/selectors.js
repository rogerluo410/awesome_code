export function getCheckoutsSelector(state) {
  const obj = state.patient.checkouts

  return {
    isFetching: obj.isFetching,
    checkouts: obj.ids.map(id => obj.entities[id]),
  }
}
