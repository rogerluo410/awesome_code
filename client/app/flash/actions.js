export const FLASH = {
  ADD_MESSAGE: 'FLASH/ADD_MESSAGE',
}

// The opts is the notification in react-notification-system
// The most common attributes are: title, message, level
// See https://www.npmjs.com/package/react-notification-system
export function addFlashMessage(opts) {
  return {
    type: FLASH.ADD_MESSAGE,
    payload: opts,
  }
}
