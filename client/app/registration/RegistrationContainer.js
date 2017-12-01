import React, { Component, PropTypes } from 'react'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux'
import { Modal, FormGroup, FormControl } from 'react-bootstrap'
import validator from 'validator'
import * as Actions from './actions'

class Registration extends Component {
  static propTypes = {
    actions: PropTypes.object.isRequired,
    visiable: PropTypes.bool.isRequired,
    enabled: PropTypes.bool.isRequired,
    errorMessage: PropTypes.string,
  }

  constructor(props) {
    super(props)
    this.state = {
      email: '',
      valid: false,
      clearError: true,
    }
  }

  getValidationState() {
    if (this.props.errorMessage && !this.state.clearError) return 'error'

    if (this.state.email) {
      if (this.state.valid) {
        return 'success'
      }
      return 'error'
    }
    return undefined
  }

  handleChange = (e) => {
    const currentEmail = e.target.value
    const isValid = validator.isEmail(currentEmail)
    this.setState({
      email: currentEmail,
      valid: isValid,
      clearError: true,
    })
  }

  cancel = () => {
    this.props.actions.closeModal()
    this.setState({
      email: '',
      valid: false,
      clearError: true,
    })
  }

  register = () => {
    this.setState({
      clearError: false,
    })
    this.props.actions.register({
      data: {
        email: this.state.email,
      },
    })
  }

  render() {
    return (
      <div>
        <Modal show={this.props.visiable} onHide={this.cancel}>
          <Modal.Header closeButton>
            <Modal.Title></Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <form className="doc-login">
              <div className="doc-login-title mb-1">Sign up</div>
              <h4>
                Enter your email address for quick registration
                and proceed to your video consultatio
              </h4>
              <FormGroup
                controlId="formBasicText"
                validationState={this.getValidationState()}
              >
                <div className="doc-login-pws">
                  <FormControl
                    type="text"
                    value={this.state.email}
                    placeholder="Please enter your email"
                    onChange={this.handleChange}
                    calssName="form-control"
                  />
                </div>
                <FormControl.Feedback />
              </FormGroup>
              {this.props.errorMessage ===
                'This email has already registered, please login directly.' &&
                <FormGroup>
                  <FormControl.Static>
                    Your already has an account, please
                    <a href={`/users/sign_in?email=${this.state.email}`}> Sign In</a>
                  </FormControl.Static>
                </FormGroup>
              }
              <div
                className="btn m-btn is-green"
                disabled={!this.state.valid || !this.props.enabled}
                onClick={this.register}
              >
                Getting Started
              </div>
              <h5 className="doc-login-desc">
                We hate SPAM and promise to keep your email address safe
              </h5>
            </form>
          </Modal.Body>
        </Modal>
      </div>
    )
  }
}


function mapStateToProps(state) {
  return {
    visiable: state.registration.visiable,
    enabled: state.registration.enabled,
    errorMessage: state.registration.errorMessage,
  }
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(Actions, dispatch),
  }
}

const RegistrationContainer = connect(mapStateToProps, mapDispatchToProps)(Registration)

export default RegistrationContainer
