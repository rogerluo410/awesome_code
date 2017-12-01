import React, { PropTypes } from 'react'
import { Modal } from 'react-bootstrap'
import CommentItem from './CommentItem'
import CommentForm from './CommentForm'

CommentListModal.propTypes = {
  visiable: PropTypes.bool.isRequired,
  isFetching: PropTypes.bool.isRequired,
  appointmentId: PropTypes.string.isRequired,
  currentUserId: PropTypes.number.isRequired,
  comments: PropTypes.array.isRequired,
  cancel: PropTypes.func.isRequired,
  save: PropTypes.func.isRequired,
}

export default function CommentListModal(props) {
  const { visiable, cancel, appointmentId, save } = props
  const initialValues = {
    body: '',
    appointmentId,
  }

  return (
    <Modal show={visiable} onHide={cancel}>
      <Modal.Header closeButton>
        <Modal.Title>Comments</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <div className="modal-body doc-comments">
          {renderList(props)}
          <div className="row">
            <CommentForm
              onSubmit={save}
              initialValues={initialValues}
            />
          </div>
        </div>
      </Modal.Body>
      <Modal.Footer>
      </Modal.Footer>
    </Modal>
  )
}


function renderList(props) {
  // eslint-disable-next-line react/prop-types
  const { isFetching, comments, currentUserId } = props

  if (isFetching) return <div>Loading...</div>

  return (
    <div>
      {comments.map(comment =>
        <CommentItem
          key={comment.id}
          comment={comment}
          currentUserId={currentUserId}
        />
      )}
    </div>
  )
}
