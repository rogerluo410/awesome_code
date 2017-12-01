import { callAPI } from 'app/api/actions'
import { fetchUpcomingAppointment } from '../upcomingAppointment/actions'
import { fetchSchedule } from '../appSchedule/actions'

export const APP_REVIEW = {
  TOGGLE_MODAL: 'DOCTOR/APP_REVIEW/TOGGLE_MODAL',
  FETCH: 'DOCTOR/APP_REVIEW/FETCH',
  FETCH_SUCCESS: 'DOCTOR/APP_REVIEW/FETCH_SUCCESS',
  FETCH_FAIL: 'DOCTOR/APP_REVIEW/FETCH_FAIL',
  SUBMIT: 'DOCTOR/APP_REVIEW/SUBMIT',
  SUBMIT_SUCCESS: 'DOCTOR/APP_REVIEW/SUBMIT_SUCCESS',
  SUBMIT_FAIL: 'DOCTOR/APP_REVIEW/SUBMIT_FAIL',
}

export function showAppReviewModal(appId) {
  return dispatch => {
    dispatch({ type: APP_REVIEW.TOGGLE_MODAL })
    dispatch(fetchAppReview(appId))
  }
}

export function hideAppReviewModal() {
  return { type: APP_REVIEW.TOGGLE_MODAL }
}

export function approveApp(appId) {
  return dispatch => {
    dispatch(submitApp('approve', appId)).then(() => {
      dispatch(hideAppReviewModal())
      dispatch(fetchUpcomingAppointment())
    })
  }
}

export function declineApp(appId) {
  return dispatch => {
    dispatch(submitApp('decline', appId)).then(() => {
      dispatch(hideAppReviewModal())
      dispatch(fetchSchedule())
    })
  }
}

function fetchAppReview(appId) {
  return callAPI({
    url: `/v1/d/appointments/${appId}`,
    method: 'get',
    actions: [
      APP_REVIEW.FETCH,
      APP_REVIEW.FETCH_SUCCESS,
      APP_REVIEW.FETCH_FAIL,
    ],
  })
}

function submitApp(op, appId) {
  return callAPI({
    url: `/v1/d/appointments/${appId}/${op}`,
    method: 'put',
    actions: [
      APP_REVIEW.SUBMIT,
      APP_REVIEW.SUBMIT_SUCCESS,
      APP_REVIEW.SUBMIT_FAIL,
    ],
  })
}
