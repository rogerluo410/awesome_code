import React, { Component, PropTypes } from 'react'
import cable from 'app/cable'
import UpcomingAppointmentContainer from '../upcomingAppointment/UpcomingAppointmentContainer'
import RecentAppointmentsContainer from '../recentAppointments/RecentAppointmentsContainer'
import AppScheduleContainer from '../appSchedule/AppScheduleContainer'
import WeeklyPlanContainer from '../weeklyPlan/WeeklyPlanContainer'

export default class Workspace extends Component {
  static propTypes = {
    fetchSchedule: PropTypes.func.isRequired,
    refreshUpcoming: PropTypes.func.isRequired,
  }

  componentWillMount() {
    this.subscription = cable.subscriptions.create('DoctorWorkspaceChannel', {
      received: (json) => {
        if (json.op === 'app_created' || json.op === 'app_paid') {
          this.props.fetchSchedule({ bg: true })
        } else if (json.op === 'survey_updated') {
          this.props.refreshUpcoming(json.app_id)
        }
      },
    })
  }

  componentWillUnmount() {
    if (this.subscription) {
      this.subscription.unsubscribe()
      delete this.subscription
    }
  }

  render() {
    return (
      <div className="doc-space">
        <div className="doc-space-masthead u-clearFix">
          <div className="u-container">
            <div className="col-lg-6 col-md-6 col-sm-6 col-xs-12">
              <UpcomingAppointmentContainer />
            </div>
            <div className="col-lg-6 col-md-6 col-sm-6 col-xs-12 rightView">
              <RecentAppointmentsContainer />
              <AppScheduleContainer />
            </div>
          </div>
        </div>
        <div className="doc-space-masthead doc-space-masthead--white  u-clearFix">
          <div className="u-container">
            <div className="col-lg-6 col-md-6 col-sm-6 col-xs-12">
              <div className="subHeader"></div>
              <div className="summary u-clearFix row">
                <div className="col-lg-4 col-md-4 col-sm-4 col-xs-4 ">
                </div>
              </div>
            </div>
            <div className="col-lg-6 col-md-6 col-sm-6 col-xs-12 rightView">
              <WeeklyPlanContainer />
            </div>
          </div>
        </div>
      </div>
    )
  }
}
