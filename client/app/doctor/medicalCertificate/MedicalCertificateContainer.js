import { connect } from 'react-redux'
import MedicalCertificate from './MedicalCertificate'
import { uploadMedicalCertificate, fetchMedicalCertificate, destroyMedCertificate } from './actions'
import { getMedicalCertificateSelector } from './selectors'

function mapStateToProps(state) {
  return {
    appointmentId: state.doctor.attachments.appointmentId,
    ...getMedicalCertificateSelector(state),
  }
}

function mapDispatchToProps(dispatch) {
  return {
    uploadMedicalCertificate: (appointmentId, file) =>
      uploadMedicalCertificate(appointmentId, file, dispatch),
    fetchMedicalCertificate: (appointmentId) =>
      dispatch(fetchMedicalCertificate(appointmentId)),
    destroy: (appointmentId) => dispatch(
      destroyMedCertificate(appointmentId)
    ),
  }
}

export default connect(mapStateToProps,
  mapDispatchToProps
)(MedicalCertificate)
