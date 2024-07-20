 import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> _checkPermissions() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      if (await Permission.location.request().isGranted) {
        _getCurrentLocation();
      }
    } else {
      _getCurrentLocation();
    }
  }

  Future<LatLng> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return LatLng(position.latitude, position.longitude);
  }

  Future<List<LatLng>> getRouteCoordinates(LatLng start, LatLng end) async {
  final url =
      'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';
  final response = await get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final coordinates = data['routes'][0]['geometry']['coordinates'];
    return coordinates
        .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
        .toList();
  } else {
    throw Exception('Failed to load route');
  }
}

Future<String> getAddressFromLatLng(LatLng latlng) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latlng.latitude, latlng.longitude);

    Placemark place = placemarks[0];
    var output = 'No results found.';
    if (placemarks.isNotEmpty) {
      output =
          "${place.street}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}";
    }
    return output;
  } catch (e) {
    print(e);
    throw Exception();
  }
}

Future<LatLng> checkPermissions() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      if (await Permission.location.request().isGranted) {
        return await _getCurrentLocation();
      } else {
        throw Exception();
      }
    } else {
      return await _getCurrentLocation();
    }
  }

  Future<LatLng> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    // await _loadRoute(LatLng(position.latitude, position.longitude),
    //     const LatLng(13.297841113632936, 109.06575986815542));
    return LatLng(position.latitude, position.longitude);
  }

  Future<String> getCurrentAddress() async {
    LatLng current = await checkPermissions();
    return getAddressFromLatLng(current);
  } 