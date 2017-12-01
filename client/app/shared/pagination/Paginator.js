import React, { Component, PropTypes } from 'react'
import Pager from 'react-bootstrap/lib/Pager'

export default class Paginator extends Component {
  static propTypes = {
    nextPage: PropTypes.number,
    prevPage: PropTypes.number,
    gotoPage: PropTypes.func.isRequired,
  }

  gotoNextPage = () => {
    this.props.gotoPage(this.props.nextPage)
  }

  gotoPrevPage = () => {
    this.props.gotoPage(this.props.prevPage)
  }

  renderPrevPage() {
    if (!this.props.prevPage) return null
    return (
      <Pager.Item
        previous
        disabled={!this.props.prevPage}
        onClick={this.gotoPrevPage}
      >
        Previous
      </Pager.Item>
    )
  }

  renderNextPage() {
    if (!this.props.nextPage) return null
    return (
      <Pager.Item
        next
        disabled={!this.props.nextPage}
        onClick={this.gotoNextPage}
      >
        Next
      </Pager.Item>
    )
  }

  render() {
    return (
      <div>
        <Pager>
          {this.renderPrevPage()}
          {' '}
          {this.renderNextPage()}
        </Pager>
      </div>
    )
  }
}
