import moment from 'moment-timezone'
import lodash from 'lodash'
import axios from 'axios'
import api from 'app/api/api'

// Expose some modules to window for development convenience
window.axios = axios
window.moment = moment
window.lodash = lodash
window.api = api
