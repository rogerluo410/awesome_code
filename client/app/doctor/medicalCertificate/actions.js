import { callAPI } from 'app/api/actions'
import api from 'app/api/api'
import { addFlashMessage } from 'app/flash/actions'

export const MEDICAL_CERTIFICATE = {
  FETCH: 'DOCTOR/MEDICAL_CERTIFICATE/FETCH',
  FETCH_SUCCESS: 'DOCTOR/MEDICAL_CERTIFICATE/FETCH_SUCCESS',
  FETCH_FAILURE: 'DOCTOR/MEDICAL_CERTIFICATE/FETCH_FAILURE',
  SAVE: 'DOCTOR/MEDICAL_CERTIFICATE/SAVE',
  SAVE_SUCCESS: 'DOCTOR/MEDICAL_CERTIFICATE/SAVE_SUCCESS',
  SAVE_FAILURE: 'DOCTOR/MEDICAL_CERTIFICATE/SAVE_FAILURE',
  DESTROY_SUCCESS: 'DOCTOR/MEDICAL_CERTIFICATE/DESTROY_SUCCESS',
}

export function fetchMedicalCertificate(appointmentId) {
  return callAPI({
    url: `/v1/d/appointments/${appointmentId}/medical_certificate`,
    method: 'get',
    actions: [
      MEDICAL_CERTIFICATE.FETCH,
      MEDICAL_CERTIFICATE.FETCH_SUCCESS,
      MEDICAL_CERTIFICATE.FETCH_FAILURE,
    ],
  })
}

export function uploadMedicalCertificate(appointmentId, file, dispatch) {
  return dispatch(uploadMedicalCertificateCall(appointmentId, file))
    .then(() => {
      dispatch(addFlashMessage({
        message: 'upload medical_certificate success',
        level: 'success',
      }))
    }, err => {
      dispatch(addFlashMessage({
        message: err.message,
        level: 'error',
      }))
    })
}

export function destroyMedCertificate(appointmentId) {
  return dispatch => {
    api.delete(
      `/v1/d/appointments/${appointmentId}/medical_certificate`
    ).then(resp => {
      dispatch(destroySuccess(resp))
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

function uploadMedicalCertificateCall(appointmentId, file) {
  const data = new FormData()
  data.append('file', file[0])

  return callAPI({
    url: `/v1/d/appointments/${appointmentId}/medical_certificate`,
    data,
    method: 'post',
    actions: [
      MEDICAL_CERTIFICATE.SAVE,
      MEDICAL_CERTIFICATE.SAVE_SUCCESS,
      MEDICAL_CERTIFICATE.SAVE_FAILURE,
    ],
  })
}

function destroySuccess() {
  return {
    type: MEDICAL_CERTIFICATE.DESTROY_SUCCESS,
  }
}
