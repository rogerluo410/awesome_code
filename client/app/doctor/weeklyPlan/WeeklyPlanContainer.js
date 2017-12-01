import { connect } from 'react-redux'
import WeeklyPlan from './WeeklyPlan'
import { fetchWeeklyPlan } from './actions'
import { getWeeklyPlans } from './selectors'

export default connect(getWeeklyPlans, { fetchWeeklyPlan })(WeeklyPlan)
