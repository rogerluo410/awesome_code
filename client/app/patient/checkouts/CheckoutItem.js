import React, { Component, PropTypes } from 'react'
import capitalize from 'lodash/capitalize'
import { getCardBrandIcon } from 'app/utils/common'

export default class CheckoutItem extends Component {
  static propTypes = {
    checkout: PropTypes.shape({
      id: PropTypes.number.isRequired,
      brand: PropTypes.string.isRequired,
      cardLast4: PropTypes.string.isRequired,
      funding: PropTypes.string.isRequired,
      expMonth: PropTypes.number.isRequired,
      expYear: PropTypes.number.isRequired,
    }).isRequired,
    destroyCheckout: PropTypes.func.isRequired,
    setDefaultCheckout: PropTypes.func.isRequired,
  }

  state = { isDeleting: false }

  brandIcon() {
    const icon = getCardBrandIcon(this.props.checkout.brand)
    return <i className={`fa fa-${icon}`} />
  }

  cardNumber() {
    return `**** **** **** ${this.props.checkout.cardLast4}`
  }

  funding() {
    return capitalize(this.props.checkout.funding)
  }

  exp() {
    const { checkout: { expMonth, expYear } } = this.props
    return `${expMonth < 10 ? '0' : ''}${expMonth}/${expYear}`
  }

  handleDestroy = () => {
    // NOTE if deleting success, we don't set state, because the component will unmount.
    this.setState({ isDeleting: true })
    this.props.destroyCheckout(this.props.checkout.id)
      .catch(() => this.setState({ isDeleting: false }))
  }

  handleSetDefault = () => {
    const { checkout, setDefaultCheckout } = this.props
    if (!checkout.default) {
      setDefaultCheckout(checkout.id)
    }
  }

  render() {
    const { checkout } = this.props

    return (
      <tr>
        <td>{this.brandIcon()}</td>
        <td>{this.cardNumber()}</td>
        <td>{this.funding()}</td>
        <td>{this.exp()}</td>
        <td>
          <input type="checkbox" checked={checkout.default} onChange={this.handleSetDefault} />
        </td>
        <td>
          {this.state.isDeleting
            ? <i className="fa fa-circle-o-notch fa-spin fa-fw" />
            : <a onClick={this.handleDestroy}><span className="glyphicon glyphicon-trash" /></a>
          }
        </td>
      </tr>
    )
  }
}
