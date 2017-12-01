import { PHARMACIES } from './actions'
import { paginateReducer } from 'app/shared/pagination/helpers'

const initState = {
  entities: {},
  isFetching: false,
  isSubmitting: false,
  ids: [],
  currentPage: null,
  nextPage: null,
  prevPage: null,
  totalPages: null,
  totalCount: 0,
}

const pharmaciesPaginateReducer = paginateReducer({
  actions: [PHARMACIES.REQUEST, PHARMACIES.SUCCESS, PHARMACIES.FAILURE],
})

export default function pharmaciesReducer(state = initState, action) {
  const newState = pharmaciesPaginateReducer(state, action)

  switch (action.type) {
    case PHARMACIES.REQUEST:
      return {
        ...state,
        isFetching: true,
      }
    case PHARMACIES.SUCCESS: {
      const entities = { ...newState.entities, ...action.entities }
      return {
        ...newState,
        entities,
        isFetching: false,
      }
    }
    case PHARMACIES.FAILURE: {
      return {
        ...state,
        isFetching: false,
      }
    }
    case PHARMACIES.POST:
      return {
        ...state,
        isSubmitting: true,
      }
    case PHARMACIES.POST_SUCCRESS:
      return {
        ...state,
        isSubmitting: false,
      }
    case PHARMACIES.POST_FAIL:
      return {
        ...state,
        isSubmitting: false,
      }
    default:
      return newState
  }
}
