import React, { Component, PropTypes } from 'react'
import Link from 'react-router/lib/Link'
import Loading from '../workspace/Loading'
import NoRecord from '../workspace/NoRecord'
import { getWeekdayName } from 'app/utils/common'

export default class WeeklyPlan extends Component {
  static propTypes = {
    isFetching: PropTypes.bool.isRequired,
    weeklyPlans: PropTypes.array,
    fetchWeeklyPlan: PropTypes.func.isRequired,
  }

  componentWillMount() {
    this.props.fetchWeeklyPlan()
  }

  renderBody() {
    const { isFetching, weeklyPlans } = this.props
    if (isFetching) return <Loading />
    if (!weeklyPlans.length) return <NoRecord>No weekly plan</NoRecord>

    return (
      <WeeklyPlanTable plans={weeklyPlans} />
    )
  }

  render() {
    return (
      <div className="doc-schedule">
        <div className="doc-schedule-header">
          <div className="title">Weekly Availability</div>
          <div className="u-link is-blue">
            <Link to="/d/appointment_settings">Edit</Link>
          </div>
        </div>
        <div className="doc-schedule-body">
          {this.renderBody()}
        </div>
      </div>
    )
  }
}

WeeklyPlanTable.propTypes = {
  plans: PropTypes.array.isRequired,
}
function WeeklyPlanTable({ plans }) {
  return (
    <div className="doc-weeklyTable">
      {plans.map((plan, idx) =>
        <WeeklyPlanRow key={plan.id} plan={plan} isOdd={!!(idx % 2)} />
      )}
    </div>
  )
}

WeeklyPlanRow.propTypes = {
  plan: PropTypes.object.isRequired,
  isOdd: PropTypes.bool.isRequired,
}
function WeeklyPlanRow({ plan, isOdd }) {
  const className = `doc-weeklyTable-item u-clearFix ${isOdd ? 'is-odd' : null}`
  const weekdayName = getWeekdayName(plan.id)

  return (
    <div className={className}>
      <div className="col-lg-2 col-md-2 col-sm-2 col-xs-2 dateType">{weekdayName}</div>
      <div className="col-lg-10 col-md-10 col-sm-10">
        {plan.periods.map((p, idx) =>
          <div key={idx} className="col-lg-4 col-md-4 col-sm-4 col-xs-4">
            {`${p.startTime} - ${p.endTime}`}
          </div>
        )}
      </div>
    </div>
  )
}
