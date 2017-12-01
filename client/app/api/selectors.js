export function getEntity(state, type, id) {
  const apiEntities = getApiEntitiesScope(state)
  if (!apiEntities) return null

  const typedEntities = apiEntities[type]
  if (!typedEntities) return null

  return typedEntities[id]
}

export function getEntityList(state, type, ids) {
  const apiEntities = getApiEntitiesScope(state)
  if (!apiEntities) return []

  const typedEntities = apiEntities[type]
  if (!typedEntities) return []

  if (Array.isArray(ids) && ids.length) {
    return ids.map(id => getEntity(state, type, id))
  }
  return []
}

export function getAssocEntity(state, entity, assocKey) {
  if (!entity) return null

  const assoc = entity.assoc[assocKey]

  if (Array.isArray(assoc)) {
    return assoc.map(i => getEntity(state, i.type, i.id))
  }

  return (!assoc.id || !assoc.type)
    ? null
    : getEntity(state, assoc.type, assoc.id)
}

// export function getAssocEntities(entity, assocKey) {
// }

function getApiEntitiesScope(state) {
  return state.apiEntities
}
