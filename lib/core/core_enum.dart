enum CoreEnumLocale {
  enUs("en-US"),
  zhHk("zh-HK"),
  zhCn('zh-CN');

  final String value;

  const CoreEnumLocale(this.value);

  @override
  String toString() => value;
}

enum CoreEnumCompany { skhwc, mwb }

enum CoreEnumStorage {
  like,
  dislike,
  centerCode,
  bookList,
  pickedBookList,
  bookPreferenceList,
}

enum CoreEnumStep { prev, next, parallel }

enum CoreEnumBrs { token, scopeList, imageByte, openDialog }

enum CoreEnumDisplay {
  appBar,
  drawer,
  floatingActionButton,
  bottomNavigationBar,
}

enum CoreEnumMembership { bronze, silver, gold, platinum, diamond }

enum CoreEnumRoute {
  root('/'),
  test('/test'),

  screenSplash('/screen/splash'),
  screenOnboard('/screen/onboard'),
  screenLoad('/screen/load'),

  aiBook('/ai/book'),

  authLogin('/auth/login'),
  authRegister('/auth/register'),
  authLogout('/auth/logout'),
  authResetPassword('/auth/reset_password'),
  authForgetPassword('/auth/forget_password'),

  menuLogin('/menu/login'),
  menuFood('/menu/food'),
  menuOrder('/menu/order'),

  userProfile('/user/profile'),
  userUpdateUser('/user/update_user'),
  userUpdateAuth('/user/update_auth'),
  userActivity('/user/activity'),
  userSetting('/user/setting'),

  orderRule('/order/rule'),
  orderMenu('/order/menu'),
  orderCart('/order/cart'),
  orderSummary('/order/summary'),
  orderConfirmation('/order/confirmation'),

  scanCamera('/scan/camera'),
  scanUsbScanner('/scan/usb_scanner'),
  
  suggestionBook('/suggestion/book'),

  transitionScan('/transition/scan'),

  tableOrder('/table/order'),
  testParam('/test/param'),

  paymentCreditCard('/payment/credit_card'),
  paymentDebitCard('/payment/debit_card'),
  paymentPayPal('/payment/paypal'),
  paymentApplePay('/payment/apple_pay'),
  paymentGooglePay('/payment/google_pay'),
  paymentCash('/payment/cash'),
  paymentBankTransfer('/payment/bank_transfer'),

  errorNotFound('/error/not_found'),
  errorServer('/error/server_error'),
  errorUnauthorized('/error/unauthorized'),
  errorPaymentFailed('/error/payment_failed'),
  errorItemUnavailable('/error/item_unavailable'),
  errorNetwork('/error/network_error'),
  errorTimeout('/error/timeout'),
  errorInvalidInput('/error/invalid_input'),
  errorOrderCancellation('/error/order_cancellation'),
  errorSessionExpired('/error/session_expired');

  final String value;

  const CoreEnumRoute(this.value);

  static CoreEnumRoute? toCoreEnum(String route) {
    return CoreEnumRoute.values.firstWhere(
      (enumRoute) => enumRoute.value == route,
    );
  }

  @override
  String toString() => value;
}

enum CoreEnumTab { auth, user, activity, transaction }

enum CoreEnumData { title, content, body }

enum CoreEnumSchool { primary, secondary, postSecondary }

enum CoreEnumProject {
  mwb, // my world box
  brs, // book recommendation system
  fos, // food ordering system
}

enum CoreEnumAsset {
  motto,
  orderRule,
  background,
  logo,
  locale,
  domain,
  phoneNumber,
  favicon,
  faceScan,
  bookFold,
}

enum CoreEnumDomain {
  organization,
  company,
  university,
  universityExtensionArm,
}

enum CoreEnumInput {
  type,
  label,

  // Personal Details
  nameFirst,
  nameLast,
  nameMiddle,
  nameCompany,
  nameUser,
  dateOfBirth,
  gender,
  nationality,
  maritalStatus,
  occupation,
  typeBlood,
  preferredLanguage,
  timeZone,
  domain,

  // Contact Information
  phoneNumberPrimary,
  phoneNumberAlternate,
  phoneNumberEmergencyContact,
  mailPersonal,
  mailWork,
  mailSchool,
  address,
  city,
  state,
  postalCode,
  countryCode,
  centerCode,

  // Identification
  id,
  numberIdCard,
  numberSocialSecurity,
  numberPassport,
  numberDriversLicense,

  // Account Details
  password,
  securityQuestion,
  securityAnswer,
  twoFactorAuth,
  accountStatus,
  lastLogin,
  registrationDate,
  referralCode,

  // Social Media
  idTelegram,
  idInstagram,
  idFacebook,
  idTwitter,
  idLinkedIn,

  // Miscellaneous
  key,
  datetime,
  profilePicture,
  urlWebsite,
  membership,
  emailSubscription,
}

enum CoreEnumItemType {
  accordion,
  appBar,
  autocomplete,
  avatar,
  badge,
  bottomNavigation,
  breadcrumb,
  button,
  buttonGroup,
  calendar,
  card,
  checkbox,
  chip,
  circularProgress,
  collapse,
  container,
  datePicker,
  dialog,
  section,
  dropdown,
  drawer,
  expansionPanel,
  fab,
  formControl,
  grid,
  iconButton,
  input,
  inputAdornment,
  list,
  listItem,
  listItemText,
  menu,
  menuItem,
  modal,
  paper,
  pagination,
  popover,
  progress,
  radio,
  select,
  slider,
  snackbar,
  stepper,
  switchControl,
  tab,
  table,
  textField,
  toolbar,
  tooltip,
  typography,
}

enum CoreEnumWidget {
  imageLogo,
  imageBg,
  imageIntro,
  banner,
  space,
  textTime,
  textTopic,
  buttonScanner,
  buttonExist,
  buttonNextPage,
}
