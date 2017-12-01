import { DOCTORS } from './actions'
import { paginateReducer } from 'app/shared/pagination/helpers'

const initState = {
  doctorsById: {},
  isFetching: false,
  ids: [],
  currentPage: null,
  nextPage: null,
  prevPage: null,
  totalPages: null,
  totalCount: null,
}

const doctorsPaginateReducer = paginateReducer({
  actions: [DOCTORS.REQUEST, DOCTORS.SUCCESS, DOCTORS.FAILURE],
})

export default function doctorsReducer(state = initState, action) {
  const newState = doctorsPaginateReducer(state, action)

  switch (action.type) {
    case DOCTORS.SUCCESS: {
      const doctorsById = { ...newState.doctorsById, ...action.entities }
      return {
        ...newState,
        doctorsById,
      }
    }
    default:
      return newState
  }
}
