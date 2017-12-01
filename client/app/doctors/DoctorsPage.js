import React, { Component, PropTypes } from 'react'
import browserHistory from 'react-router/lib/browserHistory'
import moment from 'moment-timezone'
import DoctorListContainer from './DoctorListContainer'
import DoctorListFilterContainer from './DoctorListFilterContainer'
import DoctorListPaginator from './DoctorListPaginator'

export default class DoctorsPage extends Component {
  static propTypes = {
    location: PropTypes.object.isRequired,
    tz: PropTypes.string.isRequired,
    fetchDoctors: PropTypes.func.isRequired,
  }

  componentWillMount() {
    this.setFiltersAndSearch(this.props.location.query)
  }

  componentWillReceiveProps(nextProps) {
    this.setFiltersAndSearch(nextProps.location.query)
  }

  setFiltersAndSearch(query) {
    const filters = this.getFiltersWithDefault(query)
    this.setState({ filters })
    this.props.fetchDoctors(filters)
  }

  getFiltersWithDefault(query) {
    const { tz } = this.props
    let { date, to, specialty_id, q, page } = query

    if (!date) date = moment().format('YYYY-MM-DD')
    if (!to) to = 'end_of_day'
    if (!specialty_id) specialty_id = '' // eslint-disable-line camelcase
    if (!q) q = undefined
    if (!page) page = 1

    return { date, to, tz, specialty_id, q, page }
  }

  changeFilter = (params) => {
    const { pathname, query } = this.props.location
    browserHistory.replace({ pathname, query: { ...query, ...params, page: 1 } })
  }

  clearFilter = () => {
    const { pathname } = this.props.location
    browserHistory.replace({ pathname })
  }

  gotoPage = (page) => {
    const { pathname, query } = this.props.location
    browserHistory.replace({ pathname, query: { ...query, page } })
  }

  render() {
    return (
      <div className="u-container u-clearFix">
        <div className="doc-docList u-clearFix">
          <div className="col-lg-3 col-md-3">
            <div className="row">
              <DoctorListFilterContainer
                filters={this.state.filters}
                changeFilter={this.changeFilter}
                clearFilter={this.clearFilter}
              />
            </div>
          </div>

          <div className="col-lg-9 col-md-9">
            <div className="doc-docList-list">
              <DoctorListContainer isSignedIn={this.props.isSignedIn} />
              <DoctorListPaginator gotoPage={this.gotoPage} />
            </div>
          </div>
        </div>
      </div>
    )
  }
}
