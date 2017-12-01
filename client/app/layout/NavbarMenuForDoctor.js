import React, { PropTypes } from 'react'
import Link from 'react-router/lib/Link'
import truncate from 'lodash/truncate'
import NavDropdown from './NavDropdown'
import NotificationCenterContainer from '../notifications/NotificationCenterContainer'

NavbarMenuForDoctor.propTypes = {
  user: PropTypes.shape({
    name: PropTypes.string.isRequired,
  }).isRequired,
  signOut: PropTypes.func.isRequired,
}

export default function NavbarMenuForDoctor({ user, signOut }) {
  return (
    <div className="navbar-collapse collapse">
      <ul className="nav navbar-nav call-navbar">
        <li><Link to="/d/workspace" activeClassName="is-active">Workspace</Link></li>
        <li>
          <Link
            to="/d/appointment_settings"
            activeClassName="is-active"
          >
              Edit appointment time
          </Link>
        </li>
      </ul>
      <ul className="nav navbar-nav navbar-right">
        <NotificationCenterContainer />
        <NavDropdown title={`Doctor ${truncate(user.name, { length: 20 })}`}>
          <ul className="dropdown-menu" role="menu">
            <li><a href="/d/me">Edit Profile</a></li>
            <li><Link to="/d/account">Edit Bank Account</Link></li>
          </ul>
        </NavDropdown>
        <li>
          <a onClick={signOut}><b>Sign Out</b></a>
        </li>
      </ul>
    </div>
  )
}
