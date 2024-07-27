import 'package:flutter/foundation.dart';
import 'package:nosh_now_application/data/models/vehicle_type.dart';
import 'package:nosh_now_application/data/repositories/vehicle_type_repository.dart';

class VehicleTypeListProvider with ChangeNotifier {
  List<VehicleType> _types = [];
  bool _isLoading = true;

  List<VehicleType> get types => _types;
  bool get isLoading => _isLoading;

  void updateVehicleType(int id, VehicleType newVehicleType) {
    final index = _types.indexWhere((type) => type.typeId == id);
    if (index != -1) {
      _types[index].typeName = newVehicleType.typeName;
      _types[index].icon = newVehicleType.icon;
      notifyListeners(); 
    }
  }
  void deleteVehicleType(int id) {
    final index = _types.indexWhere((type) => type.typeId == id);
    if (index != -1) {
      _types.removeAt(index);
      notifyListeners(); 
    }
  }
  void addVehicleType(VehicleType type) {
      _types.add(type);
      notifyListeners(); 
    }


  Future<void> fetchVehicleTypes() async {
    try {
      _types = await VehicleTypeRepository().getAll();
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }
}
