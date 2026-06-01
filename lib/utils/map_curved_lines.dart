import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsCurvedLines {
  static List<LatLng> getPointsOnCurve(LatLng startLocation, LatLng endLocation) {
    // https://medium.com/better-programming/curved-lines-on-google-maps-2938bbb15f6a
    List<LatLng> path = [];
    double angle = pi / 2;
    // ignore: non_constant_identifier_names
    double SE = SphericalUtils.computeDistanceBetween(startLocation, endLocation) as double;
    // ignore: non_constant_identifier_names
    double ME = SE / 2.0;
    double R = ME / sin(angle / 2);
    // ignore: non_constant_identifier_names
    double MO = R * cos(angle / 2);

    double heading = SphericalUtils.computeHeading(startLocation, endLocation) as double;
    LatLng mCoordinate = SphericalUtils.computeOffset(startLocation, ME, heading);

    double direction = (startLocation.longitude - endLocation.longitude > 0) ? -1.0 : 1.0;
    double angleFromCenter = 90.0 * direction;
    LatLng oCoordinate = SphericalUtils.computeOffset(mCoordinate, MO, heading + angleFromCenter);

    path.add(endLocation);

    int num = 100;

    double initialHeading = SphericalUtils.computeHeading(oCoordinate, endLocation) as double;
    double degree = (180.0 * angle) / pi;

    for (int i = 1; i <= num; i++) {
      double step = i.toDouble() * (degree / num.toDouble());
      double heading = (-1.0) * direction;
      LatLng pointOnCurvedLine = SphericalUtils.computeOffset(oCoordinate, R, initialHeading + heading * step);
      path.add(pointOnCurvedLine);
    }

    path.add(startLocation);

    return path;
  }
}

class SphericalUtils {
  // From https://pub.dev/packages/maps_toolkit.
  // Cloned this because the original lib is not compatible with google maps
  static const num earthRadius = 6371009.0;

  /// Returns the distance between two LatLngs, in meters.
  static num computeDistanceBetween(LatLng from, LatLng to) => computeAngleBetween(from, to) * earthRadius;

  /// Returns distance on the unit sphere; the arguments are in radians.
  static num distanceRadians(num lat1, num lng1, num lat2, num lng2) => MathUtil.arcHav(MathUtil.havDistance(lat1, lat2, lng1 - lng2));

  /// Returns the angle between two LatLngs, in radians. This is the same as the
  /// distance on the unit sphere.
  static num computeAngleBetween(LatLng from, LatLng to) =>
      distanceRadians(MathUtil.toRadians(from.latitude), MathUtil.toRadians(from.longitude), MathUtil.toRadians(to.latitude), MathUtil.toRadians(to.longitude));

  /// Returns the heading from one LatLng to another LatLng. Headings are
  /// expressed in degrees clockwise from North within the range [-180,180).
  /// @return The heading in degrees clockwise from north.
  static num computeHeading(LatLng from, LatLng to) {
    // http://williams.best.vwh.net/avform.htm#Crs
    final fromLat = MathUtil.toRadians(from.latitude);
    final fromLng = MathUtil.toRadians(from.longitude);
    final toLat = MathUtil.toRadians(to.latitude);
    final toLng = MathUtil.toRadians(to.longitude);
    final dLng = toLng - fromLng;
    final heading = atan2(sin(dLng) * cos(toLat), cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(dLng));

    return MathUtil.wrap(MathUtil.toDegrees(heading), -180, 180);
  }

  /// Returns the LatLng resulting from moving a distance from an origin
  /// in the specified heading (expressed in degrees clockwise from north).
  /// @param from     The LatLng from which to start.
  /// @param distance The distance to travel.
  /// @param heading  The heading in degrees clockwise from north.
  static LatLng computeOffset(LatLng from, num distance, num heading) {
    distance /= earthRadius;
    heading = MathUtil.toRadians(heading);
    // http://williams.best.vwh.net/avform.htm#LL
    final fromLat = MathUtil.toRadians(from.latitude);
    final fromLng = MathUtil.toRadians(from.longitude);
    final cosDistance = cos(distance);
    final sinDistance = sin(distance);
    final sinFromLat = sin(fromLat);
    final cosFromLat = cos(fromLat);
    final sinLat = cosDistance * sinFromLat + sinDistance * cosFromLat * cos(heading);
    final dLng = atan2(sinDistance * cosFromLat * sin(heading), cosDistance - sinFromLat * sinLat);

    return LatLng(MathUtil.toDegrees(asin(sinLat)).toDouble(), MathUtil.toDegrees(fromLng + dLng).toDouble());
  }
}

class MathUtil {
  static num toRadians(num degrees) => degrees / 180.0 * pi;

  static num toDegrees(num rad) => rad * (180.0 / pi);

  /// Restrict x to the range [low, high].
  static num clamp(num x, num low, num high) => x < low ? low : (x > high ? high : x);

  /// Wraps the given value into the inclusive-exclusive interval between min
  /// and max.
  /// @param n   The value to wrap.
  /// @param min The minimum.
  /// @param max The maximum.
  static num wrap(num n, num min, num max) => (n >= min && n < max) ? n : (mod(n - min, max - min) + min);

  /// Returns the non-negative remainder of x / m.
  /// @param x The operand.
  /// @param m The modulus.
  static num mod(num x, num m) => ((x % m) + m) % m;

  /// Returns mercator Y corresponding to latitude.
  /// See http://en.wikipedia.org/wiki/Mercator_projection .
  static num mercator(num lat) => log(tan(lat * 0.5 + pi / 4));

  /// Returns latitude from mercator Y.
  static num inverseMercator(num y) => 2 * atan(exp(y)) - pi / 2;

  /// Returns haversine(angle-in-radians).
  /// hav(x) == (1 - cos(x)) / 2 == sin(x / 2)^2.
  static num hav(num x) => sin(x * 0.5) * sin(x * 0.5);

  /// Computes inverse haversine. Has good numerical stability around 0.
  /// arcHav(x) == acos(1 - 2 * x) == 2 * asin(sqrt(x)).
  /// The argument must be in [0, 1], and the result is positive.
  static num arcHav(num x) => 2 * asin(sqrt(x));

  // Given h==hav(x), returns sin(abs(x)).
  static num sinFromHav(num h) => 2 * sqrt(h * (1 - h));

  // Returns hav(asin(x)).
  static num havFromSin(num x) => (x * x) / (1 + sqrt(1 - (x * x))) * .5;

  // Returns sin(arcHav(x) + arcHav(y)).
  static num sinSumFromHav(num x, num y) {
    final a = sqrt(x * (1 - x));
    final b = sqrt(y * (1 - y));
    return 2 * (a + b - 2 * (a * y + b * x));
  }

  /// Returns hav() of distance from (lat1, lng1) to (lat2, lng2) on the unit
  /// sphere.
  static num havDistance(num lat1, num lat2, num dLng) => hav(lat1 - lat2) + hav(dLng) * cos(lat1) * cos(lat2);
}
