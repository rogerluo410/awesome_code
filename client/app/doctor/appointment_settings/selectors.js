export function getWeekdayPlanSelector(state, props) {
  const settingsByWeekday = state.doctor.appointmentSettings.settingsByWeekday
  return {
    name: props.name,
    weekday_plan: settingsByWeekday.filter(item => item.id === props.value)[0],
  }
}

