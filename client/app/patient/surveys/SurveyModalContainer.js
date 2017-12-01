import { connect } from 'react-redux'
import { updateSurvey, closeModalAndRedirect } from './actions'
import SurveyModal from './SurveyModal'

function mapStateToProps(state) {
  return {
    isFetching: state.patient.surveys.isFetching,
    survey: state.patient.surveys.survey,
    reasons: state.patient.surveys.reasons,
    visiable: state.patient.surveys.visiable,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    save: (data) => updateSurvey(data, dispatch),
    cancel: () => dispatch(closeModalAndRedirect()),
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(SurveyModal)
