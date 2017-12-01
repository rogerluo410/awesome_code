import React, { Component, PropTypes } from 'react'
import { startTimeList, endTimeList } from './common'
import { CommonSelect } from '../../shared/common/CommonSelect'
import { Glyphicon } from 'react-bootstrap'

export default class TimePeriodSelector extends Component {
  static propTypes = {
    index: PropTypes.number.isRequired,
    period: PropTypes.object.isRequired,
    removeItem: PropTypes.func.isRequired,
    changeItem: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)
    this.state = {
      period: this.props.period,
    }
  }

  startTimeChange = (e) => {
    const newPeriod = Object.assign({}, this.state.period, { start_time: e.target.value })
    this.setState({ period: newPeriod })
    this.props.changeItem(this.props.index, newPeriod)
  }

  endTimeChange = (e) => {
    const newPeriod = Object.assign({}, this.state.period, { end_time: e.target.value })
    this.setState({ period: newPeriod })
    this.props.changeItem(this.props.index, newPeriod)
  }

  removeItem = () => {
    this.props.removeItem(this.props.index)
  }

  render() {
    return (
      <div className="col-lg-5 col-md-6 col-sm-6 col-xs-12 rangeItem">
        <CommonSelect
          value={this.state.period.start_time}
          list={startTimeList}
          onChange={this.startTimeChange}
          className="form-control"
        />
        <div className="range">To</div>
        <CommonSelect
          value={this.state.period.end_time}
          list={endTimeList}
          onChange={this.endTimeChange}
          className="form-control"
        />
        <div className="redLink" onClick={this.removeItem}>
          <a className="" ><Glyphicon glyph="trash" /></a>
        </div>
      </div>
    )
  }
}
