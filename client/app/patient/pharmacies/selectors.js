export function getPharmaciesSelector(state) {
  const { entities, ids, totalCount, isFetching, isSubmitting } = state.patient.pharmacies
  const pharmacies = ids.map(id => entities[id])

  return {
    isSubmitting,
    isFetching,
    pharmacies,
    totalCount,
  }
}

