import api from 'app/api/api'
import { addFlashMessage } from 'app/flash/actions'
import { routerActions } from 'react-router-redux'

const CONFERENCE = {
  GENERATE_TOKEN_SUCCESS: 'CONFERENCE/GENERATE_TOKEN_SUCCESS',
  REQUEST_DOCTOR_PROFILE_SUCCESS: 'CONFERENCE/REQUEST_DOCTOR_PROFILE_SUCCESS',
  CREATE_CONFERENCE_SUCCESS: 'CONFERENCE/CREATE_CONFERENCE_SUCCESS',
  UPDATE_CONFERENCE_SUCCESS: 'CONFERENCE/UPDATE_CONFERENCE_SUCCESS',
  FINISH_CONFERENCE_REQUEST: 'CONFERENCE/FINISH_CONFERENCE_REQUEST',
  FINISH_CONFERENCE_FAILED: 'CONFERENCE/FINISH_CONFERENCE_FAILED',
  STOP_PROCESS: 'CONFERENCE/STOP_PROCESS',
  REFUND_CONFERENCE_REQUEST: 'CONFERENCE/REFUND_CONFERENCE_REQUEST',
  REFUND_CONFERENCE_FAILED: 'CONFERENCE/REFUND_CONFERENCE_FAILED',
  RECEIVE_NOTIFICATION: 'CONFERENCE/RECEIVE_NOTIFICATION',
  RESET_DATA: 'CONFERENCE/RESET_DATA',
}

function createConference(params) {
  return dispatch => {
    api.post('/v1/conferences/', params).then(response => {
      dispatch(createConferenceSuccess(response))
      dispatch(generateToken())
    }).catch(error => {
      dispatch(stopProcess(error.errorData))
    })
  }
}

function createConferenceSuccess(json) {
  return {
    type: CONFERENCE.CREATE_CONFERENCE_SUCCESS,
    payload: json.data.data,
  }
}

function startCall(appointmentId) {
  return dispatch => {
    api.get(`/v1/conferences/can_start_call/${appointmentId}`).then(() => {
      dispatch(generateToken())
    }).catch(error => {
      dispatch(stopProcess(error.errorData))
    })
  }
}

function generateToken() {
  return dispatch => {
    api.post('/v1/conferences/token').then(resp => {
      dispatch(generateTokenSuccess(resp))
    }).catch(error => {
      dispatch(stopProcess(error.errorData))
    })
  }
}

function generateTokenSuccess(json) {
  return {
    type: CONFERENCE.GENERATE_TOKEN_SUCCESS,
    payload: json.data.data.token,
  }
}

function stopProcess(json) {
  return {
    type: CONFERENCE.STOP_PROCESS,
    payload: json.message,
  }
}

function getDoctorProfile(id) {
  return dispatch => {
    api.get(`/v1/doctors/${id}/profile`).then((response) => {
      dispatch(getDoctorProfileSuccess(response))
    }).catch()
  }
}

function getDoctorProfileSuccess(json) {
  return {
    type: CONFERENCE.REQUEST_DOCTOR_PROFILE_SUCCESS,
    payload: json.data.data,
  }
}

function updateConference(conferenceId, params) {
  return dispatch => {
    api.patch(`/v1/conferences/${conferenceId}`, params).then(() => {
      dispatch(updateConferenceSuccess())
    }).catch()
  }
}

function updateConferenceSuccess() {
  return {
    type: CONFERENCE.UPDATE_CONFERENCE_SUCCESS,
  }
}

function finishConference(appointmentID) {
  return dispatch => {
    dispatch(finishConferenceRequest())
    api.put(`/v1/p/appointments/${appointmentID}/transfer`).then(() => {
      dispatch(addFlashMessage({
        message: 'Consultation finished.',
        level: 'success',
      }))
      dispatch(gotoDashboard())
    }).catch(err => {
      dispatch(addFlashMessage({
        message: err.errorData.message,
        level: 'error',
      }))
      dispatch(finishConferenceFailed())
    })
  }
}

function refundConference(appointmentID) {
  return dispatch => {
    dispatch(refundConferenceRequest())
    api.put(`/v1/p/appointments/${appointmentID}/refund`).then(() => {
      dispatch(addFlashMessage({
        message: 'Send refund request success.',
        level: 'success',
      }))
      dispatch(gotoDashboard())
    }).catch(err => {
      dispatch(addFlashMessage({
        message: err.errorData.message,
        level: 'error',
      }))
      dispatch(refundConferenceFailed())
    })
  }
}

function gotoDashboard() {
  return routerActions.push('/p/dashboard')
}

function finishConferenceRequest() {
  return {
    type: CONFERENCE.FINISH_CONFERENCE_REQUEST,
  }
}

function finishConferenceFailed() {
  return {
    type: CONFERENCE.FINISH_CONFERENCE_FAILED,
  }
}

function postNotification(params) {
  return dispatch => {
    api.post('/v1/conferences/notify', params).catch(error => {
      dispatch(stopProcess(error.errorData))
    })
  }
}

function refundConferenceRequest() {
  return {
    type: CONFERENCE.REFUND_CONFERENCE_REQUEST,
  }
}

function refundConferenceFailed() {
  return {
    type: CONFERENCE.REFUND_CONFERENCE_FAILED,
  }
}

function receiveNotification(json) {
  return { type: CONFERENCE.RECEIVE_NOTIFICATION, payload: json.data }
}

function resetConferenceData() {
  return { type: CONFERENCE.RESET_DATA }
}

export {
  CONFERENCE,
  startCall,
  updateConference,
  getDoctorProfile,
  createConference,
  finishConference,
  postNotification,
  refundConference,
  receiveNotification,
  resetConferenceData,
}
