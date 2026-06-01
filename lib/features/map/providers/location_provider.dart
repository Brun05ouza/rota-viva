import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/utils/distance_utils.dart';

class LocationState {
  const LocationState({required this.permissionGranted, required this.currentPosition, required this.message});

  final bool permissionGranted;
  final Position? currentPosition;
  final String? message;
}

final locationProvider = NotifierProvider<LocationNotifier, LocationState>(LocationNotifier.new);

class LocationNotifier extends Notifier<LocationState> {
  @override
  LocationState build() {
    return const LocationState(permissionGranted: false, currentPosition: null, message: null);
  }

  Future<void> requestLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      state = const LocationState(
        permissionGranted: false,
        currentPosition: null,
        message: 'Precisamos da sua localização para liberar check-ins nos pontos turísticos.',
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    state = LocationState(permissionGranted: true, currentPosition: position, message: null);
  }

  double distanceTo(double latitude, double longitude) {
    final position = state.currentPosition;
    if (position == null) {
      return double.infinity;
    }
    return DistanceUtils.metersBetween(position.latitude, position.longitude, latitude, longitude);
  }

  bool isInsideRadius(double latitude, double longitude, int radiusMeters) {
    return distanceTo(latitude, longitude) <= radiusMeters;
  }
}
