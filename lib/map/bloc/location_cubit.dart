import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationState());

  final _location = Location();

  void init() async {
    await requestPermission();
  }

  // get user location and update state
  Future<LatLng> getUserLocation() async {
    final loc = fromLocationData(await _location.getLocation());
    emit(state.copyWith(position: loc));
    return loc;
  }

  // requests user permission to use location. Once permission is granted,
  // go to user location immediately.
  Future<void> requestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      // if not enabled, request enabling
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        // if not yet enabled, no need to change state
        return;
      }
    }

    PermissionStatus status = await _location.hasPermission();
    if (status == PermissionStatus.denied) {
      // if denied, request permission
      status = await _location.requestPermission();
      // if permission still not granted, emit that service is enabled, but
      // permission still stays denied.
      if (status != PermissionStatus.granted) {
        emit(state.copyWith(serviceEnabled: serviceEnabled));
        return;
      }
    }

    emit(state.copyWith(
        serviceEnabled: serviceEnabled,
        status: status,
        position: fromLocationData(await _location.getLocation())));
  }
}

LatLng fromLocationData(LocationData locationData) {
  return LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
}
