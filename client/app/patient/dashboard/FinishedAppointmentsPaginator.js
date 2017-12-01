import connectPaginator from 'app/shared/pagination/connectPaginator'
import { gotoPage } from './actions'

export default connectPaginator('patient.appointments.finishedAppointments', { gotoPage })
