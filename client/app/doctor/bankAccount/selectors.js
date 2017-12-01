import { getEntity } from 'app/api/selectors'

export function getBankAccountSelector(state) {
  const obj = state.doctor.bankAccount
  const bankAccount = obj.id ? getEntity(state, 'bankAccounts', obj.id) : null

  return {
    isFetching: obj.isFetching,
    deleting: obj.deleting,
    bankAccount,
  }
}
