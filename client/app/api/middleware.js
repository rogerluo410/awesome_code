import api from './api'
import { CALL_API } from './actions'
import { normalizeJsonApi } from './normalizers'

// The middleware interface is: store => next => action => { ... }
// We ignore unused parameters.
export default () => next => action => {
  const apiOpts = action[CALL_API]

  if (typeof apiOpts === 'undefined') return next(action)

  const {
    url, method, params, data,
    actions: [requestType, successType, failureType],
    normalizer,
  } = apiOpts

  if (requestType) {
    next({ type: requestType })
  }

  return api.request({
    url,
    method,
    params,
    data,
  }).then(resp => {
    const normalizedData = (typeof normalizer === 'function')
      ? normalizer(resp.data)
      : normalizeJsonApi(resp.data)

    const action = {
      type: successType,
      payload: normalizedData.result,
      apiEntities: normalizedData.entities,
    }
    next(action)
    return action.payload
  }, err => {
    const action = actionForError(failureType, err)
    next(action)
    throw action.payload
  })
}

function actionForError(failureType, err) {
  const payload = {}

  if (err.response) {
    const resp = err.response
    payload.message = resp.data ? resp.data.error.message : `API error ${resp.status}`
    payload.status = resp.status
  } else {
    // Something happened in setting up the request that triggered an Error
    payload.message = err.message
  }

  return {
    type: failureType,
    error: true,
    payload,
  }
}
