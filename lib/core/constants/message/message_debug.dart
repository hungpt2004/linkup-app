class MessageDebug {
  // FRIEND
  static get fetchListFail => 'Fetch list friends fail';
  static get fetchListSuccess => 'Fetch list friends success';
  static get fetchObjectFail => 'Fetch friend detail fail';
  static get fetchObjectSuccess => 'Fetch friend detail success';
  static get fetchListRequestSuccess => 'Fetch list request success';
  static get fetchListRequestFail => 'Fetch list request fail';
  static get acceptSuccess => 'Accept friend success';
  static get acceptFail => 'Accept friend fail';
  static get addSuccess => 'Add friend request sent success';
  static get addFail => 'Add friend request sent fail';
  static get rejectSuccess => 'Reject friend request success';
  static get rejectFail => 'Reject friend request fail';
  // AUTH

  // FOLLOW

  //

  static String messageCatch(String error) => error.toString();
}
