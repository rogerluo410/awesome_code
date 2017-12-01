import React, { Component, PropTypes } from 'react'
import browserHistory from 'react-router/lib/browserHistory'
import {
  PATIENT_CONF_STATUS,
  isInInvitation,
  isInConnecting,
  isConnectFailed,
  isConnectEnd,
  canExit,
  isLoading,
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
import { Glyphicon } from 'react-bootstrap'

import PatientConferenceFinished from './PatientConferenceFinished'

export default class PatientConference extends Component {
  static propTypes = {
    token: PropTypes.string,
    doctor: PropTypes.shape({
      id: PropTypes.number.isRequired,
      avatar_url: PropTypes.string.isRequired,
      name: PropTypes.string.isRequired,
      type: PropTypes.string.isRequired,
      specialty_name: PropTypes.string.isRequired,
    }),
    startCall: PropTypes.func.isRequired,
    getDoctorProfile: PropTypes.func.isRequired,
    finishConference: PropTypes.func.isRequired,
    refundConference: PropTypes.func.isRequired,
    resetConferenceData: PropTypes.func.isRequired,
    submitting: PropTypes.bool.isRequired,
    params: PropTypes.shape({
      appointmentId: PropTypes.string.isRequired,
    }),
  }

  constructor(props) {
    super(props)

    this.state = {
      status: PATIENT_CONF_STATUS.waitting,
      errorMessage: '',
      notification: '',
      conferenceTime: '',
    }
  }

  componentDidMount() {
    this.props.startCall(this.props.params.appointmentId)
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.token === null && nextProps.token !== null) {
      this.initConversationClient(nextProps.token)
    }

    if (nextProps.serverError) {
      this.setConferenceStatus(PATIENT_CONF_STATUS.failed, nextProps.serverError)
    }
  }

  componentWillUnmount() {
    if (this.client) {
      this.client.unlisten()
    }
    this.props.resetConferenceData()
  }

  onCanceled() {
    this.setConferenceStatus(PATIENT_CONF_STATUS.cancelled)
  }

  setConferenceStatus(currentStatus, message) {
    if (currentStatus === PATIENT_CONF_STATUS.connectEnded ||
        currentStatus === PATIENT_CONF_STATUS.failed ||
        currentStatus === PATIENT_CONF_STATUS.rejected ||
        currentStatus === PATIENT_CONF_STATUS.cancelled) {
      if (this.activeConversation != null) {
        this.disconnect()
      }

      if (currentStatus === PATIENT_CONF_STATUS.connectEnded) {
        this.setState({ notification: 'Consultation finished.' })
      } else if (currentStatus === PATIENT_CONF_STATUS.rejected) {
        this.setState({ notification: 'You rejected the call.' })
      } else if (currentStatus === PATIENT_CONF_STATUS.cancelled) {
        this.setState({ notification: 'Doctor canceled the consultation.' })
      }
    }
    this.setState({ status: currentStatus })
    if (message) {
      this.setState({ errorMessage: message })
    }
  }

  setConferenceTime(time) {
    this.setState({ conferenceTime: time })
  }

  initConversationClient(token) {
    this.accessManager = new Twilio.AccessManager(token)
    this.client = new Twilio.Conversations.Client(this.accessManager)
    this.setConferenceStatus(PATIENT_CONF_STATUS.ready)

    this.client.listen().then(() => {
      this.clientConnected()
    }, (err) => {
      this.errorMessage = err.message
      this.setConferenceStatus(PATIENT_CONF_STATUS.notReady)
    })
  }

  clientConnected() {
    this.client.on('invite', (invitation) => {
      this.props.getDoctorProfile(invitation.from)
      this.invitation = invitation
      this.invitation.on('canceled', () => { this.onCanceled() })
      this.setConferenceStatus(PATIENT_CONF_STATUS.inInvitation)
    })
  }

  acceptInvitation() {
    if (this.invitation) {
      this.setConferenceStatus(PATIENT_CONF_STATUS.inConnectting)
      this.invitation.accept().then((conversation) => {
        this.conversationStarted(conversation)
      }, () => {
        this.handleError()
      })
    }
  }

  conversationStarted(conversation) {
    this.activeConversation = conversation
    conversation.localMedia.attach('#local-media')

    conversation.on('participantConnected', (participant) => {
      participant.media.attach('#remote-media')
    })

    conversation.on('participantDisconnected', () => {
      this.activeConversation = null
      this.setConferenceStatus(PATIENT_CONF_STATUS.connectEnded)
    })

    conversation.on('ended', () => {
      this.activeConversation = null
      this.setConferenceStatus(PATIENT_CONF_STATUS.connectEnded)
    })

    conversation.on('participantFailed', () => {
      this.setConferenceStatus(PATIENT_CONF_STATUS.failed, 'Consultation failed.')
    })
  }

  handleError(err) {
    this.setConferenceStatus(PATIENT_CONF_STATUS.failed, err.message)
  }

  rejectInvitation() {
    if (this.invitation) {
      try {
        this.invitation.reject()
      } catch (e) {
        this.setState({ errorMessage: e.message })
      }
      this.setConferenceStatus(PATIENT_CONF_STATUS.rejected)
    }
  }

  hangup = () => {
    this.setConferenceStatus(PATIENT_CONF_STATUS.connectEnded)
  }

  disconnect() {
    if (this.activeConversation) {
      this.activeConversation.disconnect()
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
    if (!isInConnecting(this.state.status)) return null
    return (
      <HangupButton clickEvent={this.hangup} />
    )
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
    if (!isInConnecting(this.state.status)) return null
    return (
      <Timer
        totalCounterTime={600}
        timerStopCallback={(time) => { this.setConferenceTime(time) }}
      />
    )
  }

  renderExitButton() {
    if (!canExit(this.state.status)) return null
    return (
      <ExitButton clickEvent={this.exit} />
    )
  }

  renderVideoPreview() {
    return (
      <VideoPreview />
    )
  }

  renderUserProfile() {
    if (!isInInvitation(this.state.status) &&
      !isConnectFailed(this.state.status) &&
      !isConnectEnd(this.state.status)) return null
    if (this.props.doctor == null) return null
    return (
      <UserProfile user={this.props.doctor} />
    )
  }

  renderInvitingButtons() {
    if (!isInInvitation(this.state.status)) return null
    return (
      <div className="invited-button-groups">
        <a
          className="conference-accept-button"
          onClick={() => { this.acceptInvitation() }}
        >
          <Glyphicon glyph="earphone" />
        </a>
        <a
          className="conference-reject-button"
          onClick={() => { this.rejectInvitation() }}
        >
          <Glyphicon glyph="phone-alt" />
        </a>
      </div>
    )
  }

  renderCallingIndicator() {
    if (!isInInvitation(this.state.status)) return null
    return (
      <ConnectionIndicator />
    )
  }

  renderErrorMessage() {
    if (!isConnectFailed(this.state.status)) return null
    return (
      <ConferenceNotification message={this.state.errorMessage} />
    )
  }

  renderNotification() {
    if (!canExit(this.state.status)) return null
    if (this.state.notification) {
      return (
        <ConferenceNotification message={this.state.notification} />
      )
    }
    return null
  }

  renderLoading() {
    if (!isLoading(this.state.status)) return null
    return (
      <div>
        <ConnectionIndicator />
        <div className="central-text">Connecting...</div>
      </div>
    )
  }

  renderConferenceComponents() {
    return (
      <div className="conference-container">
        {this.renderLoading()}
        {this.renderUserProfile()}
        {this.renderCallingIndicator()}
        {this.renderInvitingButtons()}
        {this.renderButtons()}
        {this.renderErrorMessage()}
        {this.renderNotification()}
        {this.renderVideoPreview()}
        {this.renderTimer()}
        {this.renderConferenceTime()}
      </div>
    )
  }

  renderCallFinishedPage() {
    const { doctor, submitting, finishConference, refundConference, params } = this.props

    return (
      <PatientConferenceFinished
        submitting={submitting}
        user={doctor}
        appointmentID={params.appointmentId}
        durationTime={this.state.conferenceTime}
        finishConference={finishConference}
        refundConference={refundConference}
      />
    )
  }

  render() {
    if (isConnectEnd(this.state.status)) {
      return this.renderCallFinishedPage()
    }
    return this.renderConferenceComponents()
  }
}
