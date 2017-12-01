import api from 'app/api/api'
import { addFlashMessage } from 'app/flash/actions'

const APPOINTMENTSETTINGS = {
  FETCH_REQUEST: 'APPOINTMENTSETTINGS/FETCH_REQUEST',
  FETCH_SUCCESS: 'APPOINTMENTSETTINGS/FETCH_SUCCESS',
  FETCH_FAILURE: 'APPOINTMENTSETTINGS/FETCH_FAILURE',
  UPDATE_REQUEST: 'APPOINTMENTSETTINGS/UPDATE_REQUEST',
  UPDATE_SUCCESS: 'APPOINTMENTSETTINGS/UPDATE_SUCCESS',
  UPDATE_FAILURE: 'APPOINTMENTSETTINGS/UPDATE_FAILURE',
}

// Fetch appointment settings process
function fetchAppointmentSettingsRequest() {
  return { type: APPOINTMENTSETTINGS.FETCH_REQUEST }
}

function fetchAppointmentSettingsSuccess(respData) {
  return {
    type: APPOINTMENTSETTINGS.FETCH_SUCCESS,
    payload: respData.data,
  }
}

function fetchAppointmentSettingsFail(err) {
  return {
    type: APPOINTMENTSETTINGS.FETCH_FAILURE,
    payload: err,
    error: true,
  }
}

function fetchAppointmentSettings() {
  return dispatch => {
    fetchAppointmentSettingsCore(dispatch)
  }
}

function fetchAppointmentSettingsCore(dispatch) {
  dispatch(fetchAppointmentSettingsRequest())
  api.get('/v1/d/appointment_settings').then(resp => {
    dispatch(fetchAppointmentSettingsSuccess(resp.data))
  }).catch(err => {
    dispatch(addFlashMessage({
      message: err.errorData.message,
      level: 'error',
    }))
    dispatch(fetchAppointmentSettingsFail(err))
  })
}


// Update Appointment setting process
function updateAppointmentSettingsRequest() {
  return { type: APPOINTMENTSETTINGS.UPDATE_REQUEST }
}

function updateAppointmentSettingsSuccess(respData) {
  return {
    type: APPOINTMENTSETTINGS.UPDATE_SUCCESS,
    payload: respData.data,
  }
}

function updateAppointmentSettingsFail(err) {
  return {
    type: APPOINTMENTSETTINGS.UPDATE_FAILURE,
    payload: err,
  }
}

function updateAppointmentSettings(params) {
  return dispatch => {
    updateAppointmentSettingsCore(dispatch, params)
  }
}

function unableEditPlan() {
  return dispatch => {
    dispatch(addFlashMessage({
      message: 'Can not edit the plan for today.',
      level: 'error',
    }))
  }
}

function updateAppointmentSettingsCore(dispatch, params) {
  dispatch(updateAppointmentSettingsRequest())
  api.patch('/v1/d/appointment_settings/update', params).then(resp => {
    dispatch(updateAppointmentSettingsSuccess(resp.data))
  }).catch(err => {
    dispatch(addFlashMessage({
      message: err.errorData.message,
      level: 'error',
    }))
    dispatch(updateAppointmentSettingsFail(err))
  })
}

export {
  APPOINTMENTSETTINGS,
  fetchAppointmentSettings,
  updateAppointmentSettings,
  unableEditPlan,
}
