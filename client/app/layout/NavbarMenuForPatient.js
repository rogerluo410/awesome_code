import React, { PropTypes } from 'react'
import Link from 'react-router/lib/Link'
import truncate from 'lodash/truncate'
import NavDropdown from './NavDropdown'
import NotificationCenterContainer from '../notifications/NotificationCenterContainer'

NavbarMenuForPatient.propTypes = {
  user: PropTypes.shape({
    name: PropTypes.string.isRequired,
  }).isRequired,
  signOut: PropTypes.func.isRequired,
}

export default function NavbarMenuForPatient({ user, signOut }) {
  return (
    <div className="navbar-collapse collapse">
      <ul className="nav navbar-nav call-navbar">
        <li><Link to={'/p/dashboard'} activeClassName="is-active">Dashboard</Link></li>
        <li><Link to={'/'} activeClassName="is-active">Doctors</Link></li>
      </ul>
      <ul className="nav navbar-nav navbar-right">
        <NotificationCenterContainer />
        <NavDropdown title={`Patient ${truncate(user.name, { length: 20 })}`}>
          <ul className="dropdown-menu" role="menu">
            <li><a href="/p/me">Edit Profile</a></li>
            <li><Link to={'/p/checkouts'}>Manage Credit Cards</Link></li>
          </ul>
        </NavDropdown>

        <li>
          <a onClick={signOut}><b>Sign Out</b></a>
        </li>
      </ul>
    </div>
  )
}
