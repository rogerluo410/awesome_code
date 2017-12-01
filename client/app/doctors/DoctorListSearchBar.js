import React, { Component, PropTypes } from 'react'
import debounce from 'lodash/debounce'

class DoctorListSearchBar extends Component {
  static propTypes = {
    q: PropTypes.string,
    changeFilter: PropTypes.func.isRequired,
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
      <div className="form-group">
        <input
          type="text"
          defaultValue={this.props.q}
          className="form-control u-input"
          placeholder="First Name, Last Name"
          onChange={this.textChanged}
        />
      </div>
    )
  }
}

export default DoctorListSearchBar
