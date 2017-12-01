import validator from 'validator'

export default function validate(values) {
  const errors = {}

  if (!values.body || validator.isNull(`${values.body}`)) {
    errors.body = 'Body canot be blank'
  }

  return errors
}
