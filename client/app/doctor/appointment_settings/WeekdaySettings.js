import React, { Component, PropTypes } from 'react'
import WeekdaySettingsEditContainer from './WeekdaySettingsEditContainer'
import { timeRange } from './common'
import { Glyphicon } from 'react-bootstrap'

export default class WeekdaySettings extends Component {
  static propTypes = {
    name: PropTypes.string.isRequired,
    value: PropTypes.string.isRequired,
    currentWeekday: PropTypes.string.isRequired,
    weekday_plan: PropTypes.object,
    unableEditPlan: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)
    this.state = {
      showEdit: false,
    }
  }

  editWeekdayPlan = () => {
    if (this.props.currentWeekday !== this.props.value) {
      this.setState({ showEdit: !this.state.showEdit })
    } else {
      this.props.unableEditPlan()
    }
  }

  angleIcon() {
    if (this.state.showEdit) {
      return <Glyphicon glyph="chevron-down" />
    }
    return <Glyphicon glyph="chevron-up" />
  }

  renderTimePeriods() {
    if (this.props.weekday_plan) {
      return this.props.weekday_plan.periods.map(
        period => <span key={period.start_time}>{timeRange(period)}</span>
      )
    }
    return null
  }

  renderWeekdaySettingEdit() {
    if (this.state.showEdit) {
      return (<WeekdaySettingsEditContainer
        name={this.props.name}
        value={this.props.weekday_plan.id}
      />)
    }
    return null
  }

  render() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading" role="tab" id="headingThree" onClick={this.editWeekdayPlan}>
          <h4 className="panel-title">
            {this.props.name}
          </h4>
          {this.renderTimePeriods()}
          <span style={{ float: 'right' }}>{this.angleIcon()}</span>
        </div>
        {this.renderWeekdaySettingEdit()}
      </div>
    )
  }
}
