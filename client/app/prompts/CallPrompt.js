import React, { Component, PropTypes } from 'react'
import browserHistory from 'react-router/lib/browserHistory'
import { Modal } from 'react-bootstrap'
import cable from '../cable'

export default class CallPrompt extends Component {
  static propTypes = {
    isSignedIn: PropTypes.bool.isRequired,
    user_type: PropTypes.string.isRequired,
    isShown: PropTypes.bool.isRequired,
    isDisabled: PropTypes.bool.isRequired,
    appointmentId: PropTypes.string,
    doctor: PropTypes.shape({
      avatar_url: PropTypes.string,
      name: PropTypes.string,
    }),
    receiveNotification: PropTypes.func.isRequired,
    closeModal: PropTypes.func.isRequired,
    declineCall: PropTypes.func.isRequired,
  }

  componentDidMount() {
    if (!this.needMount()) return
    this.createSubscription()
  }

  componentWillUnmount() {
    this.removeSubscription()
  }

  createSubscription() {
    const { receiveNotification } = this.props

    this.subscription = cable.subscriptions.create('CallChannel', {
      received(json) {
        receiveNotification(json)
      },
    })
  }

  removeSubscription() {
    this.subscription.unsubscribe()
    delete this.subscription
  }

  needMount() {
    return this.props.isSignedIn && this.props.user_type === 'Patient'
  }

  answer = () => {
    this.props.closeModal()
    browserHistory.push(`/p/conference/${this.props.appointmentId}`)
  }

  decline = () => {
    this.props.declineCall(this.props.appointmentId)
  }

  render() {
    if (!this.needMount()) return null

    return (
      <Modal show={this.props.isShown} onHide={this.props.closeModal}>
        <Modal.Header closeButton>
          <Modal.Title>Incoming Video Call</Modal.Title>
        </Modal.Header>
        <Modal.Body className="u-greybg">
          <img
            className="round-image"
            alt="doctor avatar"
            src={this.props.doctor.avatar_url}
          />
          <div className="call-info">
            <div className="bold-font">Doctor {this.props.doctor.name} </div>
            is calling.
          </div>
        </Modal.Body>
        <Modal.Footer>
          <button
            className="doc-btn btn is-green"
            disabled={this.props.isDisabled}
            onClick={this.answer}
          >
            Answer
          </button>
          <button
            className="doc-btn btn is-red"
            disabled={this.props.isDisabled}
            onClick={this.decline}
          >
            Decline
          </button>
        </Modal.Footer>
      </Modal>
    )
  }
}
