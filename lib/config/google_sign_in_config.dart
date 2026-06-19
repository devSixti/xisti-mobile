/// Web OAuth client ID (GCP `client_type: 3`) — required on Android for ID tokens.
/// Must match `oauth_client` with `client_type: 3` in `android/app/google-services.json`.
const String kGoogleWebClientId = String.fromEnvironment(
  'GOOGLE_WEB_CLIENT_ID',
  defaultValue: '980764435052-jvlsr21keklk5i5djg3giqqfv35054th.apps.googleusercontent.com',
);

/// iOS OAuth client ID (`client_type: 2` in Firebase / GCP for `com.app.xisti`).
/// Must match `GIDClientID` in `ios/Runner/Info.plist` and `CLIENT_ID` in GoogleService-Info.plist.
const String kGoogleIosClientId = String.fromEnvironment(
  'GOOGLE_IOS_CLIENT_ID',
  defaultValue: '980764435052-rudvg41gq53dr17pce16a5p0adsuq226.apps.googleusercontent.com',
);
