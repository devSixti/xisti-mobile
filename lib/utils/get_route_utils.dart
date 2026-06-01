import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../googleApi/google_api_repo.dart';
import '../googleApi/route_detail_dl.dart';
import 'utils.dart';

class GetRoutesUtils {
  String tag = "GetRuteUtil>>>";

  Future<void> getRoutes(
    LatLng origin,
    LatLng destination,
    List<LatLng> wayPoints,
    Function(Map<PolylineId, Polyline> polyLines, int duration, int distance) callBack,
  ) async {
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
        PolylineId id = PolylineId("poly");
        Polyline polyline = Polyline(
          polylineId: id,
          color: getCurrentTheme(navigatorKey.currentContext!).colorBlack,
          points: polylineCoordinates,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          width: 2.w.toInt(),
        );
        polyLines[id] = polyline;

        duration = int.parse((route.duration ?? "0").replaceAll(RegExp("[a-zA-Z]"), ""));
        distance = route.distanceMeters ?? 0;
        callBack(polyLines, duration, distance);
      } else {
        callBack({}, 0, 0);
      }
    } catch (e) {
      callBack({}, 0, 0);
    }
  }

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
