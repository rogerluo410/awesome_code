import React, { PropTypes } from 'react'
import Time from 'app/timeZone/Time'

CommentItem.propTypes = {
  comment: PropTypes.shape({
    senderId: PropTypes.number.isRequired,
    senderName: PropTypes.string.isRequired,
    body: PropTypes.string.isRequired,
  }),
  currentUserId: PropTypes.number.isRequired,
}

export default function CommentItem(props) {
  const { comment, currentUserId } = props
  const me = currentUserId === comment.senderId
  const active = me ? 'u-commentsbody is-owner' : 'u-commentsbody'
  const senderName = me ? 'ME' : comment.senderName
  return (
    <div className={active}>
      <a className="comment-author">
        {senderName}
      </a>
      <div className="comment-body">
        <p>{comment.body}
          <span className="comment-time">
            <Time value={comment.createdAt} format="YYYY-MM-DD HH:MM" />
          </span>
        </p>
      </div>
    </div>
  )
}
