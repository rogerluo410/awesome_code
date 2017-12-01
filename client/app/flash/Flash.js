import React, { Component, PropTypes } from 'react'
import isEmpty from 'lodash/isEmpty'
import NotificationSystem from 'react-notification-system'

export default class Flash extends Component {
  static propTypes = {
    flash: PropTypes.object,
  }

  componentWillReceiveProps(newProps) {
    if (isEmpty(newProps.flash)) return
    this.refs.notificationSystem.addNotification(newProps.flash)
  }

  render() {
    return (
      <NotificationSystem ref="notificationSystem" />
    )
  }
}
