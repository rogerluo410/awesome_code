import React, { Component, PropTypes } from 'react'
import TimePeriodSelector from './TimePeriodSelector'
import isEqual from 'lodash/isEqual'

export default class WeekdaySettingsEdit extends Component {

  static propTypes = {
    weekday_plan: PropTypes.object,
    updateAppointmentSettings: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)

    this.state = { weekday_plan: Object.assign({}, this.props.weekday_plan) }
  }

  componentWillReceiveProps(newProps) {
    this.setState({ weekday_plan: newProps.weekday_plan })
  }

  cancelAction = () => {
    this.setState({ weekday_plan: Object.assign({}, this.props.weekday_plan) })
  }

  addItem = () => {
    const newStartTime = '00:00'
    const newendTime = '01:00'
    const newPeriods = Object.assign([], this.state.weekday_plan.periods)
    newPeriods.push({ start_time: newStartTime, end_time: newendTime })

    this.setState({ weekday_plan: {
      periods: newPeriods,
    } })
  }

  changeItem = (index, period) => {
    const newPeriods = Object.assign([], this.state.weekday_plan.periods)
    newPeriods[index] = period

    this.setState({ weekday_plan: {
      periods: newPeriods,
    } })
  }

  removeItem = (index) => {
    const newPeriods = Object.assign([], this.state.weekday_plan.periods)
    newPeriods.splice(index, 1)

    this.setState({
      weekday_plan: {
        periods: newPeriods,
      },
    })
  }

  updateSettings = () => {
    const params = {
      data: {
        id: this.props.weekday_plan.id,
        periods: this.state.weekday_plan.periods,
      },
    }
    this.props.updateAppointmentSettings(params)
  }

  actionButtonClass = () => {
    if (isEqual(this.props.weekday_plan.periods, this.state.weekday_plan.periods)) {
      return 'col-xs-3 hidden'
    }
    return 'col-xs-3'
  }

  renderRangeItems() {
    if (this.state.weekday_plan) {
      const elements = []
      this.state.weekday_plan.periods.forEach((period, index) =>
        elements.push(
          <TimePeriodSelector
            key={period.start_time + period.end_time + index}
            index={index}
            period={period}
            removeItem={this.removeItem}
            changeItem={this.changeItem}
          />
        )
      )
      return elements
    }
    return null
  }

  render() {
    return (
      <div
        id="collapseThree"
        className="panel-collapse collapse in"
        role="tabpanel"
        aria-labelledby="headingThree"
        aria-expanded="true"
      >
        <div className="panel-body">
          <div className="row">
            {this.renderRangeItems()}
          </div>
          <div className="rangeItem" >
            <div className="row">
              <div className="col-xs-3" onClick={this.addItem}>
                <div className="btn m-btn is-green">
                  Add new
                </div>
              </div>
              <div className={this.actionButtonClass()} onClick={this.updateSettings}>
                <div className="btn m-btn is-green">Save</div>
              </div>
              <div className={this.actionButtonClass()} onClick={this.cancelAction}>
                <div className="btn m-btn is-red">Cancel</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
