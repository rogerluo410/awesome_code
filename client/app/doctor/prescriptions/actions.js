import { callAPI } from 'app/api/actions'
import api from 'app/api/api'
import { addFlashMessage } from 'app/flash/actions'

export const PRESCRIPTIONS = {
  FETCH: 'DOCTOR/PRESCRIPTIONS/FETCH',
  FETCH_SUCCESS: 'DOCTOR/PRESCRIPTIONS/FETCH_SUCCESS',
  FETCH_FAILURE: 'DOCTOR/PRESCRIPTIONS/FETCH_FAILURE',
  SAVE: 'DOCTOR/PRESCRIPTIONS/SAVE',
  SAVE_SUCCESS: 'DOCTOR/PRESCRIPTIONS/SAVE_SUCCESS',
  SAVE_FAILURE: 'DOCTOR/PRESCRIPTIONS/SAVE_FAILURE',
  DESTROY: 'DOCTOR/PRESCRIPTIONS/DESTROY',
  DESTROY_SUCCESS: 'DOCTOR/PRESCRIPTIONS/DESTROY_SUCCESS',
  DESTROY_FAILURE: 'DOCTOR/PRESCRIPTIONS/DESTROY_FAILURE',
}

export function fetchPrescriptions(appointmentId) {
  return callAPI({
    url: `/v1/d/appointments/${appointmentId}/prescriptions`,
    method: 'get',
    actions: [
      PRESCRIPTIONS.FETCH,
      PRESCRIPTIONS.FETCH_SUCCESS,
      PRESCRIPTIONS.FETCH_FAILURE,
    ],
  })
}

export function uploadPrescription(appointmentId, file, dispatch) {
  return dispatch(
    uploadPrescriptionCall(appointmentId, file)
  ).then(() => {
    dispatch(addFlashMessage({
      message: 'upload prescriptions success',
      level: 'success',
    }))
  }, err => {
    dispatch(addFlashMessage({
      message: err.message,
      level: 'error',
    }))
  })
}

export function destroyPrescription(data) {
  const { appointmentId, prescriptionId } = data

  return dispatch => {
    api.delete(
      `/v1/d/appointments/${appointmentId}/prescriptions/${prescriptionId}`
    ).then(resp => {
      dispatch(destroySuccess(prescriptionId, resp))
      dispatch(addFlashMessage({
        message: 'Delete prescription success',
        level: 'success',
      }))
    }, err => {
      dispatch(addFlashMessage({
        message: err.message,
        level: 'error',
      }))
    })
  }
}

function uploadPrescriptionCall(appointmentId, file) {
  const data = new FormData()
  data.append('file', file[0])

  return callAPI({
    url: `/v1/d/appointments/${appointmentId}/prescriptions`,
    data,
    method: 'post',
    actions: [
      PRESCRIPTIONS.SAVE,
      PRESCRIPTIONS.SAVE_SUCCESS,
      PRESCRIPTIONS.SAVE_FAILURE,
    ],
  })
}

function destroySuccess(prescriptionId) {
  return {
    type: PRESCRIPTIONS.DESTROY_SUCCESS,
    payload: prescriptionId,
  }
}
