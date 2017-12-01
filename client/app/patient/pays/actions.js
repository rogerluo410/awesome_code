import api from 'app/api/api'
import { addFlashMessage } from 'app/flash/actions'
import { fetchCheckouts, showNewCheckoutPayModal } from '../checkouts/actions'
import { appointmentPaid } from '../appointments/actions'

export const PAYS = {
  SET_MODAL_VISIABLE: 'PATIENT/PAYS/SET_MODAL_VISIABLE',
  SUBMIT_ENABLED: 'PATIENT/PAYS/SUBMIT_ENABLED',
}

export function showCheckoutModal() {
  return dispatch => {
    dispatch(closeModal())
    dispatch(showNewCheckoutPayModal())
  }
}

export function showPayModal(saveCheckout = null) {
  return dispatch => {
    if (!saveCheckout) {
      dispatch(fetchCheckouts())
    }
    dispatch(toggleModal())
  }
}

export function closeModal() {
  return {
    type: PAYS.SET_MODAL_VISIABLE,
    payload: false,
  }
}

export function savePay(data, dispatch) {
  dispatch(responseSave())
  return api.put(`/v1/p/appointments/${data.appointmentId}/pay`, {
    data: { checkout_id: data.checkoutId },
  }).then(resp => {
    dispatch(saveSuccess())
    dispatch(appointmentPaid(resp))
    dispatch(closeModal())
    dispatch(addFlashMessage({
      message: 'Paid success',
      level: 'success',
    }))
  }, err => {
    dispatch(saveFaild())
    dispatch(toggleModal())
    dispatch(addFlashMessage({
      message: err.errorData.message,
      level: 'error',
    }))
  })
}

function responseSave() {
  return {
    type: PAYS.SUBMIT_ENABLED,
    payload: true,
  }
}

function saveFaild() {
  return {
    type: PAYS.SUBMIT_ENABLED,
    payload: false,
  }
}

function saveSuccess() {
  return {
    type: PAYS.SUBMIT_ENABLED,
    payload: false,
  }
}

function toggleModal() {
  return {
    type: PAYS.SET_MODAL_VISIABLE,
    payload: true,
  }
}
