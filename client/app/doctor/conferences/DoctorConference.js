import React, { Component, PropTypes } from 'react'
import browserHistory from 'react-router/lib/browserHistory'
import {
  DOCTOR_CONF_STATUS,
  isLoading,
  isConnectFailed,
  isParticipantConnected,
  isDisconnected,
} from './status-helpers'
import {
  HangupButton,
  ExitButton,
  VideoPreview,
  UserProfile,
  ConnectionIndicator,
  ConferenceNotification,
  ConferenceTime,
} from 'app/conferences/components'
import Timer from 'app/conferences/Timer'
import cable from 'app/cable'

export default class DoctorConference extends Component {
  static propTypes = {
    token: PropTypes.string,
    patient: PropTypes.shape({
      avatar_url: PropTypes.string.isRequired,
      id: PropTypes.number.isRequired,
      name: PropTypes.string.isRequired,
      type: PropTypes.string.isRequired,
    }),
    conferenceId: PropTypes.number,
    declinedCallFrom: PropTypes.shape({
      appointmentId: PropTypes.number.isRequired,
      patientId: PropTypes.number.isRequired,
    }),
    updateConference: PropTypes.func.isRequired,
    createConference: PropTypes.func.isRequired,
    postNotification: PropTypes.func.isRequired,
    resetConferenceData: PropTypes.func.isRequired,
    receiveNotification: PropTypes.func.isRequired,
    params: PropTypes.shape({
      appointmentId: PropTypes.string.isRequired,
    }),
  }

  constructor(props) {
    super(props)
    this.state = {
      inviteTime: 0,
      status: DOCTOR_CONF_STATUS.waitting,
      errorMessage: '',
      notification: '',
      conferenceTime: '',
    }
  }

  componentDidMount() {
    this.props.createConference({ appointment_id: this.props.params.appointmentId })
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.token === null && this.props.token !== nextProps.token) {
      this.initConversationClient(nextProps.token)
      this.createSubscription()
    }
    if (this.props.declinedCallFrom === null &&
      nextProps.declinedCallFrom !== null) {
      this.patientDeclineCall(nextProps.declinedCallFrom)
    }

