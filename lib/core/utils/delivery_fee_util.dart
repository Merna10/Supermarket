import 'dart:math';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double R = 6371; // Radius of the Earth in km
  double dLat = _degToRad(lat2 - lat1);
  double dLon = _degToRad(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
             cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
             sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = R * c;
  return distance;
}

double _degToRad(double deg) {
  return deg * (pi / 180);
}

double calculateDeliveryFee(double distance) {
  if (distance <= 5) {
    return 20.0; } else if (distance <= 20) {
    return 20.0 + (distance - 5) * 0.5; } else {
    return 25.0 + (distance - 20) * 0.2; }
}