import { callAPI } from 'app/api/actions'
import api from 'app/api/api'
import { addFlashMessage } from 'app/flash/actions'

export const BANK_ACCOUNT = {
  FETCH: 'DOCTOR/BANK_ACCOUNT/FETCH',
  FETCH_SUCCESS: 'DOCTOR/BANK_ACCOUNT/FETCH_SUCCESS',
  FETCH_FAILURE: 'DOCTOR/BANK_ACCOUNT/FETCH_FAILURE',
  SAVE: 'DOCTOR/BANK_ACCOUNT/SAVE',
  SAVE_SUCCESS: 'DOCTOR/BANK_ACCOUNT/SAVE_SUCCESS',
  SAVE_FAILURE: 'DOCTOR/BANK_ACCOUNT/SAVE_FAILURE',
  DESTROY_SUCCESS: 'DOCTOR/BANK_ACCOUNT/DESTROY_SUCCESS',
  SET_MODAL_VISIABLE: 'DOCTOR/BANK_ACCOUNT/SET_MODAL_VISIABLE',
  TOGGLE_DELETE: 'DOCTOR/BANK_ACCOUNT/TOGGLE_DELETE',
}

export function showBankAccountForm() {
  return {
    type: BANK_ACCOUNT.SET_MODAL_VISIABLE,
    payload: true,
  }
}

export function closeBankAccountForm() {
  return {
    type: BANK_ACCOUNT.SET_MODAL_VISIABLE,
    payload: false,
  }
}

export function fetchBankAccount() {
  return callAPI({
    url: '/v1/d/bank_account',
    method: 'get',
    actions: [
      BANK_ACCOUNT.FETCH,
      BANK_ACCOUNT.FETCH_SUCCESS,
      BANK_ACCOUNT.FETCH_FAILURE,
    ],
  })
}

export function saveBankAccount(dispatch, data) {
  return dispatch(saveBankAccountCall(data))
    .then(() => {
      dispatch(closeBankAccountForm())
      dispatch(addFlashMessage({
        message: 'Add bank card success',
        level: 'success',
      }))
    }, err => {
      dispatch(addFlashMessage({
        message: err.message,
        level: 'error',
      }))
    })
}

function saveBankAccountCall(data) {
  return callAPI({
    url: '/v1/d/bank_account',
    data,
    method: 'post',
    actions: [
      BANK_ACCOUNT.SAVE,
      BANK_ACCOUNT.SAVE_SUCCESS,
      BANK_ACCOUNT.SAVE_FAILURE,
    ],
  })
}


export function destroy() {
  return dispatch => {
    dispatch(toggleDelete())
    api.delete(
      '/v1/d/bank_account'
    ).then(resp => {
      dispatch(destroySuccess(resp))
      dispatch(addFlashMessage({
        message: 'Delete bank_account success',
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

function destroySuccess() {
  return {
    type: BANK_ACCOUNT.DESTROY_SUCCESS,
  }
}

function toggleDelete() {
  return {
    type: BANK_ACCOUNT.TOGGLE_DELETE,
  }
}
