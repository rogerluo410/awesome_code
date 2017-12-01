import validator from 'validator'

export default function validate(values) {
  const errors = {}

  if (!values.number || validator.isNull(`${values.number}`)) {
    errors.number = 'Must be a valid card number'
  }

  return errors
}
