// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'XISTI';

  @override
  String get tagline => 'Easy and Safe';

  @override
  String get splashScreenMsg =>
      'Easy and Safe — negotiate your fare in Medellín.';

  @override
  String get year => 'year';

  @override
  String get years => 'years';

  @override
  String get month => 'month';

  @override
  String get months => 'months';

  @override
  String get week => 'week';

  @override
  String get weeks => 'weeks';

  @override
  String get day => 'day';

  @override
  String get days => 'days';

  @override
  String get hour => 'hour';

  @override
  String get hours => 'hours';

  @override
  String get minute => 'minute';

  @override
  String get minutes => 'Minutes';

  @override
  String get seconds => 'seconds';

  @override
  String get justNow => 'just now';

  @override
  String get ago => 'ago';

  @override
  String get serverError => 'Server Error';

  @override
  String get connectionLost => 'Connection Lost';

  @override
  String get ok => 'Ok';

  @override
  String get retry => 'Retry';

  @override
  String get serverErrorMessage =>
      'There seems to be a problem\nwith our server. Please try again later.';

  @override
  String get internetConnLostMessage =>
      'Unable to connect to the internet.\nPlease check your internet connection and try again.';

  @override
  String get apiErrorCancelMsg => 'The request to the API server was canceled';

  @override
  String get apiErrorConnectTimeoutMsg => 'Connection timeout with API server';

  @override
  String get apiErrorOtherMsg =>
      'You are offline please check your internet connection.';

  @override
  String get apiErrorReceiveTimeoutMsg =>
      'Receive timeout in connection with the API server';

  @override
  String get apiErrorResponseMsg => 'Received invalid status code';

  @override
  String get apiErrorSendTimeoutMsg =>
      'Send timeout in connection with the API server';

  @override
  String get apiErrorUnexpectedErrorMsg => 'Unexpected error occurred';

  @override
  String get apiErrorCommunicationMsg =>
      'An error occurred while communicating with the Server with StatusCode';

  @override
  String get newUpdateAvailable => 'New update is available!';

  @override
  String get newUpdateMsg =>
      'Please update the new app from the store for further access app.';

  @override
  String get update => 'Update';

  @override
  String get locationMessageTitle => 'Location permissions and data processing';

  @override
  String get locationMessage =>
      'XISTI uses device location to connect users and independent drivers through the platform.\n\nWhen the app is active or in the background, location may be used to:\n\n• Show nearby requests.\n• Improve trip accuracy.\n• Help users and drivers locate each other.\n• Keep availability updated within the platform.\n\nFeature: Technology platform connecting users and independent drivers.\n\nInformation will be processed according to our Privacy Policy and Personal Data Processing Policy.\n\nPlease allow \"Always\" location access if you are an independent driver.';

  @override
  String get preferences => 'Preferences';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectCurrency => 'Select Currency';

  @override
  String get preferenceMsg => 'You can change these settings later in the app.';

  @override
  String get obTitle1 => 'Your city, your route';

  @override
  String get obMsg1 =>
      'Set your destination in Medellín and match with an urban driver in minutes.';

  @override
  String get obTitle2 => 'Negotiate your fare';

  @override
  String get obMsg2 =>
      'Bid in 500 COP steps and agree a fair urban ride price.';

  @override
  String get obTitle3 => 'Ride with confidence';

  @override
  String get obMsg3 =>
      'Verified drivers, flexible payments, and XISTI: Easy and Safe.';

  @override
  String get login => 'Login';

  @override
  String get welcomeTo => 'Welcome to';

  @override
  String get loginYourAccount => 'Log in to Your Account';

  @override
  String get contactNumber => 'Contact Number';

  @override
  String get enterContactNumber => 'Enter Contact Number';

  @override
  String get sendOTP => 'Send OTP';

  @override
  String get orLoginWith => 'Or Login With';

  @override
  String get loginWithTouchID => 'Login with Touch ID/Face ID';

  @override
  String get enableTouchID => 'Enable Touch ID/Face ID';

  @override
  String get bioMetricsDisableMsg =>
      'You can activate this option once logged into the application.';

  @override
  String get bioMetricsPopupMsg =>
      'Scan your fingerprint OR face to authenticate.';

  @override
  String get authenticationRequired => 'Authentication required!';

  @override
  String get verifyIdentity => 'Verify identity';

  @override
  String get noThanks => 'No thanks';

  @override
  String get enterOTPSendNumber => 'Enter OTP sent to your number';

  @override
  String get enterOTPVerifyAccount => 'enter the OTP to verify your account.';

  @override
  String get continueTxt => 'Continue';

  @override
  String get resend => 'Resend';

  @override
  String get startYour => 'Start your';

  @override
  String get journeyWithUs => 'journey with us';

  @override
  String get registerAndStart => 'Register and start exploring!';

  @override
  String get haveNotCode => 'Haven’t received a code?';

  @override
  String get ifNotGetCode =>
      'If you didn’t get a code, please try one of the options below.';

  @override
  String get retryIn => 'Retry In';

  @override
  String get changeNumber => 'Change Number';

  @override
  String get sendAgain => 'Send Again';

  @override
  String get resendOtpSuccessMsg =>
      'Fresh OTP has been sent to your registered phone number';

  @override
  String get resendOtpWhatsappSuccessMsg => 'OTP resent via WhatsApp.';

  @override
  String get otpSentViaWhatsappHint =>
      'We can also send your code via WhatsApp.';

  @override
  String get yourName => 'Your Name';

  @override
  String get failed => 'Failed';

  @override
  String get email => 'Email address';

  @override
  String get referralCode => 'Referral Code';

  @override
  String get enterYourName => 'Enter Your Name';

  @override
  String get enterValidFullName =>
      'Enter a valid full name using letters and spaces only';

  @override
  String get enterEmailAddress => 'Enter Email Address';

  @override
  String get invalidEmailAddress => 'Invalid Email Address';

  @override
  String get byRegisterYouAgree => 'I have read and accept the';

  @override
  String get termsCondition => 'Terms and Conditions';

  @override
  String get privacyPolicy => 'Privacy and Personal Data Processing Policy';

  @override
  String get platformConnectionNotice =>
      'I understand that this is a technology platform connecting users with independent drivers, and does not provide transportation services or operate vehicles.';

  @override
  String get driverIndependentNotice =>
      'I declare that I act as an independent driver and that using the platform does not create any employment, subordination, commercial representation, or exclusivity relationship.';

  @override
  String get deliveryLegalNotice =>
      'Deliveries are package handoffs managed between users through the platform. The app only facilitates the connection and does not provide passenger or freight transport services.';

  @override
  String get agreeAndContinue => 'Agree and continue';

  @override
  String get marketingOptIn =>
      'I authorize receiving communications, news and promotions.';

  @override
  String get account => 'Account';

  @override
  String get driverMode => 'Driver Mode';

  @override
  String get passengerMode => 'User Mode';

  @override
  String get rideHistory => 'Ride History';

  @override
  String get notification => 'Notification';

  @override
  String get myWallet => 'My Wallet';

  @override
  String get referHistory => 'Refer History';

  @override
  String get liveChat => 'Live Chat';

  @override
  String get liveTrackingBadge => 'Live';

  @override
  String get estimatedArrival => 'Estimated arrival';

  @override
  String get myPreference => 'My Preferences';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get inviteFriend => 'Invite Friend';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get help => 'Help';

  @override
  String get manageAccount => 'Manage Account';

  @override
  String get agree => 'Agree';

  @override
  String get pickUpLocation => 'Pickup Location';

  @override
  String get dropLocation => 'Drop Location';

  @override
  String get cash => 'Cash';

  @override
  String get card => 'Card';

  @override
  String get wallet => 'Wallet';

  @override
  String get offerMyFare => 'Offer fare';

  @override
  String get fetchingLocation => 'Fetching Location';

  @override
  String get stopPoint => 'Stop Point';

  @override
  String get selectVehicle => 'Select Vehicle';

  @override
  String get setRoute => 'Set Route';

  @override
  String get setLocationOnMap => 'Set Location From Map';

  @override
  String get confirmLocation => 'Confirm Location';

  @override
  String get searchLocation => 'Search Location';

  @override
  String get selectYourLocation => 'Select Your Location';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get comments => 'Comments';

  @override
  String get writeYourComment => 'Write your comment';

  @override
  String get childSeatSafety => 'Child Safety Seat';

  @override
  String get handicapAccess => 'Handicap Accessibility';

  @override
  String get bookForOther => 'Book For Other';

  @override
  String get selectContactNumber => 'Select Contact Number';

  @override
  String get stop => 'Stop';

  @override
  String get km => 'Km';

  @override
  String get selectPickup => 'Select Pickup Location';

  @override
  String get selectDrop => 'Select Drop Location';

  @override
  String get selectStop => 'Select Stop Location';

  @override
  String get offerAmount => 'Offer Amount';

  @override
  String get enterFareValue => 'Enter Fare Value';

  @override
  String offerFareMin(String amount) {
    return 'You must pay a minimum of $amount';
  }

  @override
  String offerFareMax(String amount) {
    return 'You can Bid a Maximum of $amount';
  }

  @override
  String get scheduleRide => 'Schedule A Ride';

  @override
  String get autoAcceptDriverRide =>
      'Automatically accept the nearest driver for your fare';

  @override
  String get findDrive => 'Find A Driver';

  @override
  String get recommendedFare => 'Recommended fare';

  @override
  String get minFare => 'Min. fare';

  @override
  String get maxFare => 'Max. fare';

  @override
  String get fareEstimateDisclaimer =>
      'Estimate based on route, time and vehicle fare.';

  @override
  String get recipientName => 'Recipient\'s Name';

  @override
  String get recipientNumber => 'Recipient\'s Number';

  @override
  String get parcelEstimatedPrice => 'Parcel Estimated Value';

  @override
  String get parcelNote => 'Parcel Note';

  @override
  String get enterRecipientName => 'Enter Recipient\'s Name';

  @override
  String get enterRecipientNumber => 'Enter Recipient\'s Number';

  @override
  String get enterParcelEstimatedPrice => 'Enter Parcel Estimated Value';

  @override
  String get enterParcelNote => 'Enter Parcel Note';

  @override
  String get systemSelected => 'Automatic';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get selectAppTheme => 'Select App Theme';

  @override
  String get currentFare => 'Current Fare';

  @override
  String get cancelRide => 'Cancel Ride';

  @override
  String get raiseFare => 'Raise Fare';

  @override
  String get myDetails => 'My Details';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get cropper => 'Cropper';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String kmAway(String km) {
    return '$km km Away';
  }

  @override
  String get noRecordFound => 'Sorry !!\nNo Record Found This Time';

  @override
  String get manageDistance => 'Manage Distance';

  @override
  String get reset => 'Reset';

  @override
  String get apply => 'Apply';

  @override
  String get reject => 'Reject';

  @override
  String get accept => 'Accept';

  @override
  String get pleaseSelectADistance => 'Please select a distance.';

  @override
  String get trackLocationInBackground => 'Track location in the background';

  @override
  String changeRideFare(String name) {
    return '$name changed the ride fare.';
  }

  @override
  String get emailAddress => 'Email Address';

  @override
  String permissionText1(String appName) {
    return 'Allow $appName to display over Other apps';
  }

  @override
  String permissionText2(String appName) {
    return 'Allow $appName to display over Other apps in order to receive ride request when you’re online.';
  }

  @override
  String get permissionText3 =>
      'Tap Allow and set the toggle ON in the Settings screen.';

  @override
  String get permissionText4 =>
      'Set the Quick Access icon to on to see this icon over other apps';

  @override
  String get quickAccessIcon => 'Quick Access icon';

  @override
  String get settingsPermission => 'Go to Settings';

  @override
  String get yourDriverIsOnWay => 'Your driver is on their way';

  @override
  String get driverIsAtPickup => 'Driver is at your pickup point';

  @override
  String get driverHeadingDestination => 'Driver heading to destination';

  @override
  String get reachYourDestination => 'Reached your destination';

  @override
  String get call => 'Call';

  @override
  String get shareOTP => 'Share OTP';

  @override
  String get proceedToPay => 'Proceed to pay';

  @override
  String get pay => 'Pay';

  @override
  String get payment => 'Payment';

  @override
  String get insufficientWalletBalance =>
      'You can\'t pay the ride amount through Wallet because your wallet balance is insufficient.';

  @override
  String get onlinePayment => 'Online Payment';

  @override
  String get shareFeedBack => 'Share Feedback';

  @override
  String get writeYourFeedBack => 'Write your feedback';

  @override
  String get submit => 'Submit';

  @override
  String get giveFeedbackErrorMsg => 'Give your feedback!';

  @override
  String get rideDetail => 'Ride Details';

  @override
  String get downloadInvoice => 'Download Invoice';

  @override
  String get completed => 'Completed';

  @override
  String get pending => 'Pending';

  @override
  String get cancelled => 'Canceled';

  @override
  String get accepted => 'Accepted';

  @override
  String get running => 'Running';

  @override
  String get rideDateTime => 'Ride Date & Time';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get paymentStatus => 'Payment Status';

  @override
  String get bookingId => 'Booking ID';

  @override
  String get invoiceDetail => 'Invoice Details';

  @override
  String get okay => 'Okay';

  @override
  String get vehicleInformation => 'Vehicle Information';

  @override
  String get driverDetails => 'Driver Details';

  @override
  String get profileUpdateSuccessfully => 'Profile Update successfully.';

  @override
  String get txtToday => 'Today';

  @override
  String get txtUpcoming => 'Upcoming';

  @override
  String get txtLast7Days => 'Last 7 Days';

  @override
  String get txtThisMonth => 'Last 30 Days';

  @override
  String get txtYear => 'This Year';

  @override
  String get txtAll => 'All';

  @override
  String get sortByDays => 'Sort By Days';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get itemDesc => 'Item Description';

  @override
  String get courierDetail => 'Courier Details';

  @override
  String get courierDateTime => 'Courier Date & Time';

  @override
  String get rideCompleteByAdminMsg => 'Ride Completed by Admin';

  @override
  String get rideCancelByAdminMsg => 'Ride Cancelled by Admin';

  @override
  String get startRide => 'Start Ride';

  @override
  String get collectAmount => 'Collect Amount';

  @override
  String collectAmountMsg(String collectionAmount) {
    return 'Are you sure you have collected $collectionAmount from the customer?';
  }

  @override
  String get rideOTPVerifyMsg =>
      'Please get the OTP from the Customer and enter it here.';

  @override
  String get start => 'Start';

  @override
  String get collectPayment => 'Collect Payment';

  @override
  String get rateUser => 'Rate User';

  @override
  String get completeRide => 'Complete the ride';

  @override
  String get errorMessageCommon =>
      'Something went wrong, Giving it another shot after some time?';

  @override
  String get notifications => 'Notifications';

  @override
  String get min => 'min';

  @override
  String get other => 'Other';

  @override
  String get offerFare => 'Offer Fare';

  @override
  String get requiredMess => 'Please enter the below details.';

  @override
  String get cancel => 'Cancel';

  @override
  String get accountDelete => 'Delete Account';

  @override
  String get accountDeleteDialogMsg =>
      'Are you sure you want to delete your account? Any wallet balance will not be refunded.';

  @override
  String get logout => 'Logout';

  @override
  String get logOutDialogMsg =>
      'Are you sure you want to logout from your account?';

  @override
  String get arrived => 'Arrived';

  @override
  String get enterOtp => 'Enter Otp';

  @override
  String get numberOfToll => 'Number Of Tolls';

  @override
  String get tollAmount => 'Toll Amount';

  @override
  String get enterTollAmount => 'Enter toll amount';

  @override
  String get enterNumberOfToll => 'Enter number of tolls';

  @override
  String get reviewUser => 'Review User';

  @override
  String get reviewUserMsg => 'Rate User from 1 to 5 Star';

  @override
  String get showMore => 'More';

  @override
  String get showLess => 'Less';

  @override
  String get amount => 'Amount';

  @override
  String get claimed => 'Claimed';

  @override
  String get rejected => 'Rejected';

  @override
  String get manageAddress => 'Manage Address';

  @override
  String get home => 'Home';

  @override
  String get work => 'Work';

  @override
  String get addressDeletedSuccessMsg => 'Successfully deleted address';

  @override
  String get contactName => 'Contact Name';

  @override
  String get enterContactName => 'Enter Contact Name';

  @override
  String get sureToCancel => 'Are you sure, you want to cancel your ride?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get rideCancel => 'Ride Cancel';

  @override
  String get from => 'From';

  @override
  String get at => 'At';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get history => 'History';

  @override
  String get transfer => 'Transfer';

  @override
  String get topUp => 'TopUp';

  @override
  String get cashOut => 'Cash Out';

  @override
  String get all => 'All';

  @override
  String get credit => 'Credit';

  @override
  String get debit => 'Debit';

  @override
  String get transactionNotFound => 'Transaction not found';

  @override
  String get success => 'Success';

  @override
  String get successTransaction => 'You have successfully transferred';

  @override
  String get selectUser => 'Select User';

  @override
  String get searchByContactOrEmail => 'Search by Contact or Email';

  @override
  String get beneficial => 'Beneficial';

  @override
  String get beneficialContactNumber => 'Beneficial Contact Number';

  @override
  String get beneficialEmail => 'Beneficial Email';

  @override
  String get amountToTransfer => 'Amount to transfer';

  @override
  String get enterAmount => 'Enter Amount';

  @override
  String get youCantTransfer => 'You can\'t transfer more than';

  @override
  String get invalidAmountMsg => 'Enter valid amount';

  @override
  String get customer => 'Customer';

  @override
  String get driver => 'Driver';

  @override
  String get enterContactOrEmailToSearchPerson =>
      'Please enter the contact number or email to search for the person.';

  @override
  String get proceedToAddMoney => 'Proceed to add money';

  @override
  String get chooseAmount => 'Choose Amount';

  @override
  String get walletMinTopupNotice =>
      'Minimum top-up COP 13,000. XISTI commission is 8% — fair margin for drivers.';

  @override
  String get pleaseEnterAmount => 'Please enter or select the amount.';

  @override
  String get walletAddSuccessful => 'Wallet amount was added successfully';

  @override
  String get invalidRequestCashOutAmountMsg =>
      'You don\'t make cash out request more than your wallet balance';

  @override
  String get pleaseEnterRequestCashOutAmount =>
      'Please enter request cash out amount';

  @override
  String get enterValidRequestCashOutAmount =>
      'Enter valid request cash out amount';

  @override
  String get cashOutSuccess => 'CashOut Request Successfully!';

  @override
  String get requestToCash => 'Request to cash out';

  @override
  String get cashOutAmount => 'Cash out amount';

  @override
  String get newRequest => 'New Request';

  @override
  String get goBack => 'Go Back';

  @override
  String get searchingForRideRequests => 'Searching for ride requests\n';

  @override
  String get yourOfferIsBeingReviewedByCustomer =>
      'Your Offer is Being\nReviewed by Customer';

  @override
  String distanceKm(String km) {
    return 'Distance: $km km ';
  }

  @override
  String get reqRejectCustomer => 'Your Request was Rejected by the Customer.';

  @override
  String get enterCancelReason => 'Enter Cancel Reason';

  @override
  String get away => 'away';

  @override
  String get otp => 'OTP';

  @override
  String get rideCompleted => 'Ride Completed';

  @override
  String get rideCompletedMsg => 'Your Ride was Completed successfully.';

  @override
  String rideCancelBy(String name) {
    return 'Ride Cancelled by $name!';
  }

  @override
  String get rateDriver => 'Rate Driver';

  @override
  String get rideFare => 'Ride Fare';

  @override
  String get totalPay => 'Total Pay';

  @override
  String get referDiscount => 'Refer Discount';

  @override
  String get inviteFriends => 'Invite Friends';

  @override
  String get shareInvite => 'Share Invite';

  @override
  String get referFriendAndGetBenefits => 'Refer Friend & Get Benefits';

  @override
  String get inviteFriendsMsg =>
      'Invite Your Friend With This \nReferral Code To Get More Benfits';

  @override
  String get use => 'Use';

  @override
  String get referCodeGetDiscount => 'Referral Code and get a Discount';

  @override
  String get download => 'Download';

  @override
  String get emergencyContactNumber => 'Emergency Contact Number';

  @override
  String get emergencyContactAddMsg =>
      'You Can Add Emergency Contact \nNumber From Your Profile.';

  @override
  String get emergencyContactMsg =>
      'You Can Change Emergency Contact \nNumber From Your Profile.';

  @override
  String get emergencyCall => 'Emergency Call';

  @override
  String get addEmergencyContact => 'Add Emergency Contact';

  @override
  String get manageVehicle => 'Manage Vehicle';

  @override
  String get addAddress => 'Add Address';

  @override
  String get editAddress => 'Edit Address';

  @override
  String maxAddressMsg(int maxLimit) {
    return 'You can add max $maxLimit addresses. Delete the previous one before adding a new one';
  }

  @override
  String get saveAddress => 'Save Address';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAddress => 'Delete Address?';

  @override
  String get deleteAddressDialogMsg =>
      'Are you sure you want to delete this address?';

  @override
  String get noAnyAddressMsg =>
      'You have not added address. Please add address to use at ride book.';

  @override
  String get heatMap => 'HeatMap';

  @override
  String get writeAMessageHere => 'Write a message here';

  @override
  String get enterValidateNoTolls => 'Enter the valid number of tolls';

  @override
  String get enterValidateTollCharge => 'Enter the valid toll charge amount';

  @override
  String get whatWouldYouLikeToChoose => 'What Would You Like to Choose?';

  @override
  String get downloading => 'Downloading...';

  @override
  String get downloadingComplete => 'Downloading Complete';

  @override
  String get downloadingFailed => 'Downloading Failed';

  @override
  String get pdfDownloadSuccessful => 'PDF Download Successful!';

  @override
  String get downloadCancelled => 'Download Failed!';

  @override
  String get fillYourInformation => 'Fill Your Information';

  @override
  String driverRegisterMsg(String appName) {
    return 'Please fill in your personal information to start your earning with $appName';
  }

  @override
  String get close => 'Close';

  @override
  String get proceed => 'Proceed';

  @override
  String get manageInformation => 'Manage Information';

  @override
  String get drivingLicence => 'Driving Licence';

  @override
  String get addDocument => 'Add Document';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get selectExpiryDateHere => 'Select expiry date here...';

  @override
  String get uploadDocument => 'Upload Document';

  @override
  String get updateDocument => 'Update Document';

  @override
  String get selectDocument => 'Please select document';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get selectExpiryDate => 'Select Expiry Date';

  @override
  String get emptyDocument =>
      'No documents are pending upload. If you think this is an error, contact support.';

  @override
  String get document => 'Document';

  @override
  String get upload => 'Upload';

  @override
  String get add => 'Add';

  @override
  String get approved => 'Approved';

  @override
  String get noDocument => 'No Document';

  @override
  String get expired => 'Expired';

  @override
  String get customerDetails => 'Customer Details';

  @override
  String get rideEstimation => 'Ride Estimation';

  @override
  String get customerName => 'Customer Name';

  @override
  String get customerNumber => 'Customer Number';

  @override
  String get confirm => 'Confirm';

  @override
  String get addCustomerDetails => 'Add Customer Details';

  @override
  String get bankDetails => 'Bank Details';

  @override
  String get updateBankDetailSuccessMsg =>
      'Your bank details updated successfully!';

  @override
  String get enterAccountNumber => 'Enter Account Number';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get enterAccountHolderName => 'Enter Account Holder Name';

  @override
  String get accountHolderName => 'Account Holder Name';

  @override
  String get enterBankName => 'Enter Bank Name';

  @override
  String get bankName => 'Bank Name';

  @override
  String get enterBankLocation => 'Enter Bank Location';

  @override
  String get bankLocation => 'Bank Location';

  @override
  String get enterSwiftCode => 'Enter BIC/SWIFT Code';

  @override
  String get swiftCode => 'BIC/SWIFT Code';

  @override
  String get feedback => 'Feedback';

  @override
  String get rating => 'Rating';

  @override
  String get viewRide => 'View Ride';

  @override
  String get addIssue => 'Add Issue';

  @override
  String get myReportedIssue => 'My reported Issue';

  @override
  String get faq => 'FAQ';

  @override
  String get chooseAnOrderWithIssue => 'Choose an order with issue';

  @override
  String get reportGeneralIssue => 'Report General Issue';

  @override
  String get resolved => 'Resolved';

  @override
  String get unResolved => 'Unresolved';

  @override
  String get general => 'General';

  @override
  String get issueNotFound => 'Issue Not found';

  @override
  String get ticketId => 'Ticket ID';

  @override
  String get description => 'Description';

  @override
  String get enterDescription => 'Enter Description';

  @override
  String get deleteImage => 'Delete Image';

  @override
  String get deleteImageMsg => 'Are You Sure Want to Delete This Image?';

  @override
  String get rideId => 'Ride Id';

  @override
  String get orderNotFound => 'Order Not found';

  @override
  String uploadMinImagesMsg(int minIssueImageCount) {
    return 'Please Upload at least $minIssueImageCount images.';
  }

  @override
  String get chat => 'Chat';

  @override
  String get submitIssue => 'Submit Issue';

  @override
  String get manufactureName => 'Manufacture Name';

  @override
  String get modelName => 'Model Name';

  @override
  String get vehiclePlateNumber => 'Vehicle Plate Number';

  @override
  String get vehicleColor => 'Vehicle Color';

  @override
  String get vehicleYear => 'Vehicle Year';

  @override
  String get selectVehicleType => 'Select Vehicle Type';

  @override
  String get selectVehicleYear => 'Select Vehicle Year';

  @override
  String get selectItem => 'Select Item';

  @override
  String get enterManufactureName => 'Enter Manufacture Name';

  @override
  String get enterModelName => 'Enter Model Name';

  @override
  String get enterVehiclePlateNumber => 'Enter Vehicle Plate Number';

  @override
  String get enterVehicleColor => 'Enter Vehicle Color';

  @override
  String get done => 'Done';

  @override
  String get uploadVehicleImage => 'Upload Vehicle Image';

  @override
  String get imageUploaded => 'Image Uploaded';

  @override
  String get vehicleDetailsUploadedSuccessfully =>
      'Vehicle Details Uploaded Successfully.';

  @override
  String get cancellationReason => 'Cancellation reason';

  @override
  String get trackRide => 'Track ride';

  @override
  String get verificationPending => 'Verification Pending';

  @override
  String get driverBlock => 'Driver Blocked By Admin';

  @override
  String get pendingMessage =>
      'Thank you for your application and we will notify you by email once we review your uploaded documents.';

  @override
  String get driverRejectedByAdmin => 'Driver rejected by the admin';

  @override
  String get goToHome => 'Go To Home';

  @override
  String get hailModule => 'Please go online to hail the ride';

  @override
  String get noteFromCustomer => 'Note From Customer';

  @override
  String get yourAdditionalNote => 'Your additional note';

  @override
  String get passengerName => 'Passenger Name';

  @override
  String get submitOTP => 'Submit OTP';

  @override
  String get percentage => 'Percentage';

  @override
  String get cancelBy => 'Cancel By';

  @override
  String get schedule => 'Schedule';

  @override
  String get expiryDateValidation =>
      'Looks like your expiry date is in the past. Please check it.';

  @override
  String get selectScheduleDate => 'Select Schedule Date';

  @override
  String get googleMapsLimitMessage =>
      'You’ve reached your daily Google Maps usage limit. Please try again tomorrow.';

  @override
  String get usageLimitReached => 'Usage Limit Reached';

  @override
  String get processing => 'Processing';

  @override
  String get faceVerification => 'Face Verification';

  @override
  String get positionFaceInCircle => 'Position your face in the circle';

  @override
  String get blinkEyesNow => 'Now blink your eyes';

  @override
  String get verificationSuccessful => 'Verification Successful!';

  @override
  String get onlyOneFaceAllowed => 'Only one face allowed';

  @override
  String get cameraPermissionRequired => 'Camera Permission Required';

  @override
  String get cameraPermissionMessage =>
      'This app needs camera access to verify your identity. Please enable it in settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get noCamerasFound => 'No cameras found.';

  @override
  String get failedToCaptureImagePleaseTryAgain =>
      'Failed to capture image. Please try again.';

  @override
  String get loading => 'Loading';

  @override
  String get pleaseAddProfileImage =>
      'Please add your profile photo to continue.';

  @override
  String get profilePictureUpload => 'Upload profile picture';

  @override
  String get profilePictureUploadMsg =>
      'Profile picture is missing, upload profile picture to proceed orders.';

  @override
  String get platformCommission => 'Platform commission (8%)';

  @override
  String get vatOnCommission => 'VAT on commission (19%)';

  @override
  String get totalDeduction => 'Total deductions';

  @override
  String get netDriverEarnings => 'Net driver earnings';

  @override
  String get invalidMobileNumberCo => 'Enter a valid 10-digit mobile number';

  @override
  String get invalidVehiclePlate =>
      'Enter a valid plate (5 to 8 alphanumeric characters)';

  @override
  String get vehicleCarroEconomico => 'Economy car';

  @override
  String get vehicleCarroElectrico => 'Electric car';

  @override
  String get vehicleCarroComodo => 'Comfort car';

  @override
  String get vehicleMotoBajo => 'Low-displacement motorcycle';

  @override
  String get vehicleMotoAlto => 'High-displacement motorcycle';

  @override
  String get vehicleMoto => 'Motorcycle';

  @override
  String get vehicleCarro => 'Car';

  @override
  String get vehicleBicicleta => 'Bicycle';

  @override
  String get vehicleTrip => 'Trip';

  @override
  String get whereToBuy => 'Where to buy';

  @override
  String get whereToDeliver => 'Where to deliver';

  @override
  String get selectWhereToBuy => 'Select where to buy';

  @override
  String get selectWhereToDeliver => 'Select where to deliver';

  @override
  String get whatToBuyHint => 'What should they buy?';

  @override
  String get priceCapHint => 'Price cap (COP)';

  @override
  String get indicateWhatToBuy => 'Indicate what you want them to buy';

  @override
  String get indicatePriceCap => 'Indicate the price cap';

  @override
  String get vehicleForErrand => 'Vehicle for the errand';

  @override
  String get transportMediumForDelivery => 'Transport for delivery';

  @override
  String get transportMediumForErrand => 'Transport for the errand';

  @override
  String get rideCachedReconnecting =>
      'Trip cached — reconnecting when signal is available.';

  @override
  String get uploadVehiclePhotosThreeAngles =>
      'Upload front, side and rear photos of the vehicle.';

  @override
  String get noCountryFound => 'No country found';

  @override
  String get backToShop => 'Back to store';

  @override
  String get emergencyContactName => 'Emergency contact name';

  @override
  String get sendOtpViaWhatsapp => 'Send via WhatsApp';

  @override
  String regionConfirmTitle(Object city) {
    return 'Are you in $city?';
  }

  @override
  String regionConfirmCountryMessage(Object country, Object currency) {
    return 'We detected $country. We will update currency ($currency) and minimum fares.';
  }

  @override
  String regionConfirmCityMessage(Object city, Object country) {
    return 'We will update map zones for $city, $country.';
  }

  @override
  String get tecnomecanicaExpiryOptional =>
      'Technical inspection — expiry (optional)';

  @override
  String get photoFront => 'Front photo';

  @override
  String get photoSide => 'Side photo';

  @override
  String get photoRear => 'Rear photo';

  @override
  String get operateAsTaxiOptional => 'I operate as taxi (optional)';

  @override
  String get alsoTransportPassengers =>
      'Do you also want to transport passengers?';

  @override
  String get passengerTransportToggleOn =>
      'You can receive passenger ride requests.';

  @override
  String get passengerTransportToggleOff =>
      'You will only receive delivery requests.';

  @override
  String get googleSignInUnavailable =>
      'Google Sign-In is not available on this device.';

  @override
  String get invalidNationalId => 'Invalid ID (6 to 10 digits)';

  @override
  String get descriptionOrComments => 'Description or comments';

  @override
  String get phoneAtPickup => 'Phone at pickup';

  @override
  String get storeOrPurchasePlaceHint =>
      'Store or purchase location (e.g. Éxito Calle 80)';

  @override
  String get errandDescription => 'Errand description';

  @override
  String get proposedValueRequired => 'Proposed value (required)';

  @override
  String get selectSharedRideDate => 'Select trip date';

  @override
  String get contributionPerPersonCop => 'Contribution per person (COP)';

  @override
  String get scheduledRequest => 'Scheduled request';

  @override
  String get availableSharedRides => 'Available shared rides';

  @override
  String get noSharedRidesAvailable =>
      'There are no shared rides on this route yet. Try another date or publish your own.';

  @override
  String get contributionToAgree => 'Contribution to agree';

  @override
  String get seatsAvailableSuffix => 'seat(s)';

  @override
  String get joinRide => 'Join ride';

  @override
  String get createSharedRide => 'Create shared ride';

  @override
  String get availableSeats => 'Available seats';

  @override
  String get publishRide => 'Publish ride';

  @override
  String get whereToPickupPackage => 'Where to pick up the package';

  @override
  String get whereToDeliverYourAddress => 'Where to deliver (your address)';

  @override
  String get searchSharedRides => 'Search shared rides';

  @override
  String get sendHaulingRequest => 'Send hauling request';

  @override
  String get goOnlineToPublishSharedRides =>
      'Go online to publish shared rides';

  @override
  String get sharedRide => 'Shared ride';

  @override
  String get serviceModeTrips => 'Trips';

  @override
  String get serviceModeDelivery => 'Delivery';

  @override
  String get serviceModeShare => 'Share';

  @override
  String get serviceModeErrand => 'Errand';

  @override
  String get serviceModeHauling => 'Hauling';

  @override
  String get serviceModeShareSubtitle =>
      'Town to town or town to city shared rides';

  @override
  String get serviceModeErrandSubtitle => 'In-store purchases for you';

  @override
  String get serviceModeHaulingSubtitle => 'Moves, hauling and heavy loads';

  @override
  String get sharedRideTownToCity => 'Town to city';

  @override
  String get sharedRideTownToTown => 'Town to town';

  @override
  String get sharedRideOriginTownHint => 'Origin town';

  @override
  String get sharedRideDestinationCityHint => 'Destination city';

  @override
  String get sharedRideDestinationTownHint => 'Destination town';

  @override
  String get sharedRideDestinationRequiredCity => 'Enter the destination city';

  @override
  String get sharedRideDestinationRequiredTown => 'Enter the destination town';

  @override
  String get sharedRideContributionNotice =>
      'The contribution is voluntary and agreed between passengers and driver.';

  @override
  String get sharedRideMatchNotifyWhenAvailable =>
      'We will notify you when rides are available on this route.';

  @override
  String get perPersonSuffix => 'per person';

  @override
  String get estimatedServiceDate => 'Estimated service date';

  @override
  String get errandPickup => 'Pickups';

  @override
  String get errandPurchases => 'Purchases';

  @override
  String get haulTruck => 'Truck';

  @override
  String get haulCage => 'Cage truck';

  @override
  String get haulMotocarguero => 'Cargo motorcycle';

  @override
  String get chipErrand => 'Errand';

  @override
  String get chipShare => 'Share';

  @override
  String get chipHauling => 'Hauling';

  @override
  String get chipDelivery => 'Delivery';

  @override
  String get chipMotoraton => 'Motoratón';

  @override
  String get chipRide => 'Ride';

  @override
  String get deliveryNotPassengerTransport =>
      'Package delivery — not passenger transport';

  @override
  String get genericErrorTryAgain => 'Something went wrong. Please try again.';

  @override
  String get selectContributionAmount => 'Enter the contribution amount';

  @override
  String get selectSeatsAvailable => 'Enter available seats';

  @override
  String get selectPickupLocationErrand => 'Select pickup location';

  @override
  String get selectDropLocationErrand => 'Select delivery location';

  @override
  String get taxiYellowTag => 'Yellow';

  @override
  String get passengerModeBannerUser =>
      'User mode — request rides and deliveries';

  @override
  String get passengerModeBannerDriver =>
      'Driver mode — earn with your vehicle';

  @override
  String get searchCardSubtitleTransport => 'Where do you want to go?';

  @override
  String get searchCardSubtitleDelivery => 'Send a package';

  @override
  String get searchCardSubtitleErrand => 'Request an in-store purchase';

  @override
  String get packageWeightHint => 'Weight (kg)';

  @override
  String get enterPackageWeight => 'Enter weight in kg';

  @override
  String get packageHeightHint => 'Height (cm)';

  @override
  String get packageWidthHint => 'Width (cm)';

  @override
  String get packageLengthHint => 'Length (cm)';

  @override
  String get packageDetailsTitle => 'Package details';

  @override
  String get packageSizeLabel => 'Package size';

  @override
  String get packageLabel => 'Package';

  @override
  String get driverOfflineActionSaved =>
      'No signal: action saved. It will be sent when reconnected.';

  @override
  String get serviceModeTransportCardSubtitle => 'Your route, your way';

  @override
  String get serviceModeDeliveryCardSubtitle => 'Urban deliveries';

  @override
  String repeatActivityTitle(Object serviceLabel) {
    return 'Repeat $serviceLabel';
  }

  @override
  String get paymentBancolombia => 'Bancolombia';

  @override
  String get paymentNequi => 'Nequi';

  @override
  String get paymentDaviplata => 'Daviplata';

  @override
  String get taxiLabel => 'Taxi';

  @override
  String get homeHeroSubtitleTransport => 'Urban ride · Easy and Safe';

  @override
  String get homeHeroSubtitleDelivery => 'Packages and deliveries in Medellín';

  @override
  String get homeHeroSubtitleErrand => 'We buy and deliver for you';

  @override
  String get homeHeroSubtitleExpreso => 'Intercity shared rides';

  @override
  String get modeBannerTransport =>
      'Trips · Negotiate your fare in 500 COP steps';

  @override
  String get modeBannerDelivery =>
      'Urban delivery · Pay at destination available';

  @override
  String get modeBannerErrand => 'Errands · We buy and deliver';

  @override
  String get modeBannerExpreso => 'Share · Intercity routes';

  @override
  String get offlineShowingLastKnownLocation =>
      'No signal — showing last known location.';

  @override
  String get deliveryOnlyServiceHint =>
      'You will receive delivery requests for the medium selected above.';

  @override
  String get passengerTransportToggleHint =>
      'Deliveries arrive based on your registered vehicle. Enable only if you also transport passengers.';

  @override
  String get demoProductSubtitle =>
      'Easy and Safe — urban mobility with fare negotiation and prepaid wallet.';

  @override
  String get demoProductBody =>
      'Request rides, propose your fare, and connect with verified drivers in Medellín.';

  @override
  String get demoProductSupport => 'XISTI Support';

  @override
  String get securityWarningTitle => 'Security notice';

  @override
  String get securityWarningOfficial =>
      'XISTI is officially operated by the xistiapp.com team.';

  @override
  String get securityWarningBody =>
      'If someone tries to sell you a copy of this app or requests payments outside official channels, report it to soporte@xistiapp.com. Download XISTI only from Google Play, App Store, or links published on xistiapp.com.';

  @override
  String get understood => 'Understood';

  @override
  String get sessionExpired => 'Your session expired. Please sign in again.';

  @override
  String get userNotFound => 'User not found';

  @override
  String get emailAlreadyRegistered => 'This email is already registered';

  @override
  String get phoneAlreadyRegistered =>
      'This phone number is already registered';
}
