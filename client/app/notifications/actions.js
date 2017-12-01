import { routerActions } from 'react-router-redux'
import api from 'app/api/api'

export const NOTIFICATIONS = {
  REQUEST: 'NOTIFICATIONS/REQUEST',
  SUCCESS: 'NOTIFICATIONS/SUCCESS',
  FAILURE: 'NOTIFICATIONS/FAILURE',
  LOAD_MORE: 'NOTIFICATIONS/LOAD_MORE',
  MARK_READ: 'NOTIFICATION/MARK_READ',
  RECEIVE: 'NOTIFICATIONS/RECEIVE',
}

export function loadMore(cursor) {
  return dispatch => {
    dispatch(fetchNotificationsLoadMore())
    dispatch(fetchNotifications({ next_cursor: cursor }))
  }
}

export function fetchNotifications(params) {
  return dispatch => {
    dispatch(fetchNotificationsRequest())

    api.get('/v1/notifications', { params }).then(resp => {
      dispatch(fetchNotificationsSuccess(resp.data))
    }).catch(err => {
      dispatch(fetchNotificationsFail(err))
    })
  }
}

export function linkToGoToResource(notification) {
  return dispatch => {
    if (!notification.isRead) dispatch(markReadNotification(notification.id))
    dispatch(routerActions.push(getResourceUrl(notification)))
  }
}

export function receiveNotification(notification) {
  return { type: NOTIFICATIONS.RECEIVE, payload: notification }
}

function fetchNotificationsRequest() {
  return { type: NOTIFICATIONS.REQUEST }
}

function fetchNotificationsSuccess(respData) {
  return {
    type: NOTIFICATIONS.SUCCESS,
    payload: respData.data,
    meta: respData.meta,
  }
}

function fetchNotificationsFail(err) {
  return {
    type: NOTIFICATIONS.FAILURE,
    payload: err,
    error: true,
  }
}

function fetchNotificationsLoadMore() {
  return { type: NOTIFICATIONS.LOAD_MORE }
}

function markRead(respData) {
  return {
    type: NOTIFICATIONS.MARK_READ,
    payload: respData.data,
  }
}

function markReadNotification(id) {
  return dispatch => {
    api.patch(`/v1/notifications/${id}/mark_read`).then(resp => {
      dispatch(markRead(resp.data))
    })
  }
}

function getResourceUrl(notification) {
  switch (notification.nType) {
    case 'appoint':
    case 'd_consultation_begin':
      return '/d/workspace'
    case 'appoint_accepted':
    case 'p_consultation_begin':
      return '/p/dashboard'
    default:
      return '/notifications'
  }
}
