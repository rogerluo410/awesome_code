import validator from 'validator'

export default function validate(values) {
  const errors = {}
  if (validator.isNull(`${values.full_name}`)) {
    errors.full_name = 'full_name is required'
  }
  if (validator.isNull(`${values.suburb}`)) {
    errors.suburb = 'Suburb is required'
  }
  if (validator.isNull(`${values.street_address}`)) {
    errors.street_address = 'Address is required'
  }

  return errors
}
