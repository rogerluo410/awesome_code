import React, { Component, PropTypes } from 'react'
import Dropzone from 'react-dropzone'

export default class MedicalCertificateForm extends Component {
  static propTypes = {
    onDrop: PropTypes.func.isRequired,
    appointmentId: PropTypes.string.isRequired,
    medicalCertificate: PropTypes.object,
  }

  onDrop = (file) => {
    this.props.onDrop(this.props.appointmentId, file)
  }

  render() {
    if (this.props.medicalCertificate) return null
    return (
      <div>
        <Dropzone
          className="none"
          onDrop={this.onDrop}
          multiple={false}
        >
          <a className="mt-1 doc-btn is-blueline">Upload</a>
        </Dropzone>
      </div>
    )
  }
}
