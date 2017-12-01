import { connect } from 'react-redux'
import { getActiveAppointmentSelector } from '../appointments/selectors'
import { getCheckoutsSelector } from '../checkouts/selectors'
import { savePay, closeModal, showCheckoutModal } from './actions'
import PayModal from './PayModal'


function mapStateToProps(state) {
  const { appointment } = getActiveAppointmentSelector(state)

  return {
    visiable: state.patient.pays.visiable,
    submitting: state.patient.pays.submitting,
    appointment,
    ...getCheckoutsSelector(state),
  }
}

function mapDispatchToProps(dispatch) {
  return {
    save: (data) => savePay(data, dispatch),
    cancel: () => dispatch(closeModal()),
    showCheckoutModal: () => dispatch(showCheckoutModal()),
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(PayModal)
