import { getEntityList } from 'app/api/selectors'

export function getCommentsSelector(state) {
  const obj = state.comments
  const comments = getEntityList(state, 'comments', obj.ids)

  return {
    isFetching: obj.isFetching,
    comments,
  }
}
