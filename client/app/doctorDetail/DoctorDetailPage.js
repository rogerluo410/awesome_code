import React, { Component } from 'react'
import DoctorContainer from './doctor/DoctorContainer'
import TodayTimeContainer from './todayTime/TodayTimeContainer'

// eslint-disable-next-line react/prefer-stateless-function
export default class DoctorDetailPage extends Component {
  render() {
    return (
      <div>
        <DoctorContainer {...this.props} />
        <div className="">
          <div className="doc-detail-schedule  u-clearFix">
            <div className="u-container">
              <TodayTimeContainer {...this.props} />
            </div>
          </div>
          <div className="doc-detail-warn">
            <div className="u-container">
              <div className="textCard">
                <div className="textCard-title">
                  WARNING
                </div>
                <div className="textCard-body">
                  <p>
                    Lorem ipsum dolor sit amet,
                    consectetuer adipiscing elit,
                    sed diam nonummy nibh euismod orem ipsum dolor sit amet,
                    consectetuer adipiscing elit,
                    sed diam nonummy nibh euismod tincidunt ut
                    laoreet dolore magna aliquam erat volutpat.
                  </p>
                  <p>
                    Lorem ipsum dolor sit amet, consectetuer adipiscing elit,
                    sed diam nonummy nibh euismod orem ipsum dolor sit amet,
                    consectetuer adipiscing elit, sed diam nonummy nibh euismod
                    tincidunt ut laoreet dolore magna aliquam erat volutpat.
                  </p>
                </div>
              </div>
              <div className="imageText u-clearFix">
                <div className="col-lg-4 col-md-4">
                  <div className=" u-cricleImg">
                    <img src="/static/image/slice1.png" alt="slice1" />
                  </div>
                  <div className="imageText-title">
                    Verified Doctors
                  </div>
                  <div className="imageText-dsc">
                    All Doctors go through a stringent verification process on our site
                  </div>
                </div>
                <div className="col-lg-4 col-md-4">
                  <div className="u-cricleImg">
                    <img src="/static/image/slice2.png" alt="slice2" />
                  </div>
                  <div className="imageText-title">
                    100% Privacy Protection
                  </div>
                  <div className="imageText-dsc">
                    All Doctors go through a stringent verification process on our site
                  </div>
                </div>
                <div className="col-lg-4 col-md-4">
                  <div className="u-cricleImg">
                    <img src="/static/image/slice3.png" alt="slice3" />
                  </div>
                  <div className="imageText-title">
                    Satisfaction Guaranteed
                  </div>
                  <div className="imageText-dsc">
                    All Doctors go through a stringent verification process on our site
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
