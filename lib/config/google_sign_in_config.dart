/// Web OAuth client ID (GCP `client_type: 3`) for Google Sign-In on Android.
/// Must match `oauth_client` with `client_type: 3` in `android/app/google-services.json`.
const String kGoogleWebClientId = String.fromEnvironment(
  'GOOGLE_WEB_CLIENT_ID',
  defaultValue: '980764435052-jvlsr21keklk5i5djg3giqqfv35054th.apps.googleusercontent.com',
);
