import React, { Component, PropTypes } from 'react'
import NotificationList from './NotificationList'

export default class NotificationPage extends Component {
  static propTypes = {
    notificationList: PropTypes.array.isRequired,
    fetchNotifications: PropTypes.func.isRequired,
    linkToGoToResource: PropTypes.func.isRequired,
    loadMore: PropTypes.func.isRequired,
    isFetching: PropTypes.bool.isRequired,
    nextCursor: PropTypes.number,
  }

  componentDidMount() {
    if (!this.props.isFetching) {
      this.props.fetchNotifications()
    }
  }

  handleLoadMore = () => {
    this.props.loadMore(this.props.nextCursor)
  }

  gotoResource =(notification) => {
    this.props.linkToGoToResource(notification)
  }

  render() {
    return (
      <div className="u-container u-clearFix">
        <h1>Notification List</h1>
        <NotificationList
          notificationList={this.props.notificationList}
          handleLoadMore={this.handleLoadMore}
          nextCursor={this.props.nextCursor}
          gotoResource={this.gotoResource}
        />
      </div>
    )
  }
}
