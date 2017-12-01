import api from 'app/api/api'
import { addFlashMessage } from 'app/flash/actions'

const PROMPT = {
  RECEIVE: 'PROMPT/RECEIVE',
  CLOSE_MODAL: 'PROMPT/CLOSE_MODAL',
  DECLINE_CALL_REQUEST: 'PROMPT/DECLINE_CALL_REQUEST',
  DECLINE_CALL_SUCCESS: 'PROMPT/DECLINE_CALL_SUCCESS',
  DECLINE_CALL_FAILED: 'PROMPT/DECLINE_CALL_FAILED',
}

function receiveNotification(json) {
  return { type: PROMPT.RECEIVE, payload: json.data }
}

function closeModal() {
  return { type: PROMPT.CLOSE_MODAL }
}

function declineCall(appointmentId) {
  return dispatch => {
    dispatch(declineCallRequest())
    api.post(`/v1/conferences/decline_call/${appointmentId}`).then(() => {
      dispatch(declineCallSuccess())
    }).catch((error) => {
      dispatch(addFlashMessage({
        message: error.data.error.message,
        level: 'error',
      }))
      dispatch(declineCallFailed())
    })
  }
}

function declineCallRequest() {
  return { type: PROMPT.DECLINE_CALL_REQUEST }
}

function declineCallSuccess() {
  return { type: PROMPT.DECLINE_CALL_SUCCESS }
}

function declineCallFailed() {
  return { type: PROMPT.DECLINE_CALL_FAILED }
}

export {
  PROMPT,
  receiveNotification,
  closeModal,
  declineCall,
}
