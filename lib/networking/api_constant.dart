import '../utils/utils.dart';

class BaseUrl {
  /// Override at build: `--dart-define=API_DOMAIN=https://admin.xistiapp.com`
  /// Default uses EC2 until `admin.xistiapp.com` DNS is live.
  static const domain = String.fromEnvironment(
    'API_DOMAIN',
    defaultValue: 'http://54.159.169.235',
  );

  static const endPointBaseUrlApi = "/api/";
  static const endPointBaseUrlCustomer = "customer/";
  static const baseUrlCustomer = domain + endPointBaseUrlApi + endPointBaseUrlCustomer;

  //Map
  static const mapBaseUrl = "https://maps.googleapis.com/";

  //Firebase
  static String firebaseBaseUrl = "https://fcm.googleapis.com/v1/projects/$firebaseProjectId/messages:";
}

class ApiConst {
  //Google API
  static const endPointGoogleMap = "google-map";
  static const endPointPlaceAutoComplete = "google-autocomplete-places";
  static const endPointPlaceDetail = "google-place-detail";
  static const endPointRouteDetail = "google-route-detail";

  //Splash
  static const endPointGetDriverRunningService = "get-driver-running-service";
  static const endPointGetCustomerRunningService = "get-customer-running-service";
  static const endPointAppVersionCheck = "app-version-check";

  //Terms And Condition
  static const endPointTermsAndConditions = '/terms-and-conditions';

  //Select Language And Currency
  static const endPointCountryCurrency = 'country-and-currency-list';
  static const endPointUpdateCountryCurrency = 'update-country-and-currency';

  //SigUp
  static const endPointRegister = 'register';

  //Login
  static const endPointLogin = "login";
  static const endPointFingerLogin = "finger-login";

  //Update Device Token
  static const endPointUpdateDeviceToken = 'update-device-token';

  //OTP
  static const endPointVerifyOtp = "contact-verification";
  static const endPointResendOtp = "resend-otp-verification";
  static const endPointChangeNumber = "change-contact-number";

  //Home
  static const endPointHome = "home";
  static const endPointTransportGetNearestDriver = "get-driver-list";
  static const endPointRideCalculation = "ride-pricing";

  //My Profile
  static const endPointHeatMap = "heat-map";

  //account
  static const endPointLogout = "logout";
  static const endPointChangeMode = "active-mode";
  static const endPointDriverStatus = "driver-status";

  //background service
  static const endPointUpdateCurrentLatLong = "update-current-lat-long";

  //Notifications
  static const endPointMassNotificationList = "mass-notification-list";

  //Support
  static const endPointSupportPages = "support-pages";

  //My Profile
  static const endPointEditProfile = "edit-profile";
  static const endPointRemoveAccount = "remove-account";
  static const endPointGetDetail = "customer-details";

  //Required Document
  static const endPointManageDocumentList = "required-document-list";
  static const endPointUploadSingleDocument = "upload-document";

  //Bank Detail
  static const endPointGetBankDetails = "get-bank-details";
  static const endPointUpdateBankDetails = "update-bank-details";

  //update currentStatus
  static const endPointUpdateCurrentStatus = "update-current-status";

  //available ride
  static const endPointAvailableRide = "available-ride-request";
  static const endPointUpdateDriverAvailabilityModes = "update-driver-availability-modes";
  static const endPointBidRide = "driver-bid";

  //driver Waiting
  static const endPointWaiting = "get-ride-status";

  //New Ride
  static const endPointGetRide = "get-ride";
  static const endPointDriverAcceptRide = "driver-accept-ride";

  //Chat
  static const endPointChatPhotos = "chat-photos";

  //vehicle
  static const endPointVehicleList = "vehicle-service-list";
  static const endPointGetVehicleDetails = "get-vehicle-details";
  static const endPointServiceRegister = "service-register";

  //passenger running ride
  static const endPointRideReceiptDetail = "ride-receipt-details";
  static const endPointRidePayment = "ride-payment";
  static const endPointRideUserRating = "ride-user-rating";

  //driver running:
  static const endPointRideDetail = "ride-details";
  static const endPointUpdateRideStatus = "update-ride-status";
  static const endPointStartRequest = "start-request";

  //driver eaning
  static const endPointDriverEarning = "driver-earning";

  //order History
  static const endPointPassengerRideHistory = "user-ride-history";
  static const endPointDriverRideHistory = "driver-ride-history";

  //My Wallet
  static const endPointGetWalletBalance = "get-wallet-balance";
  static const endPointRequestCashOut = "request-cash-out";
  static const endPointWalletBalance = "add-wallet-balance";

  //Wallet Transfer
  static const String endPointSearchUser = "search-wallet-transfer-user-list";
  static const String endPointWalletTransfer = "wallet-transfer";

  //Wallet Transaction
  static const endPointWalletTransactions = "wallet-transaction";
  static const endPointGetServiceCategories = "get-service-category";

