import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { fetchSpecialties } from './actions'

class SpecialtyList extends Component {
  static propTypes = {
    value: PropTypes.string.isRequired,
    list: PropTypes.array.isRequired,
    fetchSpecialties: PropTypes.func.isRequired,
    changeFilter: PropTypes.func.isRequired,
  }

  componentDidMount() {
    this.props.fetchSpecialties()
  }

  onChange = (e) => {
    this.props.changeFilter({ specialty_id: e.target.value })
  }

  render() {
    return (
      <div className="body">
        <select
          value={this.props.value}
          onChange={this.onChange}
          className="form-control u-input"
        >
          <option value="">All</option>
          {this.props.list.map(i =>
            <option key={i.id} value={i.id}>{i.name}</option>
          )}
        </select>
      </div>
    )
  }
}

function mapStateToProps(state) {
  const { specialtiesById, list: { ids: listIds } } = state.specialties
  const list = listIds.map(id => specialtiesById[id])
  return { list }
}

const SpecialtyListContainer = connect(
  mapStateToProps,
  { fetchSpecialties }
)(SpecialtyList)

export default SpecialtyListContainer
