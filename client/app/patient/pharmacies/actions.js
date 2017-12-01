import { routerActions } from 'react-router-redux'
import api from 'app/api/api'
import { callAPI } from 'app/api/actions'
import { addFlashMessage } from 'app/flash/actions'
import { paginateSuccessAction } from 'app/shared/pagination/helpers'

export const PHARMACIES = {
  REQUEST: 'PATIENT/PHARMACIES/REQUEST',
  SUCCESS: 'PATIENT/PHARMACIES/SUCCESS',
  FAILURE: 'PATIENT/PHARMACIES/FAILURE',
  POST: 'PATIENT/PHARMACIES/POST',
  POST_SUCCESS: 'PATIENT/PHARMACIES/POST_SUCCESS',
  POST_FAIL: 'PATIENT/PHARMACIES/POST_FAIL',
}

function fetchPharmaciesRequest() {
  return { type: PHARMACIES.REQUEST }
}

const fetchPharmaciesSuccess = paginateSuccessAction(
  { action: PHARMACIES.SUCCESS, camelizeData: false }
)

function fetchPharmaciesFail(err) {
  return {
    type: PHARMACIES.FAILURE,
    payload: err,
    error: true,
  }
}


function gotoAppointmentDetail(appointmentId) {
  return routerActions.push(`/p/appointments/${appointmentId}`)
}

export function fetchPharmacies(params) {
  return dispatch => {
    fetchPharmaciesCore(dispatch, params)
  }
}

function fetchPharmaciesCore(dispatch, params) {
  dispatch(fetchPharmaciesRequest())
  api.get('/v1/p/pharmacies', { params }).then(resp => {
    dispatch(fetchPharmaciesSuccess(resp))
  }).catch(err => {
    dispatch(fetchPharmaciesFail(err))
  })
}

export function sendToPharmacy(data, dispatch) {
  return dispatch(sendToPharmacyCall(data))
    .then(() => {
      dispatch(gotoAppointmentDetail(data.appointmentId))
      dispatch(addFlashMessage({
        message: 'Send pahrmacy success',
        level: 'success',
      }))
    }, err => {
      dispatch(addFlashMessage({
        message: err.message,
        level: 'error',
      }))
    })
}

function sendToPharmacyCall(data) {
  return callAPI({
    url: `/v1/p/appointments/${data.appointmentId}/prescriptions/deliver`,
    method: 'put',
    data: { pharmacy_id: data.pharmacyId },
    actions: [
      PHARMACIES.POST,
      PHARMACIES.POST_SUCCESS,
      PHARMACIES.POST_FAIL,
    ],
  })
}
