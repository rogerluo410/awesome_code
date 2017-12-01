import React, { PropTypes, Component } from 'react'
import Loading from 'app/doctor/workspace/Loading'
import browserHistory from 'react-router/lib/browserHistory'
import PharmacyListPaginator from './PharmacyListPaginator'
import PharmacyItem from './PharmacyItem'
import PharmacyListFilter from './PharmacyListFilter'

export default class PharmacyList extends Component {
  static propTypes = {
    isFetching: PropTypes.bool.isRequired,
    isSubmitting: PropTypes.bool.isRequired,
    location: PropTypes.object.isRequired,
    fetchPharmacies: PropTypes.func.isRequired,
    totalCount: PropTypes.number.isRequired,
    pharmacies: PropTypes.array.isRequired,
    sendToPharmacy: PropTypes.func.isRequired,
    params: PropTypes.object.isRequired,
  }

  componentWillMount() {
    this.setFiltersAndSearch(this.props.location.query)
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location !== nextProps.location) {
      this.setFiltersAndSearch(nextProps.location.query)
    }
  }

  setFiltersAndSearch(query) {
    const filters = this.getFiltersWithDefault(query)
    this.setState({ filters })
    this.props.fetchPharmacies(filters)
  }

  getFiltersWithDefault(query) {
    let { q, page } = query
    if (!q) q = undefined
    if (!page) page = 1

    return { q, page }
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

  renderResults() {
    const { pharmacies, totalCount, isFetching, sendToPharmacy, isSubmitting, params } = this.props
    if (isFetching) return <Loading />
    if (!pharmacies) return null

    return (
      <div>
        <h3 className="doc-upload-title">{totalCount} pharmacy in your around</h3>
        <div className="doc-pharmacy-body">
          {pharmacies.map(pharmacy =>
            <PharmacyItem
              key={pharmacy.id}
              pharmacy={pharmacy}
              appointmentId={params.appointmentId}
              sendToPharmacy={sendToPharmacy}
              isSubmitting={isSubmitting}
            />
          )}
          <PharmacyListPaginator gotoPage={this.gotoPage} />
        </div>
      </div>
    )
  }

  render() {
    return (
      <div>
        <div className="doc-upload doc-pharmacy">
          <PharmacyListFilter
            filters={this.state.filters}
            changeFilter={this.changeFilter}
            clearFilter={this.clearFilter}
          />
          {this.renderResults()}
        </div>
      </div>
    )
  }
}
