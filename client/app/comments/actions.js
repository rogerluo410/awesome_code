import { decamelizeKeys } from 'humps'
import { reset } from 'redux-form'
import { callAPI } from 'app/api/actions'
import { addFlashMessage } from 'app/flash/actions'

export const COMMENTS = {
  FETCH_REQUEST: 'COMMENTS/FETCH_REQUEST',
  FETCH_SUCCESS: 'COMMENTS/FETCH_SUCCESS',
  FETCH_FAIL: 'COMMENTS/FETCH_FAIL',
  SET_MODAL_VISIABLE: 'COMMENTS/SET_MODAL_VISIABLE',
  SET_APPOINTMENT: 'COMMENTS/SET_APPOINTMENT',
  FETCH_SAVE: 'COMMENTS/FETCH_SAVE',
  SAVE_SUCCESS: 'COMMENTS/SAVE_SUCCESS',
  SAVE_FAIL: 'COMMENTS/SAVE_FAIL',
}

export function fetchComments(appointmentId) {
  return callAPI({
    url: '/v1/comments',
    params: { appointment_id: appointmentId },
    method: 'get',
    actions: [
      COMMENTS.FETCH_REQUEST,
      COMMENTS.FETCH_SUCCESS,
      COMMENTS.FETCH_FAIL,
    ],
  })
}

export function showCommentsModal(appointmentId) {
  return dispatch => {
    dispatch(setAppointmentId(appointmentId))
    dispatch(toggleModal())
    dispatch(fetchComments(appointmentId))
  }
}

export function closeModal() {
  return {
    type: COMMENTS.SET_MODAL_VISIABLE,
    payload: false,
  }
}

export function saveComment(comment, dispatch) {
  return dispatch(saveCommentCall(comment))
    .then(() => {
      dispatch(reset('comment'))
      dispatch(addFlashMessage({
        message: 'Add Comment success',
        level: 'success',
      }))
    }, err => {
      dispatch(addFlashMessage({
        message: err.errorData.message,
        level: 'error',
      }))
    })
}

function saveCommentCall(comment) {
  return callAPI({
    url: '/v1/comments',
    data: decamelizeKeys(comment),
    method: 'post',
    actions: [
      COMMENTS.FETCH_SAVE,
      COMMENTS.SAVE_SUCCESS,
      COMMENTS.SAVE_FAILURE,
    ],
  })
}

function toggleModal() {
  return {
    type: COMMENTS.SET_MODAL_VISIABLE,
    payload: true,
  }
}

function setAppointmentId(appointmentId) {
  return {
    type: COMMENTS.SET_APPOINTMENT,
    payload: appointmentId,
  }
}
