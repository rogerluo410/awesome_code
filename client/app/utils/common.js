export const timeList = [
  { value: '00', name: '12AM' },
  { value: '01', name: '01AM' },
  { value: '02', name: '02AM' },
  { value: '03', name: '03AM' },
  { value: '04', name: '04AM' },
  { value: '05', name: '05AM' },
  { value: '06', name: '06AM' },
  { value: '07', name: '07AM' },
  { value: '08', name: '08AM' },
  { value: '09', name: '09AM' },
  { value: '10', name: '10AM' },
  { value: '11', name: '11AM' },
  { value: '12', name: '12PM' },
  { value: '13', name: '01PM' },
  { value: '14', name: '02PM' },
  { value: '15', name: '03PM' },
  { value: '16', name: '04PM' },
  { value: '17', name: '05PM' },
  { value: '18', name: '06PM' },
  { value: '19', name: '07PM' },
  { value: '20', name: '08PM' },
  { value: '21', name: '09PM' },
  { value: '22', name: '10PM' },
  { value: '23', name: '11PM' },
  { value: 'end_of_day', name: 'End day' },
]

export const weekdayList = [
  { value: 'monday', name: 'MON' },
  { value: 'tuesday', name: 'TUE' },
  { value: 'wednesday', name: 'WED' },
  { value: 'thursday', name: 'THU' },
  { value: 'friday', name: 'FRI' },
  { value: 'saturday', name: 'SAT' },
  { value: 'sunday', name: 'SUN' },
]

const weekdayMap = weekdayList.reduce((acc, i) => {
  // eslint-disable-next-line no-param-reassign
  acc[i.value] = i.name
  return acc
}, {})

export const monthList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

const CARD_LIST = {
  Visa: 'cc-visa',
  'American Express': 'cc-amex',
  MasterCard: 'cc-mastercard',
  Discover: 'cc-discover',
  JCB: 'cc-jcb',
  'Diners Club': 'cc-diners-club',
}

function generateYearList() {
  const today = new Date
  let yyyy = today.getFullYear()

  const years = []

  for (let i = 0; i < 20; i++, yyyy++) {
    years.push(yyyy)
  }
  return years
}

export const yearList = generateYearList()

export function arrayToHash(array) {
  const hash = {}
  array.forEach(i => { hash[i.id] = i })
  return hash
}

export function getWeekdayName(weekday) {
  return weekdayMap[weekday]
}

export function getCardBrandIcon(brand) {
  return CARD_LIST[brand] || 'cc'
}
