import { connect } from 'react-redux'
import { getPaginationSelector } from './selectors'
import Paginator from './Paginator'

export default function connectPaginator(path, actions = {}) {
  return connect(state => getPaginationSelector(state, path), actions)(Paginator)
}
