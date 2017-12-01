import { fetchNotifications, linkToGoToResource, loadMore } from './actions'
import { connect } from 'react-redux'
import NotificationPage from './NotificationPage'

function mapStateToProps(state) {
  const { notificationsById, ids: listIds, nextCursor, isFetching } = state.notifications
  const notificationList = listIds.map(id => notificationsById[id])

  return { notificationList, nextCursor, isFetching }
}

export default connect(
  mapStateToProps,
  { fetchNotifications, linkToGoToResource, loadMore }
)(NotificationPage)
