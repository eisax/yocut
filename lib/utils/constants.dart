

//database urls
//Please add your admin panel url here and make sure you do not add '/' at the end of the url
import 'package:yocut/utils/labelKeys.dart';

const String baseUrl = "";

const String databaseUrl = "$baseUrl/api/";

//Socket url
const String socketUrl = "";
//error message display duration
const Duration errorMessageDisplayDuration = Duration(milliseconds: 3000);

//Web socket ping interval
const Duration socketPingInterval = Duration(seconds: 275);

//home menu bottom sheet animation duration
const Duration homeMenuBottomSheetAnimationDuration =
    Duration(milliseconds: 300);

//Change slider duration
const Duration changeSliderDuration = Duration(seconds: 5);

//Number of latest notices to show in home container
const int numberOfLatestNoticesInHomeScreen = 3;

//notification channel keys
const String notificationChannelKey = "basic_channel";

//Set demo version this when upload this code to codecanyon
const bool isDemoVersion = false;

//to enable and disable default credentials in login page
const bool showDefaultCredentials = true;
//default credentials of student
const String defaultStudentGRNumber = "";
const String defaultStudentPassword = "";
//default credentials of parent
const String defaultParentEmail = "";
const String defaultParentPassword = "";
// Default school code
const String defaultSchoolCode = "";

//animations configuration
//if this is false all item appearance animations will be turned off
const bool isApplicationItemAnimationOn = true;
//note: do not add Milliseconds values less then 10 as it'll result in errors
const int listItemAnimationDelayInMilliseconds = 100;
const int itemFadeAnimationDurationInMilliseconds = 250;
const int itemZoomAnimationDurationInMilliseconds = 200;
const int itemBouncScaleAnimationDurationInMilliseconds = 200;

String getExamStatusTypeKey(String examStatus) {
  if (examStatus == "0") {
    return upComingKey;
  }
  if (examStatus == "1") {
    return onGoingKey;
  }
  return completedKey;
}

List<String> examFilters = [allExamsKey, upComingKey, onGoingKey, completedKey];

int getExamStatusBasedOnFilterKey({required String examFilter}) {
  ///[Exam status: 0- Upcoming, 1-On Going, 2-Completed, 3-All Details]
  if (examFilter == upComingKey) {
    return 0;
  }

  if (examFilter == onGoingKey) {
    return 1;
  }

  if (examFilter == completedKey) {
    return 2;
  }

  return 3;
}

const int minimumPasswordLength = 6;

const String stripePaymentMethodKey = "Stripe";
const String razorpayPaymentMethodKey = "Razorpay";

///[Payment transaction status this must be in sync with backend]
const String pendingTransactionStatusKey = "pending";
const String failedTransactionStatusKey = "failed";
const String succeedTransactionStatusKey = "succeed";

///[Socket events]
enum SocketEvent { register, message }

List<String> months = [
  januaryKey,
  februaryKey,
  marchKey,
  aprilKey,
  mayKey,
  juneKey,
  julyKey,
  augustKey,
  septemberKey,
  octoberKey,
  novemberKey,
  decemberKey
];
