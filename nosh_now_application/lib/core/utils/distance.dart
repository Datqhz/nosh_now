import 'dart:math';

double calcDistanceInKm(
    {double? lat1,
    double? lon1,
    double? lat2,
    double? lon2,
    String? coordinator1,
    String? coordinator2}) {
  const double R = 6371;
  if (coordinator1 != null && coordinator2 != null) {
    List<dynamic> coord1 = splitCoordinatorString(coordinator1);
    List<dynamic> coord2 = splitCoordinatorString(coordinator2);
    lat1 = coord1[0];
    lon1 = coord1[1];
    lat2 = coord2[0];
    lon2 = coord2[1];
  }
  double dLat = degreesToRadians(lat2! - lat1!);
  double dLon = degreesToRadians(lon2! - lon1!);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(degreesToRadians(lat1)) *
          cos(degreesToRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return double.parse((R * c).toStringAsFixed(2));
}

double degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}

List<dynamic> splitCoordinatorString(String coordinator) {
  var coords = coordinator.split('-');
  double lat = double.parse(coords[0].trim());
  double lon = double.parse(coords[1].trim());
  return [lat, lon];
}
