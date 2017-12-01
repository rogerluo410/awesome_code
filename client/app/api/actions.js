export const CALL_API = Symbol('CALL_API')

/**
 * Generate an API action. It needs the response to fit the JSON API standard.
 * The response data will be normalized into state.apiEntities.
 *
 * Examples
 *
 *     // Fetch a single entity
 *     callAPI({
 *       url: '/v1/d/appointments/upcoming',
 *       method: 'get',
 *       actions: [
 *         UPCOMING_APPOINTMENT.FETCH,
 *         UPCOMING_APPOINTMENT.FETCH_SUCCESS,
 *         UPCOMING_APPOINTMENT.FETCH_FAIL,
 *       ],
 *     })
 */
export function callAPI(opts) {
  return { [CALL_API]: opts }
}
