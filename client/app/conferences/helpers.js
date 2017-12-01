import toInteger from 'lodash/toInteger'

function secondsToTimeString(seconds) {
  let min = String(parseInt((seconds / 60), 10))
  let sec = String(parseInt((seconds % 60), 10))
  const completor = '0'
  const divider = ':'
  if (min < 10) { min = completor.concat(min) }
  if (sec < 10) { sec = completor.concat(sec) }
  return min.concat(divider).concat(sec)
}

function secondsToTimeFormat(seconds) {
  const min = toInteger(seconds / 60)
  const sec = toInteger(seconds % 60)
  return `${min}min ${sec}sec`
}

export {
  secondsToTimeString,
  secondsToTimeFormat,
}
