import React, { PropTypes, Component } from 'react'
import { Glyphicon } from 'react-bootstrap'
import Loading from '../workspace/Loading'
import MedicalCertificateForm from './MedicalCertificateForm'

export default class MedicalCertificate extends Component {
  static propTypes = {
    appointmentId: PropTypes.string.isRequired,
    isFetching: PropTypes.bool.isRequired,
    medicalCertificate: PropTypes.object,
    uploadMedicalCertificate: PropTypes.func.isRequired,
    fetchMedicalCertificate: PropTypes.func.isRequired,
    destroy: PropTypes.func.isRequired,
  }

  componentDidMount() {
    this.props.fetchMedicalCertificate(this.props.appointmentId)
  }

  destroy = () => {
    this.props.destroy(this.props.appointmentId)
  }

  render() {
    const { uploadMedicalCertificate, appointmentId, medicalCertificate } = this.props
    return (
      <div>
        <h6 className="medical">
          Upload medical certificates
        </h6>
        <div className="u-filescontent">
          {renderOne(this.props, this.destroy)}
          <MedicalCertificateForm
            onDrop={uploadMedicalCertificate}
            appointmentId={appointmentId}
            medicalCertificate={medicalCertificate}
          />
        </div>
      </div>
    )
  }
}

function renderOne(props, destroy) {
  // eslint-disable-next-line react/prop-types
  const { isFetching, medicalCertificate } = props

  if (isFetching) return <Loading />
  if (!medicalCertificate) return <div>No medical certificate currently</div>

  return (
    <div>
      <div>
        <a className="is-paperclip">
          <Glyphicon glyph="paperclip" />
        </a>
        <a className="is-filename" href={medicalCertificate.fileUrl}>
          {medicalCertificate.fileIdentifier}
        </a>
        <a
          className="is-remove"
          onClick={destroy}
        >
          remove
        </a>
      </div>
    </div>
  )
}
