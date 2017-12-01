import { routerActions } from 'react-router-redux'

export function gotoPage(page) {
  return routerActions.replace({
    pathname: location.pathname,
    query: { page },
  })
}
