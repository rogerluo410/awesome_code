import { camelizeKeys } from 'humps'
import api from 'app/api/api'
import { paginateSuccessAction } from 'app/shared/pagination/helpers'
import { addFlashMessage } from 'app/flash/actions'
import { showModal } from 'app/registration/actions'
import { showSurveyModal } from 'app/patient/surveys/actions'
import { getIsSignedInSelector } from 'app/auth/selectors'

export const APPOINTMENTS = {
  APPOINT_REQUEST: 'PATIENT/APPOINTMENTS/APPOINT_REQUEST',
  APPOINT_SUCCESS: 'PATIENT/APPOINTMENTS/APPOINT_SUCCESS',
  ACTIVE_REQUEST: 'PATIENT/APPOINTMENTS/ACTIVE_REQUEST',
  ACTIVE_SUCCESS: 'PATIENT/APPOINTMENTS/ACTIVE_SUCCESS',
  ACTIVE_FAILURE: 'PATIENT/APPOINTMENTS/ACTIVE_FAILURE',
  FINISHED_REQUEST: 'PATIENT/APPOINTMENTS/FINISHED_REQUEST',
  FINISHED_SUCCESS: 'PATIENT/APPOINTMENTS/FINISHED_SUCCESS',
  FINISHED_FAILURE: 'PATIENT/APPOINTMENTS/FINISHED_FAILURE',
  PAID_SUCCESS: 'PATIENT/APPOINTMENTS/PAID_SUCCESS',
  RECEIVE: 'PATIENT/APPOINTMENTS/RECEIVE',
}

export function appoint(params) {
  return (dispatch, getState) => {
    const isSignedIn = getIsSignedInSelector(getState())

    if (!isSignedIn) {
      dispatch(showModal())
      return
    }

    dispatch(appointRequest())
    api.post('/v1/p/appointments', params).then(resp => {
      dispatch(appointSuccess(resp))
      dispatch(showSurveyModal(resp.data.survey_id))
    }, err => {
      dispatch(addFlashMessage({
        message: err.errorData.message,
        level: 'error',
      }))
    })
  }
}

export function fetchActiveAppointment(opts = { bg: false }) {
  return dispatch => {
    if (!opts.bg) dispatch(activeRequest())

    api.get('/v1/p/appointments/active').then(resp => {
      dispatch(activeSuccess(resp))
    }, err => {
      dispatch(activeFailure(err))
    })
  }
}

export function fetchFinishedAppointments(opts = { bg: false, page: 1 }) {
  return dispatch => {
    if (!opts.bg) dispatch(finishedRequest())

    api.get('/v1/p/appointments/finished', { params: { page: opts.page } }).then(resp => {
      // eslint-disable-next-line no-use-before-define
      dispatch(finishedSuccess(resp))
    }, err => {
      dispatch(finishedFailure(err))
    })
  }
}

export function appointmentPaid(resp) {
  return dispatch => {
    dispatch(appointmentPaidSuccess(resp))
  }
}

export function receiveAppointment(resp) {
  return updateEntity(resp, APPOINTMENTS.RECEIVE)
}

function appointRequest() {
  return { type: APPOINTMENTS.APPOINT_REQUEST }
}

function appointSuccess() {
  return { type: APPOINTMENTS.APPOINT_SUCCESS }
}

function activeRequest() {
  return { type: APPOINTMENTS.ACTIVE_REQUEST }
}

function activeSuccess(resp) {
  return updateEntity(resp, APPOINTMENTS.ACTIVE_SUCCESS)
}

function activeFailure(err) {
  return {
    type: APPOINTMENTS.ACTIVE_FAILURE,
    payload: err,
    error: true,
  }
}

function finishedRequest() {
  return { type: APPOINTMENTS.FINISHED_REQUEST }
}

function appointmentPaidSuccess(resp) {
  return updateEntity(resp, APPOINTMENTS.PAID_SUCCESS)
}

// eslint-disable-next-line no-use-before-define
const finishedSuccess = paginateSuccessAction({ action: APPOINTMENTS.FINISHED_SUCCESS })

function finishedFailure(err) {
  return {
    type: APPOINTMENTS.FINISHED_FAILURE,
    payload: err,
    error: true,
  }
}

function updateEntity(resp, actionType) {
  const data = resp.data.data || resp.data
  const payload = data ? camelizeKeys(data) : null
  const entities = payload && { [payload.id]: payload }

  return {
    type: actionType,
    payload,
    entities,
  }
}
