import { UserAuthWrapper } from 'redux-auth-wrapper'
import { routerActions } from 'react-router-redux'
import { getCurrentUserSelector } from './selectors'

const wrapperOptions = {
  authSelector: getCurrentUserSelector,
  failureRedirectPath: '/sign_in', // customize it to fit your need.
  redirectAction: routerActions.replace,
}

export const PatientAuth = UserAuthWrapper({
  ...wrapperOptions,
  wrapperDisplayName: 'PatronAuth',
  predicate: user => user.type === 'Patient',
})

export const PatientDomain = PatientAuth(props => props.children)

export const DoctorAuth = UserAuthWrapper({
  ...wrapperOptions,
  wrapperDisplayName: 'DoctorAuth',
  predicate: user => user.type === 'Doctor',
})

export const DoctorDomain = DoctorAuth(props => props.children)
