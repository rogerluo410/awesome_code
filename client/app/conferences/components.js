import React, { PropTypes } from 'react'
import { Glyphicon } from 'react-bootstrap'

function HangupButton(props) {
  return (
    <div onClick={props.clickEvent}>
      <a className="hangup-button" ><Glyphicon glyph="phone-alt" /></a>
    </div>
  )
}

HangupButton.propTypes = {
  clickEvent: PropTypes.func.isRequired,
}

function ExitButton(props) {
  return (
    <div onClick={props.clickEvent}>
      <a className="hangup-button" ><Glyphicon glyph="chevron-left" /></a>
    </div>
  )
}

ExitButton.propTypes = {
  clickEvent: PropTypes.func.isRequired,
}

function VideoPreview() {
  return (
    <div>
      <div id="remote-media"></div>
      <div id="local-media"></div>
    </div>
  )
}

function UserProfile(props) {
  return (
    <div>
      <div className="participant-image-container">
        <img
          src={props.user.avatar_url}
          className="participant-image"
          alt="User"
        />
      </div>
      <div className="participant-name">
        {props.user.name}
      </div>
    </div>
  )
}

UserProfile.propTypes = {
  user: PropTypes.shape({
    avatar_url: PropTypes.string.isRequired,
    id: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    type: PropTypes.string.isRequired,
  }),
}

function ConnectionIndicator() {
  return (
    <div>
      <div className="indicator">
        <div id="block_1" className="barlittle"></div>
        <div id="block_2" className="barlittle"></div>
        <div id="block_3" className="barlittle"></div>
        <div id="block_4" className="barlittle"></div>
        <div id="block_5" className="barlittle"></div>
      </div>
    </div>
  )
}

function ConferenceNotification(props) {
  return (
    <div>
      <div className="conversation-notification">
        {props.message}
      </div>
    </div>
  )
}

ConferenceNotification.propTypes = {
  message: PropTypes.string.isRequired,
}

function ConferenceTime(props) {
  return (
    <div className="conversation-time">
      <div className="remain-time-text">Time spend: {props.conferenceTime}</div>
    </div>
  )
}

ConferenceTime.propTypes = {
  conferenceTime: PropTypes.string.isRequired,
}

export {
  HangupButton,
  ExitButton,
  VideoPreview,
  UserProfile,
  ConnectionIndicator,
  ConferenceNotification,
  ConferenceTime,
}
