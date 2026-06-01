import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../networking/api_base_helper.dart';
import 'route_detail_dl.dart';

class GoogleApiRepo {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper(baseUrl: BaseUrl.domain + BaseUrl.endPointBaseUrlApi);

  Future placeAutoCompleteApiCall(String search, LatLng currentLatLng) async {
    if (search.isEmpty) {
      return "";
    }
    final response = await _apiBaseHelper.post(
      ApiConst.endPointPlaceAutoComplete,
      body: {ApiParam.paramInput: search, ApiParam.paramLatitude: currentLatLng.latitude, ApiParam.paramLongitude: currentLatLng.longitude},
    );
    return response;
  }

  Future placeDetailApiCall(String placeID) async {
    if (placeID.isNotEmpty) {
      final response = await _apiBaseHelper.post(ApiConst.endPointPlaceDetail, body: {ApiParam.paramPlaceID: placeID});
      return response;
    }
    return "";
  }

  Future routeDataApiCall(double pickupLat, double pickupLong, double destinationLat, double destinationLong, List<LatLng> wayPointList) async {
    List<WayPointPojo> points = [];
    if (wayPointList.isNotEmpty) {
      for (var latLng in wayPointList) {
        points.add(WayPointPojo(latLng.latitude, latLng.longitude));
      }
    }
    final response = await _apiBaseHelper.post(
      ApiConst.endPointRouteDetail,
      body: {
        ApiParam.paramPickupLatitude: pickupLat,
        ApiParam.paramPickupLongitude: pickupLong,
        ApiParam.paramDropLatitude: destinationLat,
        ApiParam.paramDropLongitude: destinationLong,
        ApiParam.paramWaypoint: jsonEncode(points),
      },
    );
    return response;
  }

  String getGeoCodingQuery({required double latitude, required double longitude}) {
    return "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=";
  }

  Future geoCodingApiCall(double latitude, double longitude) async {
    final response = await _apiBaseHelper.post(
      ApiConst.endPointGoogleMap,
      body: {ApiParam.paramUrl: getGeoCodingQuery(latitude: latitude, longitude: longitude)},
    );
    return response;
  }
}
