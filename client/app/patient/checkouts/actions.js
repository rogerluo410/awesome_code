import api from 'app/api/api'
import { decamelizeKeys } from 'humps'
import { addFlashMessage } from 'app/flash/actions'
import { showPayModal } from '../pays/actions'

export const CHECKOUTS = {
  FETCH_REQUEST: 'PATIENT/CHECKOUTS/FETCH_REQUEST',
  FETCH_SUCCESS: 'PATIENT/CHECKOUTS/FETCH_SUCCESS',
  FETCH_FAILURE: 'PATIENT/CHECKOUTS/FETCH_FAILURE',
  SET_MODAL_VISIABLE: 'PATIENT/CHECKOUTS/SET_MODAL_VISIABLE',
  SET_MODAL_VISIABLE_PAY: 'PATIENT/CHECKOUTS/SET_MODAL_VISIABLE_PAY',
  SAVE_SUCCESS: 'PATIENT/CHECKOUTS/SAVE_SUCCESS',
  DESTROY_SUCCESS: 'PATIENT/CHECKOUTS/DESTROY_SUCCESS',
  UPDATE_DEFAULT: 'PATIENT/CHECKOUTS/UPDATE_DEFAULT',
}

export function fetchCheckouts() {
  return dispatch => {
    dispatch(fetchCheckoutsRequest())

    api.get('/v1/p/checkouts').then(resp => {
      dispatch(fetchCheckoutsSuccess(resp.data))
    }).catch(err => {
      dispatch(fetchCheckoutsFail(err))
    })
  }
}

export function showNewCheckoutModal() {
  return dispatch => {
    dispatch(toggleModal())
  }
}


export function showNewCheckoutPayModal() {
  return dispatch => {
    dispatch(toggleCheckoutPayModal())
  }
}

export function closeModal() {
  return {
    type: CHECKOUTS.SET_MODAL_VISIABLE,
    payload: false,
  }
}

export function closeToPayModal() {
  return {
    type: CHECKOUTS.SET_MODAL_VISIABLE_PAY,
    payload: false,
  }
}

export function saveCheckout(data, dispatch, toPay = null) {
  const checkout = {
    ...data,
    expYear: Number(data.expYear),
    expMonth: Number(data.expMonth),
  }
  return api.post('/v1/p/checkouts', decamelizeKeys(checkout)).then(resp => {
    dispatch(saveSuccess(resp))
    dispatch(addFlashMessage({
      message: 'Add checkout success',
      level: 'success',
    }))

    if (toPay) {
      dispatch(closeToPayModal())
      dispatch(showPayModal('saveCheckout'))
    } else {
      dispatch(closeModal())
    }
  }, err => {
    dispatch(addFlashMessage({
      message: err.errorData.message,
      level: 'error',
    }))
  })
}

export function destroyCheckout(checkoutId) {
  // eslint-disable-next-line arrow-body-style
  return dispatch => {
    return api.delete(`/v1/p/checkouts/${checkoutId}`).then(resp => {
      dispatch(destroySuccess(checkoutId, resp))
      dispatch(addFlashMessage({
        message: 'Delete checkout success',
        level: 'success',
      }))
    }, err => {
      dispatch(addFlashMessage({
        message: err.errorData.message,
        level: 'error',
      }))
      throw err
    })
  }
}

export function setDefaultCheckout(checkoutId) {
  return dispatch => {
    dispatch(updateDefault(checkoutId))
    api.put(`/v1/p/checkouts/${checkoutId}/set_default`).catch(err => {
      dispatch(addFlashMessage({
        message: err.errorData.message,
        level: 'error',
      }))
    })
  }
}

function fetchCheckoutsRequest() {
  return { type: CHECKOUTS.FETCH_REQUEST }
}

function fetchCheckoutsSuccess(respData) {
  return {
    type: CHECKOUTS.FETCH_SUCCESS,
    payload: respData.data,
  }
}

function fetchCheckoutsFail(err) {
  return {
    type: CHECKOUTS.FETCH_FAILURE,
    payload: err,
    error: true,
  }
}

function toggleModal() {
  return {
    type: CHECKOUTS.SET_MODAL_VISIABLE,
    payload: true,
  }
}

function toggleCheckoutPayModal() {
  return {
    type: CHECKOUTS.SET_MODAL_VISIABLE_PAY,
    payload: true,
  }
}

function saveSuccess(resp) {
  return {
    type: CHECKOUTS.SAVE_SUCCESS,
    payload: resp.data.data,
  }
}

function destroySuccess(checkoutId) {
  return {
    type: CHECKOUTS.DESTROY_SUCCESS,
    payload: checkoutId,
  }
}

function updateDefault(checkoutId) {
  return {
    type: CHECKOUTS.UPDATE_DEFAULT,
    payload: checkoutId,
  }
}
