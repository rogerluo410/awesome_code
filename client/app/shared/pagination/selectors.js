import get from 'lodash/get'
import pick from 'lodash/pick'

export function getPaginationSelector(state, path) {
  const pagination = get(state, path)
  return pick(pagination, ['nextPage', 'prevPage'])
}
