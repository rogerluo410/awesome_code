export const PATIENT_CONF_STATUS = {
  waitting: 'waitting',
  ready: 'ready',
  notReady: 'notReady',
  cancelled: 'cancelled',
  failed: 'failed',
  rejected: 'rejected',
  connectEnded: 'connectEnded',
  inInvitation: 'inInvitation',
  inConnectting: 'inConnectting',
  participantConnected: 'participantConnected',
  disconnected: 'disconnected',
}

export function isInConnecting(status) {
  return status === PATIENT_CONF_STATUS.inConnectting
}

export function isInInvitation(status) {
  return status === PATIENT_CONF_STATUS.inInvitation
}

export function isLoading(status) {
  return status === PATIENT_CONF_STATUS.waitting || status === PATIENT_CONF_STATUS.ready
}

export function canExit(status) {
  return (isConnectEnd(status) || isConnectFailed(status))
}

export function isConnectEnd(status) {
  return status === PATIENT_CONF_STATUS.connectEnded
}

export function isConnectFailed(status) {
  return (
    status === PATIENT_CONF_STATUS.failed ||
    status === PATIENT_CONF_STATUS.cancelled ||
    status === PATIENT_CONF_STATUS.rejected
  )
}
