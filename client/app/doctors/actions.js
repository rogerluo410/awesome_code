import api from 'app/api/api'
import { paginateSuccessAction } from 'app/shared/pagination/helpers'

export const DOCTORS = {
  REQUEST: 'DOCTORS/REQUEST',
  SUCCESS: 'DOCTORS/SUCCESS',
  FAILURE: 'DOCTORS/FAILURE',
}

function fetchDoctorsRequest() {
  return { type: DOCTORS.REQUEST }
}

const fetchDoctorsSuccess = paginateSuccessAction({ action: DOCTORS.SUCCESS, camelizeData: false })

function fetchDoctorsFail(err) {
  return {
    type: DOCTORS.FAILURE,
    payload: err,
    error: true,
  }
}

function fetchDoctors(params) {
  return dispatch => {
    fetchDoctorsCore(dispatch, params)
  }
}

function fetchDoctorsCore(dispatch, params) {
  dispatch(fetchDoctorsRequest())
  api.get('/v1/doctors', { params }).then(resp => {
    dispatch(fetchDoctorsSuccess(resp))
  }).catch(err => {
    dispatch(fetchDoctorsFail(err))
  })
}

export {
  fetchDoctors,
}
