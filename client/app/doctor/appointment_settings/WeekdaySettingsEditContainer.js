import { connect } from 'react-redux'
import WeekdaySettingsEdit from './WeekdaySettingsEdit'
import { updateAppointmentSettings } from './actions'
import { getWeekdayPlanSelector } from './selectors'

function mapStateToProps(state, ownProps) {
  return getWeekdayPlanSelector(state, ownProps)
}

export default connect(mapStateToProps, { updateAppointmentSettings })(WeekdaySettingsEdit)