  // //Customer Feedback
  static const endPointRideFeedback = "ride-feedback";

  //hailRide
  static const endPointHailRideBooking = "hail-ride-booking";

  //Ride Book
  static const endPointTransportRideBooking = "ride-booking";
  static const endPointFindDriver = "driver-bid-list";
  static const endPointUpdatePrice = "update-price";
  static const endPointAcceptRide = "accept-ride";
  static const endPointDeclineRequest = "decline-request";

  //Running Ride
  static const endPointCancelRide = "cancel-ride";
  static const endPointLogSosTrigger = "log-sos-trigger";

  //Manage Card
  static const String endPointCardList = "card-list";
  static const String endPointAddCard = "add-card";
  static const String endPointCardRemove = "delete-card";

  //Refer History
  static const endPointRefer = "get-refer-info";

  //Driver Home
  static const endPointDriverHome = "driver-home";

  //Manage Address
  static const endPointAddressList = "address-list";
  static const endPointDeleteAddress = "delete-address";
  static const endPointAddAddress = "add-address";
  static const endPointEditAddress = "edit-address";

  //Report Issue
  static const endPointReportIssue = "report-issue/";

  static const endPointReportIssueFaqs = "${endPointReportIssue}faqs";
  static const endPointReportIssueUpdate = "${endPointReportIssue}update";
  static const endPointReportIssueDetails = "${endPointReportIssue}details";
  static const endPointReportIssueDraft = "${endPointReportIssue}draft";
  static const endPointReportIssueUploadImage = "${endPointReportIssue}upload-image";
  static const endPointReportIssueRemoveImage = "${endPointReportIssue}remove-image";
  static const endPointReportIssueTransportHistory = "${endPointReportIssue}history";
}

class ApiParam {
  //Common
  static const paramUserId = 'user_id';
  static const paramDriverId = 'driver_id';
  static const paramAccessToken = 'access_token';
  static const paramAppVersion = 'app_version';
  static const headerAuth = 'Authorization';

  //Google API
  static const paramUrl = 'url';
  static const paramInput = 'input';
  static const paramLatitude = 'latitude';
  static const paramLongitude = 'longitude';
  static const paramPlaceID = 'place_id';
  static const paramPickupLatitude = 'pickup_latitude';
  static const paramPickupLongitude = 'pickup_longitude';
  static const paramDropLatitude = 'drop_latitude';
  static const paramDropLongitude = 'drop_longitude';
  static const paramWaypoint = 'waypoint';

  //appMode
  static const paramActiveMode = 'active_mode';

  //Select Language And Currency
  static const paramSelectLanguage = 'select_language';
  static const paramSelectLanguageHeader = 'select-language';
  static const paramSelectCountryCode = 'select_country_code';
  static const paramSelectCurrency = 'select_currency';

  //SignUp
  static const paramFullName = 'full_name';
  static const paramEmail = 'email';
  static const paramGender = 'gender';
  static const paramPassword = 'password';
  static const paramContactNumber = 'contact_number';
  static const paramReferCode = 'refer_code';
  static const paramDeviceToken = 'device_token';
  static const paramLoginDevice = 'login_device';
  static const paramAppType = 'app_type';

  //Login
  static const paramLoginType = 'login_type';
  static const paramLoginId = 'login_id';
  static const paramProfileImage = 'profile_image';
  static const paramOtp = 'otp';
  static const paramUniqueId = 'unique_id';
  static const paramWayPointStatus = "way_point_status";
  static const paramTollCharge = "toll_charge";
  static const paramNoOfToll = "no_of_toll";

  //My Profile
  static const paramDescription = "description";
  static const paramEmergencyContact = "emergency_contact";
  static const paramEmergencyContactName = "emergency_contact_name";
  static const paramErrandType = "errand_type";
  static const paramEmergencyCountryCode = "emergency_country_code";

  //Ride Detail
  static const paramRideId = "ride_id";
  static const paramUserRole = "user_role";
  static const paramContactName = "contact_name";
  static const paramCountryCode = "country_code";

  //OfferRide
  static const paramServiceId = "service_id";
  static const paramOfferedFare = "offered_fare";
  static const paramEstimatedTime = "estimated_time";
  static const paramTotalDistance = "total_distance";
  static const paramPickUpDateTime = "pickup_date_time";
  static const paramAddressList = "address_list";
  static const paramMinBargainAmt = "min_bargain_amt";
  static const paramMaxBargainAmt = "max_bargain_amt";
  static const paramServiceTypeId = "service_type_id";
  static const paramPromoCode = "promo_code";
  static const paramAdditionalRemark = "additional_remarks";
  static const paramRecipientName = "recipient_name";
  static const paramRecipientNumber = "recipient_contact_number";
  static const paramItemDesc = "item_description";
  static const paramEstimatePrice = "estimate_price";
  static const paramIsAutoAccept = "is_auto_accept";
  static const paramDestinationPaymentMethod = "destination_payment_method";
  static const paramPackageWeightKg = "package_weight_kg";
  static const paramPackageHeightCm = "package_height_cm";
  static const paramPackageWidthCm = "package_width_cm";
  static const paramPackageLengthCm = "package_length_cm";
  static const paramRequestedVehicleServiceId = "requested_vehicle_service_id";
  static const paramAcceptDelivery = "accept_delivery";
  static const paramDeliveryVariant = "delivery_variant";
  static const paramAlsoTransportPassengers = "also_transport_passengers";
  static const paramIsTaxi = "is_taxi";
  static const paramChildSeat = "child_seat";
  static const paramHandicap = "handicap";
  static const paramRideForOther = "ride_for_other";
  static const paramOtherUserName = "other_user_name";
  static const paramOtherUserContactNumber = "other_user_contact_number";

