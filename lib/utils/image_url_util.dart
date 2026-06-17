import '../networking/api_constant.dart';

/// Normalizes profile image paths from the API into loadable HTTPS URLs.
String resolveNetworkProfileImage(String? raw) {
  var image = (raw ?? '').trim();
  if (image.isEmpty || image == '-') {
    return '';
  }

  if (image.startsWith('http://')) {
    image = image.replaceFirst('http://', 'https://');
  }

  if (!image.startsWith('https://')) {
    if (!image.startsWith('/')) {
      image = image.startsWith('assets/') ? '/$image' : '/assets/images/profile-images/customer/$image';
    }
    image = '${BaseUrl.domain}$image';
  }

  return image;
}
