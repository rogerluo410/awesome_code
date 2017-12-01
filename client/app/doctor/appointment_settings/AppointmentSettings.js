import React, { Component, PropTypes } from 'react'
import WeekdaySettingsContainer from './WeekdaySettingsContainer'
import { weekdayList } from '../../utils/common'

export default class AppointmentSettings extends Component {
  static propTypes = {
    fetchAppointmentSettings: PropTypes.func.isRequired,
  }

  componentWillMount() {
    this.props.fetchAppointmentSettings()
  }

  render() {
    return (
      <div className="doc-docList u-clearFix">
        <div className="col-lg-8 col-md-8 col-sm-8 col-xs-8 col-md-offset-2">
          <h2 className="u-title">weekly plan</h2>
          <div className="doc-setting-panel u-clearFix">
            <div className="panel-group u-panel">
              {
                weekdayList.map(weekday =>
                  <WeekdaySettingsContainer
                    key={weekday.name}
                    name={weekday.name}
                    value={weekday.value}
                  />
                )
              }
            </div>
          </div>
        </div>
      </div>
    )
  }
}
