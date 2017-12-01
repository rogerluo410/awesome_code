import { routerActions } from 'react-router-redux'
import api from 'app/api/api'
import { addFlashMessage } from 'app/flash/actions'

export const SURVEYS = {
  FETCH_REQUEST: 'SURVEYS/FETCH_REQUEST',
  FETCH_SUCCESS: 'SURVEYS/FETCH_SUCCESS',
  FETCH_FAILURE: 'SURVEYS/FETCH_FAILURE',
  UPDATE_SUCCESS: 'SURVEYS/UPDATE_SUCCESS',
  SET_MODAL_VISIABLE: 'SURVEYS/SET_MODAL_VISIABLE',
  FETCH_REASONS_SUCCESS: 'SURVEYS/FETCH_REASONS_SUCCESS',
  FETCH_REASONS_FAILURE: 'SURVEYS/FETCH_REASONS_FAILURE',
}

export function showSurveyModal(id) {
  return dispatch => {
    dispatch(fetchSurvey(id))
    dispatch(toggleModal())
  }
}

export function closeModalAndRedirect() {
  return dispatch => {
    dispatch(closeModal())
    dispatch(gotoDashboard())
  }
}

export function fetchSurvey(id) {
  return dispatch => {
    dispatch(fetchSurveyRequest())
    dispatch(fetchReasons())
    api.get(`/v1/p/surveys/${id}`).then(resp => {
      dispatch(fetchSurveySuccess(resp.data))
    }, err => {
      dispatch(fetchSurveyFailure(err))
    })
  }
}

export function updateSurvey(data, dispatch) {
  return api.put(`/v1/p/surveys/${data.id}`, { data }).then(resp => {
    dispatch(updateSuccess(resp))
    dispatch(gotoDashboard())
    dispatch(addFlashMessage({
      message: 'Update survey sueccess',
      level: 'success',
    }))
  }, err => {
    dispatch(addFlashMessage({
      message: err.errorData.message,
      level: 'error',
    }))
  })
}

export function fetchReasons() {
  return dispatch => {
    api.get('/v1/p/reasons').then(resp => {
      dispatch(fetchReasonsSuccess(resp.data))
    }, err => {
      dispatch(fetchReasonsFailure(err))
    })
  }
}

function fetchReasonsSuccess(respData) {
  return {
    type: SURVEYS.FETCH_REASONS_SUCCESS,
    payload: respData.data,
  }
}

function fetchReasonsFailure(err) {
  return {
    type: SURVEYS.FETCH_REASONS_FAILURE,
    payload: err,
    error: true,
  }
}

function gotoDashboard() {
  return routerActions.push('/p/dashboard')
}

function fetchSurveyRequest() {
  return {
    type: SURVEYS.FETCH_REQUEST,
  }
}

function fetchSurveySuccess(respData) {
  return {
    type: SURVEYS.FETCH_SUCCESS,
    payload: respData.data,
  }
}

function fetchSurveyFailure(err) {
  return {
    type: SURVEYS.FETCH_FAILURE,
    payload: err,
    error: true,
  }
}

function toggleModal() {
  return {
    type: SURVEYS.SET_MODAL_VISIABLE,
    payload: true,
  }
}

function closeModal() {
  return {
    type: SURVEYS.SET_MODAL_VISIABLE,
    payload: false,
  }
}

function updateSuccess() {
  return { type: SURVEYS.UPDATE_SUCCESS }
}
