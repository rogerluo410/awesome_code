import React, { Component, PropTypes } from 'react'
import browserHistory from 'react-router/lib/browserHistory'
import { NavDropdown, MenuItem, Glyphicon } from 'react-bootstrap'
import cable from '../cable'
import NotificationList from './NotificationList'

export default class NotificationCenter extends Component {
  static propTypes = {
    notificationList: PropTypes.array.isRequired,
    fetchNotifications: PropTypes.func.isRequired,
    linkToGoToResource: PropTypes.func.isRequired,
    loadMore: PropTypes.func.isRequired,
    nextCursor: PropTypes.number,
    badge: PropTypes.number.isRequired,
    receiveNotification: PropTypes.func.isRequired,
  }

  componentDidMount() {
    this.props.fetchNotifications()
    this.createSubscription()
  }

  componentWillUnmount() {
    this.removeSubscription()
  }

  createSubscription() {
    const { receiveNotification } = this.props

    this.subscription = cable.subscriptions.create('NotificationChannel', {
      received(json) {
        receiveNotification(json.data)
      },
    })
  }

  removeSubscription() {
    this.subscription.unsubscribe()
    delete this.subscription
  }

  handleToNoficationList = () => {
    browserHistory.push('/notifications')
  }

  handleLoadMore = () => {
    this.props.loadMore(this.props.nextCursor)
  }

  gotoResource = (notification) => {
    this.props.linkToGoToResource(notification)
  }

  render() {
    return (
      <NavDropdown
        id="notification-center"
        title={<span><Glyphicon glyph="bell" /> {this.props.badge}</span>}
      >
        <div className="notification-menu">
          <MenuItem header>Notificationts</MenuItem>
          <NotificationList
            notificationList={this.props.notificationList}
            handleLoadMore={this.handleLoadMore}
            nextCursor={this.props.nextCursor}
            gotoResource={this.gotoResource}
          />
        </div>

        <MenuItem className="list-group-item" onClick={this.handleToNoficationList}>
          See All
        </MenuItem>
      </NavDropdown>
    )
  }
}
