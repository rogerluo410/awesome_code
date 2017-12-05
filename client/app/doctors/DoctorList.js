import React, { PropTypes } from 'react'
import DoctorItem from './DoctorItem'

DoctorList.propTypes = {
  doctorList: PropTypes.array.isRequired,
  totalCount: PropTypes.number,
  appoint: PropTypes.func.isRequired,
}

showContent() {
  
}

export default function DoctorList({ doctorList, totalCount, appoint }) {
  return (
    <div>
      <div className="count">{totalCount? totalCount : 0} doctors found</div>

      {doctorList.map(doctor => <DoctorItem key={doctor.id} doctor={doctor} appoint={appoint} />)}
    </div>
  )
}
