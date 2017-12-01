export const ATTACHMENTS = {
  SET_MODAL_VISIABLE: 'DOCTOR/ATTACHMENTS/SET_MODAL_VISIABLE',
  SET_APPPOINTMENT: 'DOCTOR/ATTACHMENTS/SET_APPPOINTMENT',
}

export function showPrescriptionsModal(appointmentId) {
  return dispatch => {
    dispatch(setAppointment(appointmentId))
    dispatch(toggleModal())
  }
}

export function closeModal() {
  return {
    type: ATTACHMENTS.SET_MODAL_VISIABLE,
    payload: false,
  }
}

function toggleModal() {
  return {
    type: ATTACHMENTS.SET_MODAL_VISIABLE,
    payload: true,
  }
}

function setAppointment(appointmentId) {
  return {
    type: ATTACHMENTS.SET_APPPOINTMENT,
    payload: appointmentId,
  }
}
