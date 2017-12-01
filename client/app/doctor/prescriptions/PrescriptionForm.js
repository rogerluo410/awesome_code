import React, { Component, PropTypes } from 'react'
import Dropzone from 'react-dropzone'

export default class PrescriptionForm extends Component {
  static propTypes = {
    onDrop: PropTypes.func.isRequired,
    appointmentId: PropTypes.string.isRequired,
  }

  onDrop = (files) => {
    const { onDrop, appointmentId } = this.props

    if (files.length > 1) {
      files.map(file =>
        onDrop(appointmentId, [file])
      )
    } else {
      onDrop(appointmentId, files)
    }
  }

  render() {
    return (
      <div>
        <Dropzone className="none" onDrop={this.onDrop}>
          <p>Drag file to this area<br />
            or<br />
            <a>browse</a>
          </p>
        </Dropzone>
      </div>
    )
  }
}
