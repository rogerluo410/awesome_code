import React, { PropTypes } from 'react'
import { MenuItem } from 'react-bootstrap'
import NotificationItem from './NotificationItem'

NotificationList.propTypes = {
  gotoResource: PropTypes.func.isRequired,
  notificationList: PropTypes.array.isRequired,
  handleLoadMore: PropTypes.func.isRequired,
  nextCursor: PropTypes.number,
}

export default function NotificationList(props) {
  return (
    <div>
      {props.notificationList.map(notification =>
        <NotificationItem
          key={notification.id}
          notification={notification}
          gotoResource={props.gotoResource}
        />
      )}

      {props.nextCursor === null ||
        <MenuItem className="list-group-item" key={props.nextCursor}>
          <div className="media">
            <div className="media-body">
              <span
                onClick={props.handleLoadMore}
                className="btn btn-primary"
              >
                load-more
              </span>
            </div>
          </div>
        </MenuItem>
      }
    </div>
  )
}
