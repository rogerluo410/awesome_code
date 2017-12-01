import React, { Component, PropTypes } from 'react'
import { Modal } from 'react-bootstrap'
import Loading from '../workspace/Loading'
import SurveyPanel from '../workspace/SurveyPanel'
import Time from 'app/timeZone/Time'

export default class AppReviewModal extends Component {
  static propTypes = {
    isShown: PropTypes.bool.isRequired,
    isFetching: PropTypes.bool.isRequired,
    isSubmitting: PropTypes.bool.isRequired,
    app: PropTypes.object,
    survey: PropTypes.object,
    hideAppReviewModal: PropTypes.func.isRequired,
    approveApp: PropTypes.func.isRequired,
    declineApp: PropTypes.func.isRequired,
  }

  isApproveDisabled() {
    const { isFetching, isSubmitting, app } = this.props
    return isFetching || isSubmitting || !(app && app.status === 'pending' && app.paid)
  }

  isDeclineDisabled() {
    const { isFetching, isSubmitting, app } = this.props
    return isFetching || isSubmitting || !(app && app.status === 'pending')
  }

  handleApprove = () => {
    this.props.approveApp(this.props.app.id)
  }

  handleDecline = () => {
    this.props.declineApp(this.props.app.id)
  }

  renderTitle() {
    const { isFetching, app } = this.props
    if (isFetching || !app) return 'Appointment'
    return (
      <div>
        {'Appointment at '}
        <Time value={app.periodStartTime} format="HH:mm" />
      </div>
    )
  }

  renderBody() {
    const { isFetching, survey } = this.props
    if (isFetching) return <Loading />
    if (!survey) return null
    return (
      <div className="doc-schedule-body doc-view-body">
        <SurveyPanel survey={survey} />
      </div>
    )
  }

  render() {
    const { isShown, hideAppReviewModal } = this.props

    return (
      <Modal animation={false} show={isShown} onHide={hideAppReviewModal}>
        <Modal.Header closeButton>
          <Modal.Title>
            {this.renderTitle()}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body className="modal-body content u-darkbg is-view">
          {this.renderBody()}
        </Modal.Body>
        <Modal.Footer>
          <div className="col-lg-offset-2 col-md-offset-2 col-lg-4 col-md-4 col-sm-6 col-xs-6">
            <button
              type="button"
              className="btn doc-btn-item bs-btn is-successLight"
              disabled={this.isApproveDisabled()}
              onClick={this.handleApprove}
            >
              Accept
            </button>
          </div>
          <div className="col-lg-4 col-md-4 col-sm-6 col-xs-6">
            <button
              type="button"
              className="btn doc-btn-item bs-btn is-danger"
              disabled={this.isDeclineDisabled()}
              onClick={this.handleDecline}
            >
              Decline
            </button>
          </div>

        </Modal.Footer>
      </Modal>
    )
  }
}
