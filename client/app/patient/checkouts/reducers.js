import omit from 'lodash/omit'
import mapValues from 'lodash/mapValues'
import { camelizeKeys } from 'humps'
import { CHECKOUTS } from './actions'
import { arrayToHash } from 'app/utils/common'


const initState = {
  isFetching: false,
  entities: {},
  ids: [],
  visiable: false,
  visiablePay: false,
}

export default function surveysReducer(state = initState, action) {
  switch (action.type) {
    case CHECKOUTS.SET_MODAL_VISIABLE:
      return {
        ...state,
        visiable: action.payload,
      }

    case CHECKOUTS.SET_MODAL_VISIABLE_PAY:
      return {
        ...state,
        visiablePay: action.payload,
      }
    case CHECKOUTS.FETCH_REQUEST:
      return {
        ...state,
        isFetching: true,
      }
    case CHECKOUTS.FETCH_SUCCESS:
      return {
        ...state,
        isFetching: false,
        entities: { ...arrayToHash(camelizeKeys(action.payload)) },
        ids: action.payload.map(i => i.id),
      }
    case CHECKOUTS.FETCH_FAILURE:
      return { ...state, isFetching: false }
    case CHECKOUTS.SAVE_SUCCESS:
      return {
        ...state,
        entities: {
          ...state.entities,
          [action.payload.id]: camelizeKeys(action.payload),
        },
        ids: [action.payload.id, ...state.ids],
      }
    case CHECKOUTS.DESTROY_SUCCESS:
      return {
        ...state,
        entities: omit(state.entities, action.payload),
        ids: state.ids.filter(id => id !== action.payload),
      }
    case CHECKOUTS.UPDATE_DEFAULT: {
      const entities = mapValues(state.entities, i =>
        ({ ...i, default: i.id === action.payload })
      )
      return {
        ...state,
        entities,
      }
    }
    default:
      return state
  }
}
