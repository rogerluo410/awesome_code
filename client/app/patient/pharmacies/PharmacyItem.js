import React, { Component, PropTypes } from 'react'

export default class PharmacyItem extends Component {
  static propTypes = {
    pharmacy: PropTypes.shape({
      id: PropTypes.number.isRequired,
      street: PropTypes.string,
      company_name: PropTypes.string.isRequired,
      phone: PropTypes.string,
      email: PropTypes.string.isRequired,
    }).isRequired,
    isSubmitting: PropTypes.bool.isRequired,
    appointmentId: PropTypes.string.isRequired,
    sendToPharmacy: PropTypes.func.isRequired,
  }

  sendToPharmacy = () => {
    const { sendToPharmacy, pharmacy, appointmentId, isSubmitting } = this.props
    const data = {
      appointmentId,
      pharmacyId: pharmacy.id,
    }

    if (!isSubmitting) {
      sendToPharmacy(data)
    }
  }

  render() {
    const { pharmacy, isSubmitting } = this.props

    return (
      <div className="row u-pharmacys">
        <div className="col-md-5 col-sm-5 col-xs-12 chemist">
          <h4 className="title">{pharmacy.company_name}</h4>
          <p>Street: {pharmacy.street}</p>
          <p>Phone: {pharmacy.phone}</p>
          <p>Email: {pharmacy.email}</p>
        </div>
        <div className="col-md-4 col-sm-4 col-xs-12 store">
          <h4 className="title">Store hours</h4>
          <ul className="store-list">
            <li><span>Mon: </span>8:00AM - 9:00PM</li>
          </ul>
        </div>
        <div className="col-md-3 col-sm-3 col-xs-12 btn-send">
          <div
            className="bs-btn is-info"
            disabled={isSubmitting}
            onClick={this.sendToPharmacy}
          >
            Send Prescription
          </div>
        </div>
        <div className="clearfix"></div>
      </div>
    )
  }
}
