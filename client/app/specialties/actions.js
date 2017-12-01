import axios from 'axios'

function fetchSpecialtiesRequest() {
  return { type: 'FETCH_SPECIALTIES_REQUEST' }
}

function fetchSpecialtiesSuccess(respData) {
  return {
    type: 'FETCH_SPECIALTIES_SUCCESS',
    payload: respData.data,
  }
}

function fetchSpecialtiesFail(err) {
  return {
    type: 'FETCH_SPECIALTIES_FAIL',
    payload: err,
    error: true,
  }
}

function fetchSpecialties() {
  return dispatch => {
    dispatch(fetchSpecialtiesRequest())

    axios.get('/v1/specialties').then(resp => {
      dispatch(fetchSpecialtiesSuccess(resp.data))
    }).catch(err => {
      dispatch(fetchSpecialtiesFail(err))
    })
  }
}

export {
 fetchSpecialties,
}
