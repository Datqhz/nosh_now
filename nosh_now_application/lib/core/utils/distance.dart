import 'dart:math';

double calcDistanceInKm(double lat1, double lon1, double lat2, double lon2)
    {
        const double R = 6371; 
        double dLat = degreesToRadians(lat2 - lat1);
        double dLon = degreesToRadians(lon2 - lon1);

        double a = sin(dLat / 2) * sin(dLat / 2) +
                   cos(degreesToRadians(lat1)) * cos(degreesToRadians(lat2)) *
                   sin(dLon / 2) * sin(dLon / 2);
        double c = 2 * atan2(sqrt(a), sqrt(1 - a));

        return R * c; 
    }

double degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}