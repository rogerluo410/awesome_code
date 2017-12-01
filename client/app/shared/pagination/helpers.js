import { camelizeKeys } from 'humps'
import { arrayToHash } from 'app/utils/common'

/**
 * A function to create pagination reducer
 *
 * Example:
 *
 *     combineReducers({
 *       doctorsList: createPaginationReducer({
 *         actions: [DOCTORS_REQUEST, DOCTORS_SUCCESS, DOCTORS_FAILURE]
 *       })
 *     })
 */
export function paginateReducer({ actions }) {
  const [REQUEST, SUCCESS, FAILURE] = actions

  const initState = {
    ids: [],
    isFetching: false,
    fail: null,
    currentPage: null,
  }

  return (state = initState, { type, payload, meta }) => {
    switch (type) {
      case REQUEST:
        return {
          ...state,
          isFetching: true,
          fail: null,
        }
      case SUCCESS:
        return {
          ...state,
          isFetching: false,
          ids: payload,
          fail: null,
          ...meta,
        }
      case FAILURE:
        return {
          ...state,
          isFetching: false,
          fail: payload,
        }
      default:
        return state
    }
  }
}

/**
 * Build an action creator for paginate success which fits paginateReducer.
 *
 * Example
 *
 *     const doctorsSuccess = paginateSuccessAction({
 *       action: DOCTORS_SUCCESS,
 *     })
 *
 *     // Pass an api response in
 *     const action = doctorsSuccess(resp)
 *
 *     // The action is like this:
 *     {
 *       type: DOCTORS_SUCCESS,
 *       payload: [1, 2, 3],
 *       entities: {
 *         1: { id: 1, name: 'David', ... },
 *         2: {...},
 *         3: {...},
 *       },
 *       meta: {
 *         currentPage: 1,
 *         nextPage: 2,
 *         prevPage: null,
 *         totalPages: 10,
 *         totalCount: 200,
 *       }
 *     }
 */
export function paginateSuccessAction({ action, camelizeData = true }) {
  return (resp) => {
    const data = camelizeData ? camelizeKeys(resp.data.data) : resp.data.data

    const payload = data.map(i => i.id)
    const entities = arrayToHash(data)
    const meta = camelizeKeys(resp.data.meta)

    return {
      type: action,
      payload,
      entities,
      meta,
    }
  }
}
