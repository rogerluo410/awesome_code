import React, { Component, PropTypes } from 'react'
import truncate from 'lodash/truncate'
import AppointmentPeriod from './AppointmentPeriod'
import Link from 'react-router/lib/Link'

export default class DoctorItem extends Component {
  static propTypes = {
    doctor: PropTypes.shape({
      id: PropTypes.number.isRequired,
      is_available_now: PropTypes.bool.isRequired,
      name: PropTypes.string.isRequired,
      avatar_url: PropTypes.string.isRequired,
      specialty_name: PropTypes.string,
      bio_info: PropTypes.string,
      appointment_periods: PropTypes.array.isRequired,
    }).isRequired,
    appoint: PropTypes.func.isRequired,
  }

  appoint = (period) => {
    this.props.appoint({
      doctor_id: this.props.doctor.id,
      appointment_setting_id: period.id,
      start_time: period.start_time,
      end_time: period.end_time,
    })
  }

  render() {
    const { doctor } = this.props

    return (
      <div className="doc-card doc-card--white">
        <div className="u-clearFix">
          <div className="col-md-3 col-lg-3 u-nonPadLeft">
            <div className="doc-card-imgBox is-white">
              <Link to={`/doctors/${doctor.id}`}>
                <img
                  className="u-cricleImg"
                  alt="doctor avatar"
                  src={doctor.avatar_url}
                />
              </Link>
            </div>
          </div>
          <div className="u-info is-white col-md-9 col-lg-9">
            <div className="row">
              <div className="u-clearFix">
                <div className="col-lg-6 col-md-6 col-sm-6 col-xs-6 col-sm-6">
                  <Link to={`/doctors/${doctor.id}`}>
                    <div className="row">
                      <div className="fullName u-textPadding">
                        Dr. {doctor.name}
                        {doctor.is_available_now &&
                          <div className="mark is-green">
                            Available
                          </div>
                        }
                      </div>
                      <div className="appellation u-textPadding">
                        {doctor.specialty_name}
                      </div>
                    </div>
                  </Link>
                </div>
              </div>

              <div className="infoContent u-textPadding-lg col-lg-10 col-md-9">
                <div className="row">
                  {truncate(doctor.bio_info, { length: 100 })}
                </div>
              </div>
              <div className="u-clearFix"></div>
              <div className="doc-card-bookTime u-textPadding-lg">
                <div className="title">
                  BOOK APPOINTMENT AT
                </div>
                <div className="item u-clearFix">
                  <div className="mark mark--float is-yellow is-small">Time</div>
                  {doctor.appointment_periods.map(period =>
                    <AppointmentPeriod key={period.id} period={period} appoint={this.appoint} />
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
