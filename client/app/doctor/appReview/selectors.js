import pick from 'lodash/pick'
import { getEntity, getAssocEntity } from 'app/api/selectors'

export function getAppReview(state) {
  const appReview = state.doctor.appReview

  const app = getEntity(state, 'docAppointments', appReview.id)
  const survey = app && getAssocEntity(state, app, 'survey')

  return {
    ...pick(appReview, ['isShown', 'isFetching', 'isSubmitting']),
    app,
    survey,
  }
}
