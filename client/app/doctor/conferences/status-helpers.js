export const DOCTOR_CONF_STATUS = {
  waitting: 'waitting',
  ready: 'ready',
  cancelled: 'cancelled',
  failed: 'failed',
  rejected: 'rejected',
  timeout: 'timeout',
  participantConnected: 'participantConnected',
  disconnected: 'disconnected',
}

export function isLoading(status) {
  return (status === DOCTOR_CONF_STATUS.waitting ||
        status === DOCTOR_CONF_STATUS.ready)
}

export function isConnectFailed(status) {
  return (status === DOCTOR_CONF_STATUS.failed ||
    status === DOCTOR_CONF_STATUS.cancelled ||
    status === DOCTOR_CONF_STATUS.rejected ||
    status === DOCTOR_CONF_STATUS.timeout)
}

export function isParticipantConnected(status) {
  return status === DOCTOR_CONF_STATUS.participantConnected
}

export function isDisconnected(status) {
  return status === DOCTOR_CONF_STATUS.disconnected
}
