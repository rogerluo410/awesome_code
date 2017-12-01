import React, { Component, PropTypes } from 'react'
import Time from 'app/timeZone/Time'
import Loading from 'app/doctor/workspace/Loading'
import NoRecord from 'app/doctor/workspace/NoRecord'

export default class Doctor extends Component {
  static propTypes = {
    doctor: PropTypes.shape({
      id: PropTypes.number.isRequired,
      avatarUrl: PropTypes.string.isRequired,
      name: PropTypes.string.isRequired,
      bioInfo: PropTypes.string,
      type: PropTypes.string.isRequired,
      specialtyName: PropTypes.string.isRequired,
      isAvailableNow: PropTypes.bool.isRequired,
    }),
    params: PropTypes.object.isRequired,
    isFetching: PropTypes.bool.isRequired,
    fetchDoctor: PropTypes.func.isRequired,
  }

  componentWillMount() {
    const { fetchDoctor, params } = this.props
    fetchDoctor(params.id)
  }

  render() {
    const { isFetching, doctor } = this.props

    if (isFetching) return <Loading />
    if (!doctor) return <NoRecord>Doctor not found</NoRecord>

    return (
      <div className="doc-detail-masthead">
        <div className="doc-card doc-card--masthead">
          <div className="u-container u-clearFix">
            <div className="doc-card-imgBox u-cricleImg">
              <img src={doctor.avatarUrl} className="" alt="doctor" />
            </div>
            <div className="u-info col-md-6">
              <div className="fullName">Dr. {doctor.name}</div>
              <div className="appellation u-textPadding">
                {doctor.specialtyName}
              </div>
              <div className="infoContent u-textPadding">
                {doctor.bioInfo}
              </div>
            </div>
            <div className="doc-card-realTime u-textDsc">
              <div className="rtItem">
                <span className="font-blue">{doctor.yearsExperience} Years</span>
                <span>experience</span>
              </div>
              <div className="rtItem">
                <span className="font-green">{doctor.totalPatientCount} People</span>
                <span>helped</span>
              </div>
              <div className="rtItem">
                <span>Joined
                  <Time value={doctor.createdAt} format="Y-M-D" />
                </span>
              </div>
            </div>
            <div className="doc-card-freeNow col-md-3">
              <div className="freeNow-text">
                <AvaliableNow
                  isAvailableNow={doctor.isAvailableNow}
                />
              </div>
              <div className="dsc">
                *Need Payment before your consulattion
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}

// eslint-disable-next-line react/prop-types
function AvaliableNow({ isAvailableNow }) {
  let avaliable
  if (isAvailableNow) {
    avaliable = 'AVAILABLE NOW'
  } else {
    avaliable = 'NOT AVAILABLE NOW'
  }
  return <div className="freeNow-text">{avaliable}</div>
}
