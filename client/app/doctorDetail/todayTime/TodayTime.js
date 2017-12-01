import React, { Component, PropTypes } from 'react'
import Loading from 'app/doctor/workspace/Loading'
import TodayTimeItem from './TodayTimeItem'

export default class TodayTime extends Component {
  static propTypes = {
    todayTime: PropTypes.array.isRequired,
    params: PropTypes.object.isRequired,
    isFetching: PropTypes.bool.isRequired,
    fetchDoctorTodayTime: PropTypes.func.isRequired,
    timeZone: PropTypes.string.isRequired,
    date: PropTypes.string.isRequired,
    appoint: PropTypes.func.isRequired,
  }

  componentWillMount() {
    const { fetchDoctorTodayTime, params, timeZone, date } = this.props
    const data = {
      id: params.id,
      timezone: timeZone,
      date,
    }
    fetchDoctorTodayTime(data)
  }

  totalRemainSlots() {
    let slots = 0
    this.props.todayTime.map(i => (slots += parseInt(i.remainSlots, 10)))
    return slots
  }

  renderTodayTime() {
    const { todayTime, appoint, params } = this.props
    if (!todayTime.length) return <NoRecord />

    return (
      <div>
        {todayTime.map(time =>
          <TodayTimeItem
            key={time.id}
            time={time}
            appoint={appoint}
            doctorId={params.id}
          />
        )}
      </div>
    )
  }

  render() {
    const { isFetching } = this.props

    if (isFetching) return <Loading />

    return (
      <div className="col-md-12">
        <div className="doc-schedule u-clearFix">
          <div className="doc-schedule-header">
            <div className="title">Book Time Today</div>
            <div className="dsc">{this.totalRemainSlots()} slots remain</div>
            <div className="doc-card--demoRange">
              <div className="doc-timeZone-range"></div>
              37.5$
              <div className="doc-timeZone-range is-yellow"></div>
              49.95$
              <div className="doc-timeZone-range is-red"></div>
              99$
            </div>
          </div>
          <div className="doc-schedule-body doc-timeZone">
            {this.renderTodayTime()}
          </div>
        </div>
      </div>
    )
  }
}

function NoRecord() {
  return (
    <div className="norecord center-block">
      <div className="record-note">Not avaliable today</div>
    </div>
  )
}
