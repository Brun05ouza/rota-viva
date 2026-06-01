import 'dart:math';

class DistanceUtils {
  static double metersBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const earthRadius = 6371000.0;
    final dLat = _degreesToRadians(endLatitude - startLatitude);
    final dLon = _degreesToRadians(endLongitude - startLongitude);
    final lat1 = _degreesToRadians(startLatitude);
    final lat2 = _degreesToRadians(endLatitude);

    final a = pow(sin(dLat / 2), 2) +
        cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    final c = 2 * atan2(sqrt(a.toDouble()), sqrt(1 - a.toDouble()));
    return earthRadius * c;
  }

  static double _degreesToRadians(double value) => value * pi / 180;
}
