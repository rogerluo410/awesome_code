
import React, { PropTypes } from 'react'

export function CommonSelect(props) {
  return (
    <select value={props.value} onChange={props.onChange} className={props.className}>
      {props.list.map(i =>
        <option key={i.value} value={i.value}>{i.name}</option>
      )}
    </select>
  )
}

CommonSelect.propTypes = {
  value: PropTypes.string.isRequired,
  list: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired,
  className: PropTypes.string.isRequired,
}
