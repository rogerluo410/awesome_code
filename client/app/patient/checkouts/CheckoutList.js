import React, { Component, PropTypes } from 'react'
import Loading from 'app/doctor/workspace/Loading'
import CheckoutItem from './CheckoutItem'

export default class CheckoutList extends Component {
  static propTypes = {
    checkouts: PropTypes.array.isRequired,
    isFetching: PropTypes.bool.isRequired,
    fetchCheckouts: PropTypes.func.isRequired,
    showNewCheckoutModal: PropTypes.func.isRequired,
    destroyCheckout: PropTypes.func.isRequired,
    setDefaultCheckout: PropTypes.func.isRequired,
  }

  componentWillMount() {
    this.props.fetchCheckouts()
  }

  render() {
    const {
      isFetching,
      checkouts,
      showNewCheckoutModal,
      destroyCheckout,
      setDefaultCheckout,
    } = this.props

    if (isFetching) return <Loading />

    return (
      <div className="u-container">
        <div className="doc-prescription">
          <div className="doc-cards">
            <div className="doc-cards-header">
              <div className="title">CREDIT CARD LIST</div>
            </div>
            <div className="doc-cards-body">
              <div className="doc-cards-item u-clearFix">
                <table className="table">
                  <tbody>
                    <tr>
                      <th>Brand</th>
                      <th>Card</th>
                      <th>Funding</th>
                      <th>Exp</th>
                      <th>Default</th>
                      <th>Action</th>
                    </tr>
                    {checkouts.map(c =>
                      <CheckoutItem
                        key={c.id}
                        checkout={c}
                        destroyCheckout={destroyCheckout}
                        setDefaultCheckout={setDefaultCheckout}
                      />
                    )}
                  </tbody>
                </table>
              </div>

              <AddCheckout onClick={showNewCheckoutModal} />
            </div>
          </div>
        </div>
      </div>
    )
  }
}

AddCheckout.propTypes = {
  onClick: PropTypes.func.isRequired,
}
function AddCheckout({ onClick }) {
  return (
    <div className="row">
      <div className="col-sm-3">
        <button
          className="doc-btn doc-btn--green btn"
          onClick={onClick}
        >
          Add Card
        </button>
      </div>
    </div>
  )
}
