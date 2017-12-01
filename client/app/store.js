import { createStore, applyMiddleware } from 'redux'
import browserHistory from 'react-router/lib/browserHistory'
import { routerMiddleware } from 'react-router-redux'
import thunk from 'redux-thunk'
import rootReducer from './reducer'
import apiMiddleware from './api/middleware'

let initState

if (window.INIT_STATE) {
  initState = window.INIT_STATE
  delete window.INIT_STATE
} else {
  initState = {}
}

const middlewares = [
  thunk,
  apiMiddleware,
  routerMiddleware(browserHistory),
]

if (process.env.NODE_ENV === 'development') {
  const createLogger = require('redux-logger')
  const logger = createLogger({ collapsed: true })
  middlewares.push(logger)
}

const store = createStore(
  rootReducer,
  initState,
  applyMiddleware(...middlewares)
)

export default store
