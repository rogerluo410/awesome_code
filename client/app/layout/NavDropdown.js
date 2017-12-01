import React, { Component, PropTypes } from 'react'

class NavDropdown extends Component {
  static propTypes = {
    title: PropTypes.string.isRequired,
    children: PropTypes.element.isRequired,
    caret: PropTypes.bool,
  }

  state = { isOpen: false }

  toggle = () => {
    this.setState({ isOpen: !this.state.isOpen })
  }

  render() {
    const liClassName = this.state.isOpen ? 'dropdown open' : 'dropdown'

    return (
      <li className={liClassName} onClick={this.toggle}>
        <a className="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">
          {this.props.title}
          {this.props.caret ? <span className="caret"></span> : null}
        </a>
        {this.props.children}
      </li>
    )
  }
}

export default NavDropdown
