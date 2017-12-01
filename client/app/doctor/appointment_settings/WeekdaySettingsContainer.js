import { connect } from 'react-redux'
import { getCurrentWeekday } from 'app/timeZone/selectors'
import WeekdaySettings from './WeekdaySettings'
import { getWeekdayPlanSelector } from './selectors'
import { unableEditPlan } from './actions'

function mapStateToProps(state, ownProps) {
  return {
    ...getWeekdayPlanSelector(state, ownProps),
    currentWeekday: getCurrentWeekday(state),
  }
}

export default connect(mapStateToProps, { unableEditPlan })(WeekdaySettings)
