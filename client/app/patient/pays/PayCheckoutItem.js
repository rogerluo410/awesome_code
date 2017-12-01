import React, { Component, PropTypes } from 'react'

export default class PayCheckoutItem extends Component {
  static propTypes ={
    checkout: PropTypes.shape({
      brand: PropTypes.string.isRequired,
      cardLast4: PropTypes.string.isRequired,
      id: PropTypes.number.isRequired,
    }).isRequired,
    handleChange: PropTypes.func.isRequired,
    selectedId: PropTypes.number.isRequired,
  }

  handleClick = () => {
    this.props.handleChange(this.props.checkout.id)
  }

  cardActive(checkoutId) {
    if (this.props.selectedId === checkoutId) {
      return 'bankCard bankCard--sm is-active'
    }
    return 'bankCard bankCard--sm'
  }

  render() {
    const { checkout } = this.props
    return (
      <div
        key={checkout.id}
        className={this.cardActive(checkout.id)}
        onClick={this.handleClick}
      >
        <span className="">
          xxxx xxxx  xxxx {checkout.cardLast4}
        </span>
        <div className="visa">
          <img
            src="/static/image/visa-sm.png"
            alt="creadit card"
          />
        </div>
      </div>
    )
  }
}
