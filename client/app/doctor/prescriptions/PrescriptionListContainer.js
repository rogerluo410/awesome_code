import { connect } from 'react-redux'
import PrescriptionList from './PrescriptionList'
import { uploadPrescription, fetchPrescriptions, destroyPrescription } from './actions'
import { getPrescriptionsSelector } from './selectors'

function mapStateToProps(state) {
  return {
    appointmentId: state.doctor.attachments.appointmentId,
    ...getPrescriptionsSelector(state),
  }
}

function mapDispatchToProps(dispatch) {
  return {
    uploadPrescription: (appointmentId, file) => uploadPrescription(
        appointmentId, file, dispatch
      ),
    fetchPrescriptions: (appointmentId) => dispatch(
        fetchPrescriptions(appointmentId)
      ),
    destroy: (data) => dispatch(
        destroyPrescription(data)
      ),
  }
}

export default connect(mapStateToProps,
  mapDispatchToProps
)(PrescriptionList)
