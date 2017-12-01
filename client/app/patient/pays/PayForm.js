import React, { Component, PropTypes } from 'react'
import { Glyphicon } from 'react-bootstrap'
import get from 'lodash/get'
import PayCheckoutItem from './PayCheckoutItem'

export default class PayForm extends Component {
  static propTypes = {
    submitting: PropTypes.bool.isRequired,
    appointment: PropTypes.object.isRequired,
    checkouts: PropTypes.array.isRequired,
    save: PropTypes.func.isRequired,
    showCheckoutModal: PropTypes.func.isRequired,
  }

  constructor(props) {
    super(props)
    const checkoutId = get(props.checkouts, '[0].id')
    this.state = {
      checkoutId,
      notValid: checkoutId == null,
    }
  }

  handleChange = (checkoutId) => {
    this.setState({
      checkoutId,
    })
  }

  handleSubmit = () => {
    const data = {
      checkoutId: this.state.checkoutId,
      appointmentId: this.props.appointment.id,
    }

    if (!this.state.notValid && !this.props.submitting) {
      this.props.save(data)
    }
  }

  render() {
    const { checkouts, appointment, showCheckoutModal, submitting } = this.props

    return (
      <form>
        <div className="doc-createCard-body u-clearFix">
          {checkouts.map(checkout =>
            <PayCheckoutItem
              key={checkout.id}
              checkout={checkout}
              handleChange={this.handleChange}
              selectedId={this.state.checkoutId}
            />
          )}
          <div className="addCard" onClick={showCheckoutModal}>
            <span className="addCard-icon"><Glyphicon glyph="plus" /></span>
            <div className="addCard-dsc">Add New Card</div>
          </div>
          <div className="u-clearFix"></div>
          <div className="doc-createCard-comfirmBox">

            <div className="col-xs-7">
              <div className="price">
                ${appointment.consultationFee}
              </div>
            </div>
            <div className="col-xs-5">
              <div
                className="btn m-btn is-green"
                disabled={this.state.notValid || submitting}
                onClick={this.handleSubmit}
              >
                CONFIRM
              </div>
            </div>
          </div>
        </div>
      </form>
    )
  }
}
