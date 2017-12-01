import validator from 'validator'

export default function validate(values) {
  const errors = {}

  if (!values.number || validator.isNull(`${values.number}`)) {
    errors.number = 'number is required'
  }
  if (!values.cvc || validator.isNull(`${values.cvc}`)) {
    errors.cvc = 'cvc is required'
  }

  return errors
}
