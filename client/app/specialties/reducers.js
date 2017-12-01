import * as UtilsCommon from '../utils/common'

const initState = {
  specialtiesById: {},
  list: {
    isFetching: false,
    ids: [],
  },
}

function specialtiesReducer(state = initState, action) {
  switch (action.type) {
    case 'FETCH_SPECIALTIES_REQUEST':
      return { ...state, list: { ...state.list, isFetching: true } }
    case 'FETCH_SPECIALTIES_SUCCESS': {
      const newList = {
        isFetching: false,
        ids: action.payload.map(i => i.id),
      }

      const newSpecialtiesById = {
        ...state.specialtiesById,
        ...UtilsCommon.arrayToHash(action.payload),
      }

      return {
        ...state,
        list: newList,
        specialtiesById: newSpecialtiesById,
      }
    }
    case 'fetchSpecialtiesFail':
      return { ...state, list: { ...state.list, isFetching: false } }
    default:
      return state
  }
}

export default specialtiesReducer
