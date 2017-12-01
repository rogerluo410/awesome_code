import React, { Component, PropTypes } from 'react'
import DatePicker from 'react-bootstrap-date-picker'
import moment from 'moment-timezone'
import SpecialtyListContainer from '../specialties/SpecialtyListContainer'
import { timeList } from '../utils/common'
import DoctorListSearchBar from './DoctorListSearchBar'
import { CommonSelect } from '../shared/common/CommonSelect'

export default class DoctorListFilter extends Component {
  static propTypes = {
    filters: PropTypes.object.isRequired,
    changeFilter: PropTypes.func.isRequired,
    clearFilter: PropTypes.func.isRequired,
  }

  changeDate = (value) => {
    const date = value ? moment(value).format('YYYY-MM-DD') : null
    this.props.changeFilter({ date })
  }

  changeTimeTo = (e) => {
    this.props.changeFilter({ to: e.target.value })
  }

  render() {
    return (
      <div className="doc-docList-form">
        <div className="u-topbar">
          <a
            href=""
            className="btn-reset"
            onClick={this.props.clearFilter}
          >Reset</a>
        </div>

        <div className="u-formGroup">
          <div className="title">
            Specialty
          </div>

          <div className="body">
            <SpecialtyListContainer
              value={this.props.filters.specialty_id}
              changeFilter={this.props.changeFilter}
            />
          </div>
        </div>

        <div className="u-formGroup">
          <div className="title">
            Time
          </div>
          <div className="body u-clearFix">
            <div className="btn-group u-formGroup u-btnGroup is-hasTwo" data-toggle="buttons">
              <label className="btn active">
                <input type="checkbox" autoComplete="off" defaultChecked /> Now
              </label>
              <label className="btn">
                <CommonSelect
                  value={this.props.filters.to}
                  list={timeList}
                  onChange={this.changeTimeTo}
                  className="form-control u-select"
                />
              </label>
            </div>
          </div>
        </div>

        <div className="u-formGroup">
          <div className="title">
            Day
          </div>
          <div className="body u-input">
            <DatePicker
              dateFormat="YYYY-MM-DD"
              value={this.props.filters.date}
              onChange={this.changeDate}
              clearButtonElement={'Today'}
            />
          </div>
        </div>

        <div className="u-formGroup">
          <div className="title">
            Search
          </div>
          <div className="body">
            <DoctorListSearchBar
              q={this.props.filters.q}
              changeFilter={this.props.changeFilter}
            />
          </div>
        </div>
      </div>
    )
  }
}
