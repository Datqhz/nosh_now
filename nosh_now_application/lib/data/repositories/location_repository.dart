import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/core/utils/shared_preference.dart';
import 'package:nosh_now_application/data/models/food.dart';
import 'package:nosh_now_application/data/models/location.dart';

class LocationRepository {
  Future<Location> create(Location location, int eaterId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await post(Uri.parse("${GlobalVariable.url}/api/location"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                "locationName": location.locationName,
                "phone": location.phone,
                "coordinator": location.coordinator,
                "default": location.defaultLocation,
                "eaterId": eaterId
              }));
      int statusCode = response.statusCode;
      if (statusCode != 201) {
        print(response.body);
        throw Exception();
      }
      return Location.fromJson(json.decode(response.body));
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to save location');
    }
  }

  Future<Location> update(
    Location location,
  ) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await put(Uri.parse("${GlobalVariable.url}/api/location"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                'id': location.locationId,
                "locationName": location.locationName,
                "phone": location.phone,
                "coordinator": location.coordinator,
                "default": location.defaultLocation,
              }));
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        throw Exception();
      }
      return Location.fromJson(json.decode(response.body));
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to save location');
    }
  }

  Future<bool> deleteSavedLocation(int id) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await delete(
        Uri.parse("${GlobalVariable.url}/api/location/$id"),
        headers: headers,
      );
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to delete location');
    }
  }

  Future<List<Location>> getAllByEater(int eaterId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/location/user/$eaterId"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => Location.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }

  Future<Location> getDefaultLocationByEater(int eaterId) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/location/default/user/$eaterId"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        throw Exception();
      }
      Map<String, dynamic> data = json.decode(response.body);
      return Location.fromJson(data);
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }
}
