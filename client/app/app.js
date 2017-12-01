import React from 'react'
import { render } from 'react-dom'
import { Provider } from 'react-redux'
import Router from 'react-router/lib/Router'
import Route from 'react-router/lib/Route'
import IndexRedirect from 'react-router/lib/IndexRedirect'
import browserHistory from 'react-router/lib/browserHistory'
import { syncHistoryWithStore } from 'react-router-redux'
import store from './store'
import MainLayout from './layout/MainLayout'
import DoctorsPageContainer from './doctors/DoctorsPageContainer'
import { PatientDomain, DoctorDomain } from './auth/AuthComponents'
import DashboardContainer from './patient/dashboard/DashboardContainer'
import CheckoutListContainer from './patient/checkouts/CheckoutListContainer'
import NotificationPageContainer from './notifications/NotificationPageContainer'
import ASettingsContainer from './doctor/appointment_settings/AppointmentSettingsContainer'
import DoctorConferenceContainer from './doctor/conferences/DoctorConferenceContainer'
import PatientConferenceContainer from './patient/conferences/PatientConferenceContainer'
import WorkspaceContainer from './doctor/workspace/WorkspaceContainer'
import PatAppointmentDetailContainer from './patient/appointmentDetail/AppointmentDetailContainer'
import PharmacyListContainer from './patient/pharmacies/PharmacyListContainer'
import DoctorDetailPage from './doctorDetail/DoctorDetailPage'
import BankAccountContainer from './doctor/bankAccount/BankAccountContainer'

if (process.env.NODE_ENV === 'development') {
  require('./dev-helpers')
}

const history = syncHistoryWithStore(browserHistory, store)

render(
  <Provider store={store}>
    <Router history={history}>
      <Route component={MainLayout}>
        <Route path="/" component={DoctorsPageContainer} />
        <Route path="doctors/:id" component={DoctorDetailPage} />

        <Route path="/p" component={PatientDomain}>
          <Route path="dashboard" component={DashboardContainer} />
          <Route path="conference/:appointmentId" component={PatientConferenceContainer} />
          <Route path="checkouts" component={CheckoutListContainer} />
          <Route path="appointments/:appointmentId/pharmacies" component={PharmacyListContainer} />
          <Route path="appointments/:appointmentId" component={PatAppointmentDetailContainer} />
        </Route>

        <Route path="/d" component={DoctorDomain}>
          <IndexRedirect to="workspace" />
          <Route path="appointment_settings" component={ASettingsContainer} />
          <Route
            path="conference/:appointmentId"
            component={DoctorConferenceContainer}
          />
          <Route path="workspace" component={WorkspaceContainer} />
          <Route path="account" component={BankAccountContainer} />
        </Route>

        <Route path="notifications" component={NotificationPageContainer} />

      </Route>
    </Router>
  </Provider>,
  document.getElementById('root')
)
