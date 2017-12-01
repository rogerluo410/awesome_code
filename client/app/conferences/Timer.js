import React, { Component, PropTypes } from 'react'
import { secondsToTimeString, secondsToTimeFormat } from './helpers'

export default class Timer extends Component {
  static propTypes = {
    totalCounterTime: PropTypes.number.isRequired,
    timerStopCallback: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)
    this.state = {
      currentCounterTime: this.props.totalCounterTime,
    }
  }

  componentDidMount() {
    this.tick()
    this.interval = setInterval(() => { this.tick() }, 1000)
  }

  componentWillUnmount() {
    clearInterval(this.interval)
    this.props.timerStopCallback(this.getConferenceTime())
  }

  getConferenceTime() {
    return secondsToTimeFormat(this.props.totalCounterTime - this.state.currentCounterTime)
  }

  tick() {
    this.setState({ currentCounterTime: this.state.currentCounterTime - 1 })
    if (this.state.currentCounterTime <= 0) {
      clearInterval(this.interval)
      this.props.timerStopCallback(this.getConferenceTime())
    }
  }

  render() {
    return (
      <div className="timer-container">
        <div className="remain-time-text">Remaining time</div>
        <div className="remain-time-text">
          {secondsToTimeString(this.state.currentCounterTime)}
        </div>
      </div>
    )
  }
}