    if (nextProps.serverError) {
      this.setConferenceStatus(DOCTOR_CONF_STATUS.failed, nextProps.serverError)
    }
  }

  componentWillUnmount() {
    this.props.resetConferenceData()
    this.removeSubscription()
  }

  setConferenceStatus(currentStatus, message) {
    if (currentStatus === DOCTOR_CONF_STATUS.disconnected ||
        currentStatus === DOCTOR_CONF_STATUS.failed ||
        currentStatus === DOCTOR_CONF_STATUS.rejected ||
        currentStatus === DOCTOR_CONF_STATUS.timeout ||
        currentStatus === DOCTOR_CONF_STATUS.cancelled) {
      this.disconnectConversation()

      if (currentStatus === DOCTOR_CONF_STATUS.disconnected) {
        this.setState({ notification: 'Consultation finished.' })
      } else if (currentStatus === DOCTOR_CONF_STATUS.rejected) {
        this.setState({ notification: 'Patient rejected the call.' })
      } else if (currentStatus === DOCTOR_CONF_STATUS.timeout) {
        this.setState({ notification: 'No response from the patient, please try again.' })
      } else if (currentStatus === DOCTOR_CONF_STATUS.cancelled) {
        this.setState({ notification: 'You canceled the consultation.' })
      }
    }
    this.setState({ status: currentStatus })
    if (message) {
      this.setState({ errorMessage: message })
    }
    this.updateConference(currentStatus)
  }

  setConferenceTime(time) {
    this.setState({ conferenceTime: time })
  }

  createSubscription() {
    const { receiveNotification } = this.props

    this.subscription = cable.subscriptions.create('DeclineCallChannel', {
      received(json) {
        receiveNotification(json)
      },
    })
  }

  removeSubscription() {
    if (this.subscription) {
      this.subscription.unsubscribe()
      delete this.subscription
    }
  }

  patientDeclineCall(declineInfo) {
    // eslint-disable-next-line
    if (declineInfo.appointmentId == this.props.params.appointmentId && declineInfo.patientId == this.props.patient.id) {
      this.setConferenceStatus(DOCTOR_CONF_STATUS.rejected)
    }
  }

  updateConference(status) {
    const params = {}
    let updateFlag = true
    switch (status) {
      case DOCTOR_CONF_STATUS.rejected:
        params.update_type = 'status'
        params.status = 'cancelled_by_patient'
        break
      case DOCTOR_CONF_STATUS.cancelled:
        params.update_type = 'status'
        params.status = 'cancelled_by_doctor'
        break
      case DOCTOR_CONF_STATUS.timeout:
        params.update_type = 'status'
        params.status = 'timeout'
        break
      case DOCTOR_CONF_STATUS.participantConnected:
        params.update_type = 'time'
        params.time_type = 'start_time'
        params.twilio_id = this.twilio_id
        break
      case DOCTOR_CONF_STATUS.disconnected:
        params.update_type = 'time'
        params.time_type = 'end_time'
        params.twilio_id = this.twilio_id
        break
      default:
        updateFlag = false
    }
    if (updateFlag) {
      this.props.updateConference(this.props.conferenceId, { data: params })
    }
  }

  disconnectConversation() {
    if (this.activeConversation) {
      this.activeConversation.disconnect()
    }
    this.stopMedia()
  }

  initConversationClient(token) {
    this.accessManager = new Twilio.AccessManager(token)
    this.client = new Twilio.Conversations.Client(this.accessManager)
    this.setConferenceStatus(DOCTOR_CONF_STATUS.ready)

    this.client.listen().then(() => {
      this.clientConnected()
    }, (err) => {
      this.setConferenceStatus(DOCTOR_CONF_STATUS.failed, err.message)
    })
  }

  clientConnected() {
    this.showLocalVideo().then(() => {
      // eslint-disable-next-line no-console
      console.log('clientConnected===========')
      this.invitePatientToConversation()
    }, () => {
      this.hangup()
    })
  }

  showLocalVideo() {
    if (!this.previewMedia) {
      this.previewMedia = new Twilio.Conversations.LocalMedia()
    }
    return Twilio.Conversations.getUserMedia().then((mediaStream) => {
      this.previewMedia.addStream(mediaStream)
      this.previewMedia.attach('#local-media')
    })
  }

  invitePatientToConversation() {
    // eslint-disable-next-line no-console
    console.log('invitePatientToConversation=========')
    if (this.activeConversation) {
      this.activeConversation.invite(this.props.patient.id)
    } else {
      const options = {}
      if (this.previewMedia) {
        options.localMedia = this.previewMedia
      }

      this.invite(options)
    }
  }

  invite(options) {
    // eslint-disable-next-line no-console
    console.log('invite============')
    if (this.state.inviteTime === 0) {
      this.inviteBeginTime = new Date()
    }
    this.state.inviteTime += 1

    this.client.inviteToConversation(this.props.patient.id, options).then((conversation) => {
      this.conversationStarted(conversation)
    }, (err) => {
      if (err.name === 'CONVERSATION_INVITE_FAILED' &&
        (new Date() - this.inviteBeginTime) / 1000 < 30) {
        if (this.state.inviteTime === 1) {
          this.props.postNotification({
            data: {
              appointment_id: this.props.params.appointmentId,
            },
          })
        }
        return this.invite(options)
      }
      return this.handleInviteError(err)
    })
  }

  conversationStarted(conversation) {
    this.twilio_id = conversation.sid
    this.activeConversation = conversation

    conversation.on('participantConnected', (participant) => {
      participant.media.attach('#remote-media')
      this.setConferenceStatus(DOCTOR_CONF_STATUS.participantConnected)
    })

    conversation.on('participantDisconnected', () => {
      this.activeConversation = null
      this.setConferenceStatus(DOCTOR_CONF_STATUS.disconnected)
    })

    conversation.on('ended', () => {
      this.setConferenceStatus(DOCTOR_CONF_STATUS.disconnected)
    })

    conversation.on('participantFailed', () => {
      this.setConferenceStatus(DOCTOR_CONF_STATUS.failed,
        'Patient failed to join the conference, please try again.')
    })
  }

  handleInviteError(err) {
    switch (err.name) {
      case 'CONVERSATION_INVITE_REJECTED':
        this.setConferenceStatus(DOCTOR_CONF_STATUS.rejected)
        break
      case 'CONVERSATION_INVITE_FAILED':
        this.setConferenceStatus(DOCTOR_CONF_STATUS.failed,
          'Call failed, please try again.')
        break
      case 'CONVERSATION_INVITE_CANCELED':
        this.setConferenceStatus(DOCTOR_CONF_STATUS.cancelled)
        break
      default:
        this.setConferenceStatus(DOCTOR_CONF_STATUS.failed, err.message)
    }
  }

  cancelVideoCall() {
    this.setConferenceStatus(DOCTOR_CONF_STATUS.cancelled)
  }

  hangup = () => {
    if (this.activeConversation) {
      this.disconnectConversation()
    } else {
      if (this.invitation) {
        this.invitation.cancel()
      } else {
        this.cancelVideoCall()
      }
    }
  }

  stopMedia() {
    if (this.previewMedia) {
      this.previewMedia.stop()
    }
  }

  exit = () => {
    browserHistory.goBack()
  }

  renderButtons() {
    return (
      <div>
        {this.renderHangupButton()}
        {this.renderExitButton()}
      </div>
    )
  }

  renderHangupButton() {
    if (!isLoading(this.state.status) && !isParticipantConnected(this.state.status)) return null
    return (
      <HangupButton clickEvent={this.hangup} />
    )
  }

  renderExitButton() {
    if (!isConnectFailed(this.state.status) && !isDisconnected(this.state.status)) return null
    return (
      <ExitButton clickEvent={this.exit} />
    )
  }

  renderVideoPreview() {
    if (!isLoading(this.state.status) && !isParticipantConnected(this.state.status)) return null
    return (
      <VideoPreview />
    )
  }

  renderUserInfo() {
    if (!isLoading(this.state.status) &&
        !isConnectFailed(this.state.status) &&
        !isDisconnected(this.state.status)) {
      return null
    }
    if (this.props.patient === null) return null
    return (
      <UserProfile user={this.props.patient} />
    )
  }

  renderCallingIndicator() {
    if (!isLoading(this.state.status)) return null
    return (
      <ConnectionIndicator />
    )
  }

  renderErrorMessage() {
    if (!isConnectFailed(this.state.status)) return null
    if (this.state.notification) return null
    return (
      <ConferenceNotification message={this.state.errorMessage} />
    )
  }

  renderNotification() {
    if (this.state.notification) {
      return (
        <ConferenceNotification message={this.state.notification} />
      )
    }
    return null
  }

  renderConferenceTime() {
    if (this.state.conferenceTime) {
      return (
        <ConferenceTime conferenceTime={this.state.conferenceTime} />
      )
    }
    return null
  }

  renderTimer() {
    if (!isParticipantConnected(this.state.status)) return null
    return (
      <Timer
        totalCounterTime={600}
        timerStopCallback={(time) => { this.setConferenceTime(time) }}
      />
    )
  }

  render() {
    return (
      <div className="conference-container">
        {this.renderUserInfo()}
        {this.renderCallingIndicator()}
        {this.renderErrorMessage()}
        {this.renderNotification()}
        {this.renderButtons()}
        {this.renderVideoPreview()}
        {this.renderTimer()}
        {this.renderConferenceTime()}
      </div>
    )
  }
}
