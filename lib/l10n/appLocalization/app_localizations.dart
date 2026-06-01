import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'appLocalization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'XISTI'**
  String get appName;

  /// XISTI product tagline.
  String get tagline;

  /// No description provided for @splashScreenMsg.
  ///
  /// In en, this message translates to:
  /// **'Your bid, we drive.'**
  String get splashScreenMsg;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get week;

  /// No description provided for @weeks.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get weeks;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @ago.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get ago;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get serverError;

  /// No description provided for @connectionLost.
  ///
  /// In en, this message translates to:
  /// **'Connection Lost'**
  String get connectionLost;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @serverErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'There seems to be a problem\nwith our server. Please try again later.'**
  String get serverErrorMessage;

  /// No description provided for @internetConnLostMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the internet.\nPlease check your internet connection and try again.'**
  String get internetConnLostMessage;

  /// No description provided for @apiErrorCancelMsg.
  ///
  /// In en, this message translates to:
  /// **'The request to the API server was canceled'**
  String get apiErrorCancelMsg;

  /// No description provided for @apiErrorConnectTimeoutMsg.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout with API server'**
  String get apiErrorConnectTimeoutMsg;

  /// No description provided for @apiErrorOtherMsg.
  ///
  /// In en, this message translates to:
  /// **'You are offline please check your internet connection.'**
  String get apiErrorOtherMsg;

  /// No description provided for @apiErrorReceiveTimeoutMsg.
  ///
  /// In en, this message translates to:
  /// **'Receive timeout in connection with the API server'**
  String get apiErrorReceiveTimeoutMsg;

  /// No description provided for @apiErrorResponseMsg.
  ///
  /// In en, this message translates to:
  /// **'Received invalid status code'**
  String get apiErrorResponseMsg;

  /// No description provided for @apiErrorSendTimeoutMsg.
  ///
  /// In en, this message translates to:
  /// **'Send timeout in connection with the API server'**
  String get apiErrorSendTimeoutMsg;

  /// No description provided for @apiErrorUnexpectedErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred'**
  String get apiErrorUnexpectedErrorMsg;

  /// No description provided for @apiErrorCommunicationMsg.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while communicating with the Server with StatusCode'**
  String get apiErrorCommunicationMsg;

  /// No description provided for @newUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'New update is available!'**
  String get newUpdateAvailable;

  /// No description provided for @newUpdateMsg.
  ///
  /// In en, this message translates to:
  /// **'Please update the new app from the store for further access app.'**
  String get newUpdateMsg;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @locationMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Disclosure'**
  String get locationMessageTitle;

  /// No description provided for @locationMessage.
  ///
  /// In en, this message translates to:
  /// **'This app collects location data to enable getting new taxi service rides (jobs), even when the app is closed or not in use.\n\nFeature: Transport Service App\n\nCollects location data of the driver to track real-time location of taxi ride. And when the app is closed this will use background location to get the driver\'s real-time position. So, they can get new ride requests.\n\nSo allow this app to \"Allow all the time\"'**
  String get locationMessage;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @preferenceMsg.
  ///
  /// In en, this message translates to:
  /// **'You can change these settings later in the app.'**
  String get preferenceMsg;

  /// No description provided for @obTitle1.
  ///
  /// In en, this message translates to:
  /// **'Select Your Destination'**
  String get obTitle1;

  /// No description provided for @obMsg1.
  ///
  /// In en, this message translates to:
  /// **'With just a few taps, you can choose , set your drop-off, and be on your way to wherever your destination calls.'**
  String get obMsg1;

  /// No description provided for @obTitle2.
  ///
  /// In en, this message translates to:
  /// **'Make an Offer or Negotiate'**
  String get obTitle2;

  /// No description provided for @obMsg2.
  ///
  /// In en, this message translates to:
  /// **'Make an Offer or Negotiate with available drivers, ensuring you get a fair fare every time.'**
  String get obMsg2;

  /// No description provided for @obTitle3.
  ///
  /// In en, this message translates to:
  /// **'Have a comfortable ride'**
  String get obTitle3;

  /// No description provided for @obMsg3.
  ///
  /// In en, this message translates to:
  /// **'Reach your destination with ease and in comfort, ensuring a pleasant travel experience.'**
  String get obMsg3;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcomeTo;

  /// No description provided for @loginYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Log in to Your Account'**
  String get loginYourAccount;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// No description provided for @enterContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Contact Number'**
  String get enterContactNumber;

  /// No description provided for @sendOTP.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOTP;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or Login With'**
  String get orLoginWith;

  /// No description provided for @loginWithTouchID.
  ///
  /// In en, this message translates to:
  /// **'Login with Touch ID/Face ID'**
  String get loginWithTouchID;

  /// No description provided for @enableTouchID.
  ///
  /// In en, this message translates to:
  /// **'Enable Touch ID/Face ID'**
  String get enableTouchID;

  /// No description provided for @bioMetricsDisableMsg.
  ///
  /// In en, this message translates to:
  /// **'You can activate this option once logged into the application.'**
  String get bioMetricsDisableMsg;

  /// No description provided for @bioMetricsPopupMsg.
  ///
  /// In en, this message translates to:
  /// **'Scan your fingerprint OR face to authenticate.'**
  String get bioMetricsPopupMsg;

  /// No description provided for @authenticationRequired.
  ///
  /// In en, this message translates to:
  /// **'Authentication required!'**
  String get authenticationRequired;

  /// No description provided for @verifyIdentity.
  ///
  /// In en, this message translates to:
  /// **'Verify identity'**
  String get verifyIdentity;

  /// No description provided for @noThanks.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get noThanks;

  /// No description provided for @enterOTPSendNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP sent to your number'**
  String get enterOTPSendNumber;

  /// No description provided for @enterOTPVerifyAccount.
  ///
  /// In en, this message translates to:
  /// **'enter the OTP to verify your account.'**
  String get enterOTPVerifyAccount;

  /// No description provided for @continueTxt.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueTxt;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @startYour.
  ///
  /// In en, this message translates to:
  /// **'Start your'**
  String get startYour;

  /// No description provided for @journeyWithUs.
  ///
  /// In en, this message translates to:
  /// **'journey with us'**
  String get journeyWithUs;

  /// No description provided for @registerAndStart.
  ///
  /// In en, this message translates to:
  /// **'Register and start exploring!'**
  String get registerAndStart;

  /// No description provided for @haveNotCode.
  ///
  /// In en, this message translates to:
  /// **'Haven’t received a code?'**
  String get haveNotCode;

  /// No description provided for @ifNotGetCode.
  ///
  /// In en, this message translates to:
  /// **'If you didn’t get a code, please try one of the options below.'**
  String get ifNotGetCode;

  /// No description provided for @retryIn.
  ///
  /// In en, this message translates to:
  /// **'Retry In'**
  String get retryIn;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Number'**
  String get changeNumber;

  /// No description provided for @sendAgain.
  ///
  /// In en, this message translates to:
  /// **'Send Again'**
  String get sendAgain;

  /// No description provided for @resendOtpSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'Fresh OTP has been sent to your registered phone number'**
  String get resendOtpSuccessMsg;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get email;

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get referralCode;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Name'**
  String get enterYourName;

  /// No description provided for @enterValidFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid full name using letters and spaces only'**
  String get enterValidFullName;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Email Address'**
  String get enterEmailAddress;

  /// No description provided for @invalidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email Address'**
  String get invalidEmailAddress;

  /// No description provided for @byRegisterYouAgree.
  ///
  /// In en, this message translates to:
  /// **'by registering you are agree with our'**
  String get byRegisterYouAgree;

  /// No description provided for @termsCondition.
  ///
  /// In en, this message translates to:
  /// **'Terms & Condition'**
  String get termsCondition;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @driverMode.
  ///
  /// In en, this message translates to:
  /// **'Driver Mode'**
  String get driverMode;

  /// No description provided for @passengerMode.
  ///
  /// In en, this message translates to:
  /// **'Passenger Mode'**
  String get passengerMode;

  /// No description provided for @rideHistory.
  ///
  /// In en, this message translates to:
  /// **'Ride History'**
  String get rideHistory;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @myWallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get myWallet;

  /// No description provided for @referHistory.
  ///
  /// In en, this message translates to:
  /// **'Refer History'**
  String get referHistory;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @myPreference.
  ///
  /// In en, this message translates to:
  /// **'My Preferences'**
  String get myPreference;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @inviteFriend.
  ///
  /// In en, this message translates to:
  /// **'Invite Friend'**
  String get inviteFriend;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @manageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage Account'**
  String get manageAccount;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// No description provided for @pickUpLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickUpLocation;

  /// No description provided for @dropLocation.
  ///
  /// In en, this message translates to:
  /// **'Drop Location'**
  String get dropLocation;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @offerMyFare.
  ///
  /// In en, this message translates to:
  /// **'Offer My Fare'**
  String get offerMyFare;

  /// No description provided for @fetchingLocation.
  ///
  /// In en, this message translates to:
  /// **'Fetching Location'**
  String get fetchingLocation;

  /// No description provided for @stopPoint.
  ///
  /// In en, this message translates to:
  /// **'Stop Point'**
  String get stopPoint;

  /// No description provided for @selectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get selectVehicle;

  /// No description provided for @setRoute.
  ///
  /// In en, this message translates to:
  /// **'Set Route'**
  String get setRoute;

  /// No description provided for @setLocationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Set Location From Map'**
  String get setLocationOnMap;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search Location'**
  String get searchLocation;

  /// No description provided for @selectYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Your Location'**
  String get selectYourLocation;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @writeYourComment.
  ///
  /// In en, this message translates to:
  /// **'Write your comment'**
  String get writeYourComment;

  /// No description provided for @childSeatSafety.
  ///
  /// In en, this message translates to:
  /// **'Child Safety Seat'**
  String get childSeatSafety;

  /// No description provided for @handicapAccess.
  ///
  /// In en, this message translates to:
  /// **'Handicap Accessibility'**
  String get handicapAccess;

  /// No description provided for @bookForOther.
  ///
  /// In en, this message translates to:
  /// **'Book For Other'**
  String get bookForOther;

  /// No description provided for @selectContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Select Contact Number'**
  String get selectContactNumber;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'Km'**
  String get km;

  /// No description provided for @selectPickup.
  ///
  /// In en, this message translates to:
  /// **'Select Pickup Location'**
  String get selectPickup;

  /// No description provided for @selectDrop.
  ///
  /// In en, this message translates to:
  /// **'Select Drop Location'**
  String get selectDrop;

  /// No description provided for @selectStop.
  ///
  /// In en, this message translates to:
  /// **'Select Stop Location'**
  String get selectStop;

  /// No description provided for @offerAmount.
  ///
  /// In en, this message translates to:
  /// **'Offer Amount'**
  String get offerAmount;

  /// No description provided for @enterFareValue.
  ///
  /// In en, this message translates to:
  /// **'Enter Fare Value'**
  String get enterFareValue;

  /// No description provided for @offerFareMin.
  ///
  /// In en, this message translates to:
  /// **'You must pay a minimum of {amount}'**
  String offerFareMin(String amount);

  /// No description provided for @offerFareMax.
  ///
  /// In en, this message translates to:
  /// **'You can Bid a Maximum of {amount}'**
  String offerFareMax(String amount);

  /// No description provided for @scheduleRide.
  ///
  /// In en, this message translates to:
  /// **'Schedule A Ride'**
  String get scheduleRide;

  /// No description provided for @autoAcceptDriverRide.
  ///
  /// In en, this message translates to:
  /// **'Automatically accept the nearest driver for your fare'**
  String get autoAcceptDriverRide;

  /// No description provided for @findDrive.
  ///
  /// In en, this message translates to:
  /// **'Find A Driver'**
  String get findDrive;

  /// No description provided for @recommendedFare.
  ///
  /// In en, this message translates to:
  /// **'Recommended fare'**
  String get recommendedFare;

  /// No description provided for @minFare.
  ///
  /// In en, this message translates to:
  /// **'Min. fare'**
  String get minFare;

  /// No description provided for @maxFare.
  ///
  /// In en, this message translates to:
  /// **'Max. fare'**
  String get maxFare;

  /// No description provided for @recipientName.
  ///
  /// In en, this message translates to:
  /// **'Recipient\'s Name'**
  String get recipientName;

  /// No description provided for @recipientNumber.
  ///
  /// In en, this message translates to:
  /// **'Recipient\'s Number'**
  String get recipientNumber;

  /// No description provided for @parcelEstimatedPrice.
  ///
  /// In en, this message translates to:
  /// **'Parcel Estimated Value'**
  String get parcelEstimatedPrice;

  /// No description provided for @parcelNote.
  ///
  /// In en, this message translates to:
  /// **'Parcel Note'**
  String get parcelNote;

  /// No description provided for @enterRecipientName.
  ///
  /// In en, this message translates to:
  /// **'Enter Recipient\'s Name'**
  String get enterRecipientName;

  /// No description provided for @enterRecipientNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Recipient\'s Number'**
  String get enterRecipientNumber;

  /// No description provided for @enterParcelEstimatedPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter Parcel Estimated Value'**
  String get enterParcelEstimatedPrice;

  /// No description provided for @enterParcelNote.
  ///
  /// In en, this message translates to:
  /// **'Enter Parcel Note'**
  String get enterParcelNote;

  /// No description provided for @systemSelected.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get systemSelected;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @selectAppTheme.
  ///
  /// In en, this message translates to:
  /// **'Select App Theme'**
  String get selectAppTheme;

  /// No description provided for @currentFare.
  ///
  /// In en, this message translates to:
  /// **'Current Fare'**
  String get currentFare;

  /// No description provided for @cancelRide.
  ///
  /// In en, this message translates to:
  /// **'Cancel Ride'**
  String get cancelRide;

  /// No description provided for @raiseFare.
  ///
  /// In en, this message translates to:
  /// **'Raise Fare'**
  String get raiseFare;

  /// No description provided for @myDetails.
  ///
  /// In en, this message translates to:
  /// **'My Details'**
  String get myDetails;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @cropper.
  ///
  /// In en, this message translates to:
  /// **'Cropper'**
  String get cropper;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @kmAway.
  ///
  /// In en, this message translates to:
  /// **'{km} km Away'**
  String kmAway(String km);

  /// No description provided for @noRecordFound.
  ///
  /// In en, this message translates to:
  /// **'Sorry !!\nNo Record Found This Time'**
  String get noRecordFound;

  /// No description provided for @manageDistance.
  ///
  /// In en, this message translates to:
  /// **'Manage Distance'**
  String get manageDistance;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @pleaseSelectADistance.
  ///
  /// In en, this message translates to:
  /// **'Please select a distance.'**
  String get pleaseSelectADistance;

  /// No description provided for @trackLocationInBackground.
  ///
  /// In en, this message translates to:
  /// **'Track location in the background'**
  String get trackLocationInBackground;

  /// No description provided for @changeRideFare.
  ///
  /// In en, this message translates to:
  /// **'{name} changed the ride fare.'**
  String changeRideFare(String name);

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @permissionText1.
  ///
  /// In en, this message translates to:
  /// **'Allow {appName} to display over Other apps'**
  String permissionText1(String appName);

  /// No description provided for @permissionText2.
  ///
  /// In en, this message translates to:
  /// **'Allow {appName} to display over Other apps in order to receive ride request when you’re online.'**
  String permissionText2(String appName);

  /// No description provided for @permissionText3.
  ///
  /// In en, this message translates to:
  /// **'Tap Allow and set the toggle ON in the Settings screen.'**
  String get permissionText3;

  /// No description provided for @permissionText4.
  ///
  /// In en, this message translates to:
  /// **'Set the Quick Access icon to on to see this icon over other apps'**
  String get permissionText4;

  /// No description provided for @quickAccessIcon.
  ///
  /// In en, this message translates to:
  /// **'Quick Access icon'**
  String get quickAccessIcon;

  /// No description provided for @settingsPermission.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get settingsPermission;

  /// No description provided for @yourDriverIsOnWay.
  ///
  /// In en, this message translates to:
  /// **'Your driver is on their way'**
  String get yourDriverIsOnWay;

  /// No description provided for @driverIsAtPickup.
  ///
  /// In en, this message translates to:
  /// **'Driver is at your pickup point'**
  String get driverIsAtPickup;

  /// No description provided for @driverHeadingDestination.
  ///
  /// In en, this message translates to:
  /// **'Driver heading to destination'**
  String get driverHeadingDestination;

  /// No description provided for @reachYourDestination.
  ///
  /// In en, this message translates to:
  /// **'Reached your destination'**
  String get reachYourDestination;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @shareOTP.
  ///
  /// In en, this message translates to:
  /// **'Share OTP'**
  String get shareOTP;

  /// No description provided for @proceedToPay.
  ///
  /// In en, this message translates to:
  /// **'Proceed to pay'**
  String get proceedToPay;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @insufficientWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'You can\'t pay the ride amount through Wallet because your wallet balance is insufficient.'**
  String get insufficientWalletBalance;

  /// No description provided for @onlinePayment.
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get onlinePayment;

  /// No description provided for @shareFeedBack.
  ///
  /// In en, this message translates to:
  /// **'Share Feedback'**
  String get shareFeedBack;

  /// No description provided for @writeYourFeedBack.
  ///
  /// In en, this message translates to:
  /// **'Write your feedback'**
  String get writeYourFeedBack;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @giveFeedbackErrorMsg.
  ///
  /// In en, this message translates to:
  /// **'Give your feedback!'**
  String get giveFeedbackErrorMsg;

  /// No description provided for @rideDetail.
  ///
  /// In en, this message translates to:
  /// **'Ride Details'**
  String get rideDetail;

  /// No description provided for @downloadInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download Invoice'**
  String get downloadInvoice;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get cancelled;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// No description provided for @rideDateTime.
  ///
  /// In en, this message translates to:
  /// **'Ride Date & Time'**
  String get rideDateTime;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @bookingId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingId;

  /// No description provided for @invoiceDetail.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get invoiceDetail;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @vehicleInformation.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInformation;

  /// No description provided for @driverDetails.
  ///
  /// In en, this message translates to:
  /// **'Driver Details'**
  String get driverDetails;

  /// No description provided for @profileUpdateSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile Update successfully.'**
  String get profileUpdateSuccessfully;

  /// No description provided for @txtToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get txtToday;

  /// No description provided for @txtUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get txtUpcoming;

  /// No description provided for @txtLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get txtLast7Days;

  /// No description provided for @txtThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get txtThisMonth;

  /// No description provided for @txtYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get txtYear;

  /// No description provided for @txtAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get txtAll;

  /// No description provided for @sortByDays.
  ///
  /// In en, this message translates to:
  /// **'Sort By Days'**
  String get sortByDays;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @itemDesc.
  ///
  /// In en, this message translates to:
  /// **'Item Description'**
  String get itemDesc;

  /// No description provided for @courierDetail.
  ///
  /// In en, this message translates to:
  /// **'Courier Details'**
  String get courierDetail;

  /// No description provided for @courierDateTime.
  ///
  /// In en, this message translates to:
  /// **'Courier Date & Time'**
  String get courierDateTime;

  /// No description provided for @rideCompleteByAdminMsg.
  ///
  /// In en, this message translates to:
  /// **'Ride Completed by Admin'**
  String get rideCompleteByAdminMsg;

  /// No description provided for @rideCancelByAdminMsg.
  ///
  /// In en, this message translates to:
  /// **'Ride Cancelled by Admin'**
  String get rideCancelByAdminMsg;

  /// No description provided for @startRide.
  ///
  /// In en, this message translates to:
  /// **'Start Ride'**
  String get startRide;

  /// No description provided for @collectAmount.
  ///
  /// In en, this message translates to:
  /// **'Collect Amount'**
  String get collectAmount;

  /// No description provided for @collectAmountMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you have collected {collectionAmount} from the customer?'**
  String collectAmountMsg(String collectionAmount);

  /// No description provided for @rideOTPVerifyMsg.
  ///
  /// In en, this message translates to:
  /// **'Please get the OTP from the Customer and enter it here.'**
  String get rideOTPVerifyMsg;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @collectPayment.
  ///
  /// In en, this message translates to:
  /// **'Collect Payment'**
  String get collectPayment;

  /// No description provided for @rateUser.
  ///
  /// In en, this message translates to:
  /// **'Rate User'**
  String get rateUser;

  /// No description provided for @completeRide.
  ///
  /// In en, this message translates to:
  /// **'Complete the ride'**
  String get completeRide;

  /// No description provided for @errorMessageCommon.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, Giving it another shot after some time?'**
  String get errorMessageCommon;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @offerFare.
  ///
  /// In en, this message translates to:
  /// **'Offer Fare'**
  String get offerFare;

  /// No description provided for @requiredMess.
  ///
  /// In en, this message translates to:
  /// **'Please enter the below details.'**
  String get requiredMess;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @accountDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get accountDelete;

  /// No description provided for @accountDeleteDialogMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? Any wallet balance will not be refunded.'**
  String get accountDeleteDialogMsg;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logOutDialogMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout from your account?'**
  String get logOutDialogMsg;

  /// No description provided for @arrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get arrived;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter Otp'**
  String get enterOtp;

  /// No description provided for @numberOfToll.
  ///
  /// In en, this message translates to:
  /// **'Number Of Tolls'**
  String get numberOfToll;

  /// No description provided for @tollAmount.
  ///
  /// In en, this message translates to:
  /// **'Toll Amount'**
  String get tollAmount;

  /// No description provided for @enterTollAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter toll amount'**
  String get enterTollAmount;

  /// No description provided for @enterNumberOfToll.
  ///
  /// In en, this message translates to:
  /// **'Enter number of tolls'**
  String get enterNumberOfToll;

  /// No description provided for @reviewUser.
  ///
  /// In en, this message translates to:
  /// **'Review User'**
  String get reviewUser;

  /// No description provided for @reviewUserMsg.
  ///
  /// In en, this message translates to:
  /// **'Rate User from 1 to 5 Star'**
  String get reviewUserMsg;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get showLess;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @claimed.
  ///
  /// In en, this message translates to:
  /// **'Claimed'**
  String get claimed;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @manageAddress.
  ///
  /// In en, this message translates to:
  /// **'Manage Address'**
  String get manageAddress;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @addressDeletedSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted address'**
  String get addressDeletedSuccessMsg;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @enterContactName.
  ///
  /// In en, this message translates to:
  /// **'Enter Contact Name'**
  String get enterContactName;

  /// No description provided for @sureToCancel.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, you want to cancel your ride?'**
  String get sureToCancel;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @rideCancel.
  ///
  /// In en, this message translates to:
  /// **'Ride Cancel'**
  String get rideCancel;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @at.
  ///
  /// In en, this message translates to:
  /// **'At'**
  String get at;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @topUp.
  ///
  /// In en, this message translates to:
  /// **'TopUp'**
  String get topUp;

  /// No description provided for @cashOut.
  ///
  /// In en, this message translates to:
  /// **'Cash Out'**
  String get cashOut;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @debit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get debit;

  /// No description provided for @transactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Transaction not found'**
  String get transactionNotFound;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @successTransaction.
  ///
  /// In en, this message translates to:
  /// **'You have successfully transferred'**
  String get successTransaction;

  /// No description provided for @selectUser.
  ///
  /// In en, this message translates to:
  /// **'Select User'**
  String get selectUser;

  /// No description provided for @searchByContactOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Search by Contact or Email'**
  String get searchByContactOrEmail;

  /// No description provided for @beneficial.
  ///
  /// In en, this message translates to:
  /// **'Beneficial'**
  String get beneficial;

  /// No description provided for @beneficialContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Beneficial Contact Number'**
  String get beneficialContactNumber;

  /// No description provided for @beneficialEmail.
  ///
  /// In en, this message translates to:
  /// **'Beneficial Email'**
  String get beneficialEmail;

  /// No description provided for @amountToTransfer.
  ///
  /// In en, this message translates to:
  /// **'Amount to transfer'**
  String get amountToTransfer;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// No description provided for @youCantTransfer.
  ///
  /// In en, this message translates to:
  /// **'You can\'t transfer more than'**
  String get youCantTransfer;

  /// No description provided for @invalidAmountMsg.
  ///
  /// In en, this message translates to:
  /// **'Enter valid amount'**
  String get invalidAmountMsg;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// No description provided for @enterContactOrEmailToSearchPerson.
  ///
  /// In en, this message translates to:
  /// **'Please enter the contact number or email to search for the person.'**
  String get enterContactOrEmailToSearchPerson;

  /// No description provided for @proceedToAddMoney.
  ///
  /// In en, this message translates to:
  /// **'Proceed to add money'**
  String get proceedToAddMoney;

  /// No description provided for @chooseAmount.
  ///
  /// In en, this message translates to:
  /// **'Choose Amount'**
  String get chooseAmount;

  /// No description provided for @walletMinTopupNotice.
  ///
  /// In en, this message translates to:
  /// **'Minimum top-up is always COP 13,000.'**
  String get walletMinTopupNotice;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter or select the amount.'**
  String get pleaseEnterAmount;

  /// No description provided for @walletAddSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Wallet amount was added successfully'**
  String get walletAddSuccessful;

  /// No description provided for @invalidRequestCashOutAmountMsg.
  ///
  /// In en, this message translates to:
  /// **'You don\'t make cash out request more than your wallet balance'**
  String get invalidRequestCashOutAmountMsg;

  /// No description provided for @pleaseEnterRequestCashOutAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter request cash out amount'**
  String get pleaseEnterRequestCashOutAmount;

  /// No description provided for @enterValidRequestCashOutAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter valid request cash out amount'**
  String get enterValidRequestCashOutAmount;

  /// No description provided for @cashOutSuccess.
  ///
  /// In en, this message translates to:
  /// **'CashOut Request Successfully!'**
  String get cashOutSuccess;

  /// No description provided for @requestToCash.
  ///
  /// In en, this message translates to:
  /// **'Request to cash out'**
  String get requestToCash;

  /// No description provided for @cashOutAmount.
  ///
  /// In en, this message translates to:
  /// **'Cash out amount'**
  String get cashOutAmount;

  /// No description provided for @newRequest.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get newRequest;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @searchingForRideRequests.
  ///
  /// In en, this message translates to:
  /// **'Searching for ride requests\n'**
  String get searchingForRideRequests;

  /// No description provided for @yourOfferIsBeingReviewedByCustomer.
  ///
  /// In en, this message translates to:
  /// **'Your Offer is Being\nReviewed by Customer'**
  String get yourOfferIsBeingReviewedByCustomer;

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'Distance: {km} km '**
  String distanceKm(String km);

  /// No description provided for @reqRejectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Your Request was Rejected by the Customer.'**
  String get reqRejectCustomer;

  /// No description provided for @enterCancelReason.
  ///
  /// In en, this message translates to:
  /// **'Enter Cancel Reason'**
  String get enterCancelReason;

  /// No description provided for @away.
  ///
  /// In en, this message translates to:
  /// **'away'**
  String get away;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @rideCompleted.
  ///
  /// In en, this message translates to:
  /// **'Ride Completed'**
  String get rideCompleted;

  /// No description provided for @rideCompletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Your Ride was Completed successfully.'**
  String get rideCompletedMsg;

  /// No description provided for @rideCancelBy.
  ///
  /// In en, this message translates to:
  /// **'Ride Cancelled by {name}!'**
  String rideCancelBy(String name);

  /// No description provided for @rateDriver.
  ///
  /// In en, this message translates to:
  /// **'Rate Driver'**
  String get rateDriver;

  /// No description provided for @rideFare.
  ///
  /// In en, this message translates to:
  /// **'Ride Fare'**
  String get rideFare;

  /// No description provided for @totalPay.
  ///
  /// In en, this message translates to:
  /// **'Total Pay'**
  String get totalPay;

  /// No description provided for @referDiscount.
  ///
  /// In en, this message translates to:
  /// **'Refer Discount'**
  String get referDiscount;

  /// No description provided for @inviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriends;

  /// No description provided for @shareInvite.
  ///
  /// In en, this message translates to:
  /// **'Share Invite'**
  String get shareInvite;

  /// No description provided for @referFriendAndGetBenefits.
  ///
  /// In en, this message translates to:
  /// **'Refer Friend & Get Benefits'**
  String get referFriendAndGetBenefits;

  /// No description provided for @inviteFriendsMsg.
  ///
  /// In en, this message translates to:
  /// **'Invite Your Friend With This \nReferral Code To Get More Benfits'**
  String get inviteFriendsMsg;

  /// No description provided for @use.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get use;

  /// No description provided for @referCodeGetDiscount.
  ///
  /// In en, this message translates to:
  /// **'Referral Code and get a Discount'**
  String get referCodeGetDiscount;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @emergencyContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact Number'**
  String get emergencyContactNumber;

  /// No description provided for @emergencyContactAddMsg.
  ///
  /// In en, this message translates to:
  /// **'You Can Add Emergency Contact \nNumber From Your Profile.'**
  String get emergencyContactAddMsg;

  /// No description provided for @emergencyContactMsg.
  ///
  /// In en, this message translates to:
  /// **'You Can Change Emergency Contact \nNumber From Your Profile.'**
  String get emergencyContactMsg;

  /// No description provided for @emergencyCall.
  ///
  /// In en, this message translates to:
  /// **'Emergency Call'**
  String get emergencyCall;

  /// No description provided for @addEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Add Emergency Contact'**
  String get addEmergencyContact;

  /// No description provided for @manageVehicle.
  ///
  /// In en, this message translates to:
  /// **'Manage Vehicle'**
  String get manageVehicle;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @editAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddress;

  /// No description provided for @maxAddressMsg.
  ///
  /// In en, this message translates to:
  /// **'You can add max {maxLimit} addresses. Delete the previous one before adding a new one'**
  String maxAddressMsg(int maxLimit);

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Delete Address?'**
  String get deleteAddress;

  /// No description provided for @deleteAddressDialogMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get deleteAddressDialogMsg;

  /// No description provided for @noAnyAddressMsg.
  ///
  /// In en, this message translates to:
  /// **'You have not added address. Please add address to use at ride book.'**
  String get noAnyAddressMsg;

  /// No description provided for @heatMap.
  ///
  /// In en, this message translates to:
  /// **'HeatMap'**
  String get heatMap;

  /// No description provided for @writeAMessageHere.
  ///
  /// In en, this message translates to:
  /// **'Write a message here'**
  String get writeAMessageHere;

  /// No description provided for @enterValidateNoTolls.
  ///
  /// In en, this message translates to:
  /// **'Enter the valid number of tolls'**
  String get enterValidateNoTolls;

  /// No description provided for @enterValidateTollCharge.
  ///
  /// In en, this message translates to:
  /// **'Enter the valid toll charge amount'**
  String get enterValidateTollCharge;

  /// No description provided for @whatWouldYouLikeToChoose.
  ///
  /// In en, this message translates to:
  /// **'What Would You Like to Choose?'**
  String get whatWouldYouLikeToChoose;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @downloadingComplete.
  ///
  /// In en, this message translates to:
  /// **'Downloading Complete'**
  String get downloadingComplete;

  /// No description provided for @downloadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Downloading Failed'**
  String get downloadingFailed;

  /// No description provided for @pdfDownloadSuccessful.
  ///
  /// In en, this message translates to:
  /// **'PDF Download Successful!'**
  String get pdfDownloadSuccessful;

  /// No description provided for @downloadCancelled.
  ///
  /// In en, this message translates to:
  /// **'Download Failed!'**
  String get downloadCancelled;

  /// No description provided for @fillYourInformation.
  ///
  /// In en, this message translates to:
  /// **'Fill Your Information'**
  String get fillYourInformation;

  /// No description provided for @driverRegisterMsg.
  ///
  /// In en, this message translates to:
  /// **'Please fill in your personal information to start your earning with {appName}'**
  String driverRegisterMsg(String appName);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @manageInformation.
  ///
  /// In en, this message translates to:
  /// **'Manage Information'**
  String get manageInformation;

  /// No description provided for @drivingLicence.
  ///
  /// In en, this message translates to:
  /// **'Driving Licence'**
  String get drivingLicence;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get addDocument;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @selectExpiryDateHere.
  ///
  /// In en, this message translates to:
  /// **'Select expiry date here...'**
  String get selectExpiryDateHere;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @updateDocument.
  ///
  /// In en, this message translates to:
  /// **'Update Document'**
  String get updateDocument;

  /// No description provided for @selectDocument.
  ///
  /// In en, this message translates to:
  /// **'Please select document'**
  String get selectDocument;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @selectExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Select Expiry Date'**
  String get selectExpiryDate;

  /// No description provided for @emptyDocument.
  ///
  /// In en, this message translates to:
  /// **'The document is not required for this service'**
  String get emptyDocument;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @noDocument.
  ///
  /// In en, this message translates to:
  /// **'No Document'**
  String get noDocument;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @customerDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetails;

  /// No description provided for @rideEstimation.
  ///
  /// In en, this message translates to:
  /// **'Ride Estimation'**
  String get rideEstimation;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @customerNumber.
  ///
  /// In en, this message translates to:
  /// **'Customer Number'**
  String get customerNumber;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @addCustomerDetails.
  ///
  /// In en, this message translates to:
  /// **'Add Customer Details'**
  String get addCustomerDetails;

  /// No description provided for @bankDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get bankDetails;

  /// No description provided for @updateBankDetailSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'Your bank details updated successfully!'**
  String get updateBankDetailSuccessMsg;

  /// No description provided for @enterAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Account Number'**
  String get enterAccountNumber;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @enterAccountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Enter Account Holder Name'**
  String get enterAccountHolderName;

  /// No description provided for @accountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get accountHolderName;

  /// No description provided for @enterBankName.
  ///
  /// In en, this message translates to:
  /// **'Enter Bank Name'**
  String get enterBankName;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @enterBankLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter Bank Location'**
  String get enterBankLocation;

  /// No description provided for @bankLocation.
  ///
  /// In en, this message translates to:
  /// **'Bank Location'**
  String get bankLocation;

  /// No description provided for @enterSwiftCode.
  ///
  /// In en, this message translates to:
  /// **'Enter BIC/SWIFT Code'**
  String get enterSwiftCode;

  /// No description provided for @swiftCode.
  ///
  /// In en, this message translates to:
  /// **'BIC/SWIFT Code'**
  String get swiftCode;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @viewRide.
  ///
  /// In en, this message translates to:
  /// **'View Ride'**
  String get viewRide;

  /// No description provided for @addIssue.
  ///
  /// In en, this message translates to:
  /// **'Add Issue'**
  String get addIssue;

  /// No description provided for @myReportedIssue.
  ///
  /// In en, this message translates to:
  /// **'My reported Issue'**
  String get myReportedIssue;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @chooseAnOrderWithIssue.
  ///
  /// In en, this message translates to:
  /// **'Choose an order with issue'**
  String get chooseAnOrderWithIssue;

  /// No description provided for @reportGeneralIssue.
  ///
  /// In en, this message translates to:
  /// **'Report General Issue'**
  String get reportGeneralIssue;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @unResolved.
  ///
  /// In en, this message translates to:
  /// **'Unresolved'**
  String get unResolved;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @issueNotFound.
  ///
  /// In en, this message translates to:
  /// **'Issue Not found'**
  String get issueNotFound;

  /// No description provided for @ticketId.
  ///
  /// In en, this message translates to:
  /// **'Ticket ID'**
  String get ticketId;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter Description'**
  String get enterDescription;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImage;

  /// No description provided for @deleteImageMsg.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure Want to Delete This Image?'**
  String get deleteImageMsg;

  /// No description provided for @rideId.
  ///
  /// In en, this message translates to:
  /// **'Ride Id'**
  String get rideId;

  /// No description provided for @orderNotFound.
  ///
  /// In en, this message translates to:
  /// **'Order Not found'**
  String get orderNotFound;

  /// No description provided for @uploadMinImagesMsg.
  ///
  /// In en, this message translates to:
  /// **'Please Upload at least {minIssueImageCount} images.'**
  String uploadMinImagesMsg(int minIssueImageCount);

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @submitIssue.
  ///
  /// In en, this message translates to:
  /// **'Submit Issue'**
  String get submitIssue;

  /// No description provided for @manufactureName.
  ///
  /// In en, this message translates to:
  /// **'Manufacture Name'**
  String get manufactureName;

  /// No description provided for @modelName.
  ///
  /// In en, this message translates to:
  /// **'Model Name'**
  String get modelName;

  /// No description provided for @vehiclePlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Plate Number'**
  String get vehiclePlateNumber;

  /// No description provided for @vehicleColor.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Color'**
  String get vehicleColor;

  /// No description provided for @vehicleYear.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Year'**
  String get vehicleYear;

  /// No description provided for @selectVehicleType.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle Type'**
  String get selectVehicleType;

  /// No description provided for @selectVehicleYear.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle Year'**
  String get selectVehicleYear;

  /// No description provided for @selectItem.
  ///
  /// In en, this message translates to:
  /// **'Select Item'**
  String get selectItem;

  /// No description provided for @enterManufactureName.
  ///
  /// In en, this message translates to:
  /// **'Enter Manufacture Name'**
  String get enterManufactureName;

  /// No description provided for @enterModelName.
  ///
  /// In en, this message translates to:
  /// **'Enter Model Name'**
  String get enterModelName;

  /// No description provided for @enterVehiclePlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Vehicle Plate Number'**
  String get enterVehiclePlateNumber;

  /// No description provided for @enterVehicleColor.
  ///
  /// In en, this message translates to:
  /// **'Enter Vehicle Color'**
  String get enterVehicleColor;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @uploadVehicleImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Vehicle Image'**
  String get uploadVehicleImage;

  /// No description provided for @imageUploaded.
  ///
  /// In en, this message translates to:
  /// **'Image Uploaded'**
  String get imageUploaded;

  /// No description provided for @vehicleDetailsUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details Uploaded Successfully.'**
  String get vehicleDetailsUploadedSuccessfully;

  /// No description provided for @cancellationReason.
  ///
  /// In en, this message translates to:
  /// **'Cancellation reason'**
  String get cancellationReason;

  /// No description provided for @trackRide.
  ///
  /// In en, this message translates to:
  /// **'Track ride'**
  String get trackRide;

  /// No description provided for @verificationPending.
  ///
  /// In en, this message translates to:
  /// **'Verification Pending'**
  String get verificationPending;

  /// No description provided for @driverBlock.
  ///
  /// In en, this message translates to:
  /// **'Driver Blocked By Admin'**
  String get driverBlock;

  /// No description provided for @pendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your application and we will notify you by email once we review your uploaded documents.'**
  String get pendingMessage;

  /// No description provided for @driverRejectedByAdmin.
  ///
  /// In en, this message translates to:
  /// **'Driver rejected by the admin'**
  String get driverRejectedByAdmin;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go To Home'**
  String get goToHome;

  /// No description provided for @hailModule.
  ///
  /// In en, this message translates to:
  /// **'Please go online to hail the ride'**
  String get hailModule;

  /// No description provided for @noteFromCustomer.
  ///
  /// In en, this message translates to:
  /// **'Note From Customer'**
  String get noteFromCustomer;

  /// No description provided for @yourAdditionalNote.
  ///
  /// In en, this message translates to:
  /// **'Your additional note'**
  String get yourAdditionalNote;

  /// No description provided for @passengerName.
  ///
  /// In en, this message translates to:
  /// **'Passenger Name'**
  String get passengerName;

  /// No description provided for @submitOTP.
  ///
  /// In en, this message translates to:
  /// **'Submit OTP'**
  String get submitOTP;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @cancelBy.
  ///
  /// In en, this message translates to:
  /// **'Cancel By'**
  String get cancelBy;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @expiryDateValidation.
  ///
  /// In en, this message translates to:
  /// **'Looks like your expiry date is in the past. Please check it.'**
  String get expiryDateValidation;

  /// No description provided for @selectScheduleDate.
  ///
  /// In en, this message translates to:
  /// **'Select Schedule Date'**
  String get selectScheduleDate;

  /// No description provided for @googleMapsLimitMessage.
  ///
  /// In en, this message translates to:
  /// **'You’ve reached your daily Google Maps usage limit. Please try again tomorrow.'**
  String get googleMapsLimitMessage;

  /// No description provided for @usageLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Usage Limit Reached'**
  String get usageLimitReached;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @faceVerification.
  ///
  /// In en, this message translates to:
  /// **'Face Verification'**
  String get faceVerification;

  /// No description provided for @positionFaceInCircle.
  ///
  /// In en, this message translates to:
  /// **'Position your face in the circle'**
  String get positionFaceInCircle;

  /// No description provided for @blinkEyesNow.
  ///
  /// In en, this message translates to:
  /// **'Now blink your eyes'**
  String get blinkEyesNow;

  /// No description provided for @verificationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Verification Successful!'**
  String get verificationSuccessful;

  /// No description provided for @onlyOneFaceAllowed.
  ///
  /// In en, this message translates to:
  /// **'Only one face allowed'**
  String get onlyOneFaceAllowed;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera Permission Required'**
  String get cameraPermissionRequired;

  /// No description provided for @cameraPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'This app needs camera access to verify your identity. Please enable it in settings.'**
  String get cameraPermissionMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @noCamerasFound.
  ///
  /// In en, this message translates to:
  /// **'No cameras found.'**
  String get noCamerasFound;

  /// No description provided for @failedToCaptureImagePleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to capture image. Please try again.'**
  String get failedToCaptureImagePleaseTryAgain;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @pleaseAddProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Please add your profile photo to continue.'**
  String get pleaseAddProfileImage;

  /// No description provided for @profilePictureUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload profile picture'**
  String get profilePictureUpload;

  /// No description provided for @profilePictureUploadMsg.
  ///
  /// In en, this message translates to:
  /// **'Profile picture is missing, upload profile picture to proceed orders.'**
  String get profilePictureUploadMsg;

  /// No description provided for @platformCommission.
  ///
  /// In en, this message translates to:
  /// **'Platform commission (8%)'**
  String get platformCommission;

  /// No description provided for @vatOnCommission.
  ///
  /// In en, this message translates to:
  /// **'VAT on commission (19%)'**
  String get vatOnCommission;

  /// No description provided for @totalDeduction.
  ///
  /// In en, this message translates to:
  /// **'Total deductions'**
  String get totalDeduction;

  /// No description provided for @netDriverEarnings.
  ///
  /// In en, this message translates to:
  /// **'Net driver earnings'**
  String get netDriverEarnings;

  /// No description provided for @invalidMobileNumberCo.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number'**
  String get invalidMobileNumberCo;

  /// No description provided for @invalidVehiclePlate.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid plate (5 to 8 alphanumeric characters)'**
  String get invalidVehiclePlate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'it', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
