import { MenuItem } from 'react-bootstrap'
import React, { Component, PropTypes } from 'react'

export default class NotificationItem extends Component {
  static propTypes = {
    notification: PropTypes.shape({
      title: PropTypes.string.isRequired,
      body: PropTypes.string.isRequired,
      isRead: PropTypes.bool.isRequired,
    }).isRequired,
    gotoResource: PropTypes.func.isRequired,
  }

  gotoResource = () => {
    this.props.gotoResource(this.props.notification)
  }

  render() {
    const { notification } = this.props

    return (
      <MenuItem
        className={`list-group-item notification-item ${notification.isRead ? 'is-read' : null}`}
        onClick={this.gotoResource}
      >
        <div className="media">
          <div className="media-body">
            <h5 className="media-heading">{notification.title}</h5>
            <p>{notification.body}</p>
          </div>
          <div className="media-left">
            {notification.isRead || <span className="label label-info label-xs">unread</span>}
          </div>
        </div>
      </MenuItem>
    )
  }
}
