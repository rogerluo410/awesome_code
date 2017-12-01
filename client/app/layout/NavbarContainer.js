import React, { PropTypes } from 'react'
import { connect } from 'react-redux'
import Link from 'react-router/lib/Link'
import NavbarMenuForPatient from './NavbarMenuForPatient'
import NavbarMenuForDoctor from './NavbarMenuForDoctor'
import NavbarMenuForGuest from './NavbarMenuForGuest'
import { signOut } from '../auth/actions'

Navbar.propTypes = {
  auth: PropTypes.object.isRequired,
  signOut: PropTypes.func.isRequired,
}

// eslint-disable-next-line no-shadow
function Navbar({ auth, signOut }) {
  return (
    <div className="doc-Header doc-Header--mainView u-clearFix">
      <div className="doc-Header-logo">
        <Link to="/"><img src="/static/image/logo.png" alt="Shinetech Demo" /></Link>
      </div>
        {auth.isSignedIn
         ? NavbarForPatientOrDoctor(auth, signOut)
         : <NavbarMenuForGuest />
       }
    </div>
  )
}

function NavbarForPatientOrDoctor(auth, signOut) {
  switch (auth.user.type) {
    case 'Doctor':
      return (<NavbarMenuForDoctor user={auth.user} signOut={signOut} />)
    case 'Patient':
      return (<NavbarMenuForPatient user={auth.user} signOut={signOut} />)
    default:
      return (<NavbarMenuForGuest />)
  }
}

function mapPropsToState(state) {
  return {
    auth: state.auth,
  }
}

// FIXME use pure: false to fix react-router active link bug
// see: https://github.com/reactjs/react-router/issues/3536
export default connect(mapPropsToState, { signOut }, null, { pure: false })(Navbar)
