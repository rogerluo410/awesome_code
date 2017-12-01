import { APPOINTMENTSETTINGS } from './actions'

const initState = {
  isProcessing: false,
  isUpdateing: false,
  errorMessage: '',
  settingsByWeekday: [],
}

export default function appointmentSettingsReducer(state = initState, action) {
  switch (action.type) {
    case APPOINTMENTSETTINGS.FETCH_REQUEST:
      return {
        ...state,
        isProcessing: true,
      }
    case APPOINTMENTSETTINGS.FETCH_SUCCESS:
      return {
        ...state,
        settingsByWeekday: action.payload,
      }
    case APPOINTMENTSETTINGS.FETCH_FAILURE:
      return {
        ...state,
        isProcessing: false,
      }
    case APPOINTMENTSETTINGS.UPDATE_REQUEST:
      return {
        ...state,
        isUpdateing: true,
      }
    case APPOINTMENTSETTINGS.UPDATE_FAILURE:
      return {
        ...state,
        isUpdateing: false,
      }
    case APPOINTMENTSETTINGS.UPDATE_SUCCESS: {
      const settingsByWeekday = state.settingsByWeekday.map(setting => {
        if (setting.id === action.payload.id) {
          return action.payload
        }
        return setting
      })

      return {
        ...state,
        isUpdateing: false,
        settingsByWeekday,
      }
    }
    default:
      return state
  }
}
