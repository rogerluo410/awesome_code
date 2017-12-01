import { createEntityReducer } from 'app/api/reducers'
import { APP_REVIEW } from './actions'

export default pipeReducers(
  (state) => (
    state || { isShown: false, isFetching: false, isSubmitting: false }
  ),
  createEntityReducer({
    actions: [
      APP_REVIEW.FETCH,
      APP_REVIEW.FETCH_SUCCESS,
      APP_REVIEW.FETCH_FAIL,
    ],
  }),
  createEntityReducer({
    pendingKey: 'isSubmitting',
    actions: [
      APP_REVIEW.SUBMIT,
      APP_REVIEW.SUBMIT_SUCCESS,
      APP_REVIEW.SUBMIT_FAIL,
    ],
  }),
  (state, { type }) => (
    (type === APP_REVIEW.TOGGLE_MODAL)
      ? { ...state, isShown: !state.isShown }
      : state
  )
)

function pipeReducers(...reducers) {
  return (state, action) => {
    let newState = state
    for (const r of reducers) {
      newState = r(newState, action)
    }
    return newState
  }
}
