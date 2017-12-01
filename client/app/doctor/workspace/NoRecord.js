import React, { PropTypes } from 'react'

NoRecord.propTypes = {
  children: PropTypes.node.isRequired,
}

export default function NoRecord({ children }) {
  return (
    <div className="norecord">
      {children}
    </div>
  )
}
