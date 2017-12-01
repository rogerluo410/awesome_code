import { camelizeKeys } from 'humps'
import { arrayToHash } from '../utils/common'
import { NOTIFICATIONS } from './actions'

const initState = {
  notificationsById: {},
  ids: [],
  isFetching: false,
  badge: 0,
  nextCursor: null,
  isLoadMore: false,
}

export default function notificationsReducer(state = initState, action) {
  switch (action.type) {
    case NOTIFICATIONS.REQUEST:
      return { ...state, isFetching: true }
    case NOTIFICATIONS.LOAD_MORE:
      return { ...state, isLoadMore: true }
    case NOTIFICATIONS.SUCCESS: {
      const notifications = camelizeKeys(action.payload)

      const notificationsById = {
        ...state.notificationsById,
        ...arrayToHash(notifications),
      }

      const notificationIds = notifications.map(i => i.id)

      const newIds = state.isLoadMore
        ? state.ids.concat(notificationIds)
        : notificationIds

      return {
        ...state,
        notificationsById,
        ids: newIds,
        isFetching: false,
        isLoadMore: false,
        ...camelizeKeys(action.meta),
      }
    }
    case NOTIFICATIONS.FAILURE:
      return { ...state, isFetching: false, isLoadMore: false }
    case NOTIFICATIONS.MARK_READ: {
      const newState = updateNotificationsById(state, camelizeKeys(action.payload.notification))
      return { ...newState, badge: action.payload.badge }
    }
    case NOTIFICATIONS.RECEIVE: {
      const newState = updateNotificationsById(state, camelizeKeys(action.payload))
      const ids = [action.payload.id, ...newState.ids]
      return { ...newState, ids, badge: state.badge + 1 }
    }
    default:
      return state
  }
}

function updateNotificationsById(state, notification) {
  const notificationsById = {
    ...state.notificationsById,
    [notification.id]: notification,
  }
  return { ...state, notificationsById }
}
