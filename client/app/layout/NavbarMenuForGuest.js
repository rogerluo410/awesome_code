import React from 'react'

export default function NavbarMenuForGuest() {
  return (
    <div className="doc-Header-loginBtnGroup">
      <a href="/users/sign_in" className="btn btn-default">Login</a>
      <a href="/patients/sign_up" className="btn btn-link">Sign up</a>
    </div>
  )
}
