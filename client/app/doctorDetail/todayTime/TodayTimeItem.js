import React, { Component, PropTypes } from 'react'
import Time from 'app/timeZone/Time'

export default class TodayTimeItem extends Component {
  static propTypes = {
    time: PropTypes.shape({
      id: PropTypes.number.isRequired,
      startTime: PropTypes.string.isRequired,
      endTime: PropTypes.string.isRequired,
      bookedSlots: PropTypes.number.isRequired,
      remainSlots: PropTypes.number.isRequired,
      estimationTime: PropTypes.string.isRequired,
      price: PropTypes.number.isRequired,
    }).isRequired,
    appoint: PropTypes.func.isRequired,
    doctorId: PropTypes.string.isRequired,
  }

  canAppoint() {
    return this.props.time.remainSlots > 0
  }

  appoint = () => {
    const { appoint, time, doctorId } = this.props
    const data = {
      appointment_setting_id: time.id,
      doctor_id: doctorId,
      start_time: time.startTime,
      end_time: time.endTime,
    }

    if (this.canAppoint()) appoint(data)
  }

  ColorWithPriceClass() {
    const { time } = this.props
    let style
    if (time.price === 37.5) {
      style = 'doc-timeZone-range'
    } else if (time.price === 49.95) {
      style = 'doc-timeZone-range is-yellow'
    } else {
      style = 'doc-timeZone-range is-red'
    }

    return style
  }

  render() {
    const { time } = this.props
    return (
      <div className="doc-timeZone-item u-clearFix" onClick={this.appoint}>
        <div className={this.ColorWithPriceClass()}>
          <div><Time value={time.startTime} format="HH:mm" /></div>
          <div>|</div>
          <div><Time value={time.endTime} format="HH:mm" /></div>
        </div>
        <div className="doc-timeZone-summary">
          <div className="summary u-clearFix ">
            <div className=" col-xs-4 ">
              <div className="row">
                <div className="summary-header is-gray">
                  {time.bookedSlots}
                </div>
                <div className="summary-dsc">
                  booked
                </div>
              </div>
            </div>
            <div className="col-xs-4">
              <div className="row">
                <div className="summary-header is-blue">
                  {time.remainSlots}
                </div>
                <div className="summary-dsc">
                  remain
                </div>
              </div>
            </div>
            <div className="col-xs-4">
              <div className="row">
                <div className="summary-header is-gray">
                  <i className="fa fa-clock-o"></i>
                  <span></span>
                </div>
                <div className="summary-dsc">
                  <Time value={time.estimationTime} format="HH:mm" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
