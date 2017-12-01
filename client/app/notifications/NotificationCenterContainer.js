import { connect } from 'react-redux'
import { fetchNotifications, linkToGoToResource, loadMore, receiveNotification } from './actions'
import NotificationCenter from './NotificationCenter'


function mapStateToProps(state) {
  const { notificationsById, ids: listIds,
          nextCursor, badge } = state.notifications
  const notificationList = listIds.map(id => notificationsById[id])
  return { notificationList, nextCursor, badge }
}

export default connect(
  mapStateToProps,
  { fetchNotifications, linkToGoToResource, loadMore, receiveNotification }
)(NotificationCenter)

