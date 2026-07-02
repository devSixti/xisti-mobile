import '../hive/hive_helper.dart';
import '../main.dart';

/// Maps API `cancel_by` role codes to localized labels for UI display.
String localizeCancelBy(String? raw) {
  final text = (raw ?? '').trim();
  if (text.isEmpty) return '';

  switch (text.toLowerCase()) {
    case 'driver':
      return languages.driver;
    case 'user':
    case 'passenger':
    case 'customer':
      return languages.customer;
    case 'admin':
      return _localizedAdminRole();
    default:
      return text;
  }
}

String _localizedAdminRole() {
  final language = getLanguageFromUserPrefBox().toLowerCase();
  if (language.startsWith('es')) return 'administrador';
  if (language.startsWith('pt')) return 'administrador';
  if (language.startsWith('fr')) return 'administrateur';
  if (language.startsWith('it')) return 'amministratore';
  return 'admin';
}

/// Maps common English SOS contact labels from admin config to localized names.
String localizeSosContactName(String? raw) {
  final text = (raw ?? '').trim();
  if (text.isEmpty) return '';

  final language = getLanguageFromUserPrefBox().toLowerCase();
  if (!language.startsWith('es')) return text;

  switch (text.toLowerCase()) {
    case 'health':
    case 'helth':
      return 'Salud';
    case 'police':
      return 'Policía';
    case 'fire':
    case 'fire department':
      return 'Bomberos';
    case 'emergency':
      return 'Emergencia';
    default:
      return text;
  }
}
