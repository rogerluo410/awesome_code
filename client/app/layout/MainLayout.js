import React, { PropTypes } from 'react'
import FlashContainer from 'app/flash/FlashContainer'
import NavbarContainer from './NavbarContainer'
import RegistrationContainer from './../registration/RegistrationContainer'
import SurveyModalContainer from 'app/patient/surveys/SurveyModalContainer'
import PayModalContainer from 'app/patient/pays/PayModalContainer'
import CheckoutModalContainer from 'app/patient/checkouts/CheckoutModalContainer'
import CheckoutPayModalContainer from 'app/patient/checkouts/CheckoutPayModalContainer'
import CommentListModalContainer from 'app/comments/CommentListModalContainer'
import CallPromptContainer from 'app/prompts/CallPromptContainer'
import AppReviewModalContainer from 'app/doctor/appReview/AppReviewModalContainer'
import AttachmentsModalContainer from 'app/doctor/attachments/AttachmentsModalContainer'
import BankAccountFormModalContainer from 'app/doctor/bankAccount/BankAccountFormModalContainer'

MainLayout.propTypes = {
  children: PropTypes.element.isRequired,
}

function MainLayout(props) {
  return (
    <div>
      <FlashContainer />

      <NavbarContainer />
      {props.children}
      <Footer />
      <RegistrationContainer />
      <SurveyModalContainer />
      <PayModalContainer />
      <CheckoutModalContainer />
      <CheckoutPayModalContainer />
      <CommentListModalContainer />
      <CallPromptContainer />
      <AppReviewModalContainer />
      <AttachmentsModalContainer />
      <BankAccountFormModalContainer />
    </div>
  )
}

function Footer() {
  return (
    <div className="doc-footer">
      <div className="row u-container">
        <div className="col-sm-5 contact">
          <h3 className="contact-header">Contact Us</h3>
          <div className="contact-content">
            <span className="contact_email">
              <a href="mailto:">e: www.shinetechsoftware.com</a>
            </span>
            <span className="contact_site">w: www.shinetechsoftware.com </span>
            <p className="doc-footer-desc">
              Sit in the privacy of your home,
              office or car adn video conference a
              doctor using your mobile, tablet or computer.
            </p>
          </div>
        </div>
        <div className="col-sm-4 qlinks">
          <h3 className="qlinks-header">Quick links</h3>
          <div className="qlinks-content">
            <a href="#">Frequently Asked Questions</a>
            <a href="#">Support</a>
            <a href="#">Contact</a>
            <a href="#">How it works</a>
            <a href="#">For Businesses</a>
          </div>
        </div>
        <div className="col-sm-3">
          <h3 className="social-header">Social</h3>
          <div className="social-content">
            <p>Follow Us on</p>
            <div className="iconBox">
              <a href="#" className="facebook">
                <i className="fa fa-facebook fa-2x" aria-hidden="true"></i>
              </a>
              <a href="#" className="googlePlus">
                <i className="fa fa-google-plus fa-2x" aria-hidden="true"></i>
              </a>
              <a href="#" className="instagram">
                <i className="fa fa-instagram fa-2x" aria-hidden="true"></i></a>
              <a href="#" className="pinterest">
                <i className="fa fa-pinterest-p fa-2x" aria-hidden="true"></i>
              </a>
              <a href="#" className="twitter">
                <i className="fa fa-twitter fa-2x" aria-hidden="true"></i>
              </a>
            </div>
          </div>
        </div>
        <div className="col-sm-12">
          <div className="copyright">Copyright All Rights Reserved Shinetechsoftware</div>
        </div>
      </div>
    </div>
  )
}

export default MainLayout
