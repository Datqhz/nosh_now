import 'dart:convert';

import 'package:http/http.dart';
import 'package:nosh_now_application/core/constants/global_variable.dart';
import 'package:nosh_now_application/data/models/vehicle_type.dart';

class VehicleTypeRepository {
  Future<VehicleType?> create(VehicleType vehicleType) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await post(
          Uri.parse("${GlobalVariable.url}/api/vehicleType"),
          headers: headers,
          body: jsonEncode(<String, dynamic>{
            "typeName": vehicleType.typeName,
            "image": vehicleType.icon
          }));
      int statusCode = response.statusCode;
      if (statusCode != 201) {
        return null;
      }
      Map<String, dynamic> data = json.decode(response.body);
      return VehicleType.fromJson(data);
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to save');
    }
  }

  Future<bool> update(VehicleType vehicleType) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await put(Uri.parse("${GlobalVariable.url}/api/vehicleType"),
              headers: headers,
              body: jsonEncode(<String, dynamic>{
                "id": vehicleType.typeId,
                "typeName": vehicleType.typeName,
                "image": vehicleType.icon
              }));
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to save');
    }
  }

  Future<bool> deleteVehicleType(int id) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response =
          await delete(Uri.parse("${GlobalVariable.url}/api/vehicleType/$id"),
              headers: headers,);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to delete');
    }
  }

  Future<List<VehicleType>> getAll() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      Response response = await get(
          Uri.parse("${GlobalVariable.url}/api/vehicleType"),
          headers: headers);
      int statusCode = response.statusCode;
      if (statusCode != 200) {
        return [];
      }
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => VehicleType.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      throw Exception('Fail to get data');
    }
  }
}
