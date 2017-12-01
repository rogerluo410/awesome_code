import React, { Component, PropTypes } from 'react'
import { Glyphicon } from 'react-bootstrap'

export default class PrescriptionItem extends Component {
  static propTypes = {
    prescription: PropTypes.shape({
      fileUrl: PropTypes.string.isRequired,
      fileIdentifier: PropTypes.string.isRequired,
    }),
    destroy: PropTypes.func.isRequired,
    appointmentId: PropTypes.string.isRequired,
  }

  remove = () => {
    const { destroy, prescription, appointmentId } = this.props
    const data = {
      appointmentId,
      prescriptionId: prescription.id,
    }

    destroy(data)
  }

  render() {
    const { prescription } = this.props

    return (
      <div>
        <a className="is-paperclip">
          <Glyphicon glyph="paperclip" />
        </a>
        <a className="is-filename" href={prescription.fileUrl}>
          {prescription.fileIdentifier}
        </a>
        <a
          className="is-remove"
          onClick={this.remove}
        >
          remove
        </a>
      </div>
    )
  }
}
