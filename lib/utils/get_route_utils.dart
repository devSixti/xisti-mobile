import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../googleApi/google_api_repo.dart';
import '../googleApi/route_detail_dl.dart';
import 'route_metrics_util.dart';
import 'utils.dart';

class GetRoutesUtils {
  String tag = "GetRuteUtil>>>";

  Future<void> getRoutes(
    LatLng origin,
    LatLng destination,
    List<LatLng> wayPoints,
    Function(Map<PolylineId, Polyline> polyLines, int duration, int distance) callBack,
  ) async {
    if (!isPlausibleRouteCoordinate(origin.latitude, origin.longitude)
        || !isPlausibleRouteCoordinate(destination.latitude, destination.longitude)) {
      callBack(_fallbackRoute(origin, destination), _fallbackDuration(origin, destination), _fallbackDistance(origin, destination));
      return;
    }
    try {
      var response = RouteDetailPojo.fromJson(
        await GoogleApiRepo().routeDataApiCall(origin.latitude, origin.longitude, destination.latitude, destination.longitude, wayPoints),
      );

      if (response.routes != null && (response.routes ?? []).isNotEmpty) {
        List<LatLng> polylineCoordinates = [];
        Map<PolylineId, Polyline> polyLines = {};
        int duration = 0, distance = 0;
        Routes route = response.routes!.first;
        List<LatLng> points = decodeEncodedPolyline(route.polyline?.encodedPolyline ?? "");
        if (points.isNotEmpty) {
          for (var point in points) {
            polylineCoordinates.add(point);
          }
        }
        if (polylineCoordinates.isEmpty) {
          polylineCoordinates = [origin, ...wayPoints, destination];
        }
        PolylineId id = PolylineId("poly");
        final theme = getCurrentTheme(navigatorKey.currentContext!);
        Polyline polyline = Polyline(
          polylineId: id,
          color: theme.colorPrimary,
          points: polylineCoordinates,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          width: 5,
        );
        polyLines[id] = polyline;

        duration = parseRouteDurationSeconds(route.duration);
        distance = route.distanceMeters ?? 0;
        if (distance <= 0) {
          distance = _fallbackDistance(origin, destination);
        }
        if (duration <= 0) {
          duration = estimateDurationSecondsFromMeters(distance);
        }
        callBack(polyLines, duration, distance);
      } else {
        callBack(_fallbackRoute(origin, destination), _fallbackDuration(origin, destination), _fallbackDistance(origin, destination));
      }
    } catch (e) {
      callBack(_fallbackRoute(origin, destination), _fallbackDuration(origin, destination), _fallbackDistance(origin, destination));
    }
  }

  Map<PolylineId, Polyline> _fallbackRoute(LatLng origin, LatLng destination) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      return {};
    }
    final theme = getCurrentTheme(context);
    final id = PolylineId("poly");
    return {
      id: Polyline(
        polylineId: id,
        color: theme.colorPrimary,
        points: [origin, destination],
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        width: 5,
      ),
    };
  }

  int _fallbackDistance(LatLng origin, LatLng destination) => haversineDistanceMeters(origin, destination);

  int _fallbackDuration(LatLng origin, LatLng destination) =>
      estimateDurationSecondsFromMeters(_fallbackDistance(origin, destination));

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }
}
