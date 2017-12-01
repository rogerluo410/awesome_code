export default function apiEntitiesReducer(state = {}, { apiEntities }) {
  if (!apiEntities) return state

  const keys = Object.keys(apiEntities)
  if (!keys.length) return state

  let newState = state
  keys.forEach(key => {
    const subEntities = apiEntities[key]
    const subState = state[key] || {}

    const keyedEntities = {
      ...subState,
      ...subEntities,
    }

    newState = {
      ...newState,
      [key]: keyedEntities,
    }
  })

  return newState
}

export function createEntityReducer(opts = {}, wrappedReducer) {
  const successReducer = (state, { payload }) => ({ ...state, id: payload && payload.id })
  return createApiReducer({ ...opts, successReducer }, wrappedReducer)
}

export function createEntityListReducer(opts = {}, wrappedReducer) {
  const successReducer = (state, { payload }) => ({ ...state, ids: payload.map(i => i.id) })
  return createApiReducer({ ...opts, successReducer }, wrappedReducer)
}

function createApiReducer(opts, reducer) {
  const { actions, initState, pendingKey = 'isFetching', successReducer } = opts

  if (typeof successReducer !== 'function') {
    throw new Error('successReducer must be a function')
  }
  if (typeof pendingKey !== 'string' || !pendingKey) {
    throw new Error('pendingKey must be a string')
  }

  const defaultState = {
    [pendingKey]: false,
    errorMessage: null,
  }

  const apiInitState = (initState && typeof initState === 'object')
    ? { ...defaultState, ...initState }
    : defaultState

  const [requestType, successType, failureType] = actions

  return (state = apiInitState, action) => {
    const { type, payload } = action
    let nextState

    switch (type) {
      case requestType:
        nextState = {
          ...state,
          [pendingKey]: true,
          errorMessage: null,
        }
        break
      case successType:
        nextState = {
          ...successReducer(state, action),
          [pendingKey]: false,
          errorMessage: null,
        }
        break
      case failureType:
        nextState = {
          ...state,
          [pendingKey]: false,
          errorMessage: payload.message,
        }
        break
      default:
        nextState = state
    }

    return (typeof reducer === 'function') ? reducer(nextState, action) : nextState
  }
}