  //available Ride
  static const paramUpdateStatus = 'update_status';
  static const paramAcceptTransport = 'accept_transport';
  static const paramOfferedPrice = 'offered_price';

  static const headerSignupPhoneOtp = 'X-Signup-Phone-Otp';
  static const headerSignupPhoneOtpValue = '1';

  //running Ride
  static const paramRideStatus = 'ride_status';

  //Search Wallet
  static const paramSearch = "search";
  static const paramPage = "page";
  static const paramPerPage = "per_page";
  static const paramPaymentType = "payment_type";

  //Manage Card
  static const paramCardId = "card_id";

  //My wallet
  static const paramAmount = "amount";
  static const paramPaymentMethodType = "payment_method_type";

  static const paramTransferId = "transfer_id";
  static const paramWalletProviderType = "wallet_provider_type";

  //Ride Home
  static const paramCurrentLat = "current_lat";
  static const paramCurrentLng = "current_long";
  static const paramServiceCategoryId = "service_category_id";
  static const paramDistance = "distance";
  static const paramEstimateTime = "estimate_time";

  //Ride History
  static const paramTimeZone = "timezone";
  static const paramFilterType = "filter_type";
  static const paramOrderStatus = "order_status";

  //document
  static const paramDocumentIdList = 'document_id_list';
  static const paramDocumentId = 'document_id';
  static const paramExpiryDate = 'expiry_date';
  static const paramDocumentFile = 'document_file';
  static const paramIsUpdate = 'is_update';

  //Manage Vehicle
  static const paramVehicleTypeId = 'vehicle_type_id';
  static const paramManufactureName = 'manufacture_name';
  static const paramModelName = 'model_name';
  static const paramModelYear = 'model_year';
  static const paramTechnicalInspectionExpiry = 'technical_inspection_expiry';
  static const paramVehiclePlatNo = 'vehicle_plat_no';
  static const paramVehicleColor = 'vehicle_color';
  static const paramChildSafetySeat = 'child_safety_seat';
  static const paramHandyCapSeat = 'handy_cap_seat';
  static const paramVehicleImage = 'vehicle_image';
  static const paramVehicleImageFront = 'vehicle_image_front';
  static const paramVehicleImageSide = 'vehicle_image_side';
  static const paramVehicleImageRear = 'vehicle_image_rear';

  //Running Ride
  static const paramCancelReason = "cancel_reason";
  static const paramRating = "rating";
  static const paramComment = "comment";

  //Add Card
  static const paramHolderName = "holder_name";
  static const paramCardNumber = "card_number";
  static const paramMonth = "month";
  static const paramYear = "year";
  static const paramCvv = "cvv";

  //Wallet transactions...
  static const paramOrderBy = "order_by";
  static const paramDateFilter = "date_filter";
  static const paramServiceCategory = "service_category";
  static const paramServiceType = "service_type";
  static const paramRegisteredId = "register_id";

  // //Bank Detail
  static const paramAccountNumber = "account_number";
  static const paramBankName = "bank_name";
  static const paramBankLocation = "bank_location";
  static const paramPaymentEmail = "payment_email";
  static const paramBicSwiftCode = "bic_swift_code";

  //Driver Home
  static const paramSearchDistance = "search_distance";

  static const paramIPAddress = 'select-ip-address';
  static const paramSelectTimeZone = 'select-time-zone';
  static const paramSessionIdHeader = 'session-id';

  //Manage Address
  static const paramAddress = "address";
  static const paramAddressId = "address_id";
  static const paramType = "type";
  static const paramLat = "lat";
  static const paramLong = "long";

  //Report Issue
  static const paramIssueProviderId = "provider_id";
  static const paramIssueProviderType = 'provider_type';
  static const paramProviderServiceId = "provider_service_id";
  static const paramIssueStatus = 'status';
  static const paramIssueGeneralIssueFilter = 'general_issue_filter';
  static const paramIssueReportId = 'report_id';
  static const paramIssueImageId = 'image_id';
  static const paramIssueImage = 'image';

  //Chat
  static const paramChatId = 'chat_id';
  static const paramChatImage = 'chat_image';
  static const paramReportChatNo = 'report_chat_number';
}
