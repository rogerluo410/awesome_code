import pick from 'lodash/pick'
import reduce from 'lodash/reduce'

export function normalizeJsonApi(payload) {
  const { data, included } = payload

  const result = data ? pickIdTypePairs(data) : null
  const entities = {}

  // normalize data
  if (data) {
    if (Array.isArray(data)) {
      for (const res of data) mergeIntoEntities(entities, res)
    } else {
      mergeIntoEntities(entities, data)
    }
  }

  // normalize included
  if (included) {
    for (const res of included) mergeIntoEntities(entities, res)
  }

  return { result, entities }
}

function mergeIntoEntities(entities, data) {
  const typedEntities = entities[data.type] || {}
  typedEntities[data.id] = normalizeEntity(data)
  // eslint-disable-next-line no-param-reassign
  entities[data.type] = typedEntities
}

function normalizeEntity(data) {
  const { attributes, relationships } = data

  const assoc = reduce(relationships, (acc, val, key) => {
    // eslint-disable-next-line no-param-reassign
    acc[key] = pickIdTypePairs(val.data)
    return acc
  }, {})

  return {
    id: data.id,
    ...attributes,
    assoc,
  }
}

function pickIdTypePairs(data) {
  if (Array.isArray(data)) {
    return data.map(i => pick(i, ['type', 'id']))
  }
  return pick(data, ['type', 'id'])
}
