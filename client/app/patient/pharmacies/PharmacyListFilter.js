import React, { Component, PropTypes } from 'react'
import debounce from 'lodash/debounce'

export default class PharmacyListFilter extends Component {
  static propTypes = {
    filters: PropTypes.object.isRequired,
    changeFilter: PropTypes.func.isRequired,
    clearFilter: PropTypes.func.isRequired,
  }

  changeTextFilter(value) {
    this.props.changeFilter({ q: value })
  }

  textChanged = (e) => {
    const value = e.target.value
    this.delayChangeTextFilter(value)
  }

  delayChangeTextFilter = debounce(this.changeTextFilter, 400)

  render() {
    return (
      <div className="doc-pharmacy-header">
        <div className="u-pharmacyTel search">
          <input
            defaultValue={this.props.filters.q}
            onChange={this.textChanged}
          />
          <span>Find via Post code / pharmacy name</span>
        </div>
        <div className="clearfix"></div>
      </div>
    )
  }
}
