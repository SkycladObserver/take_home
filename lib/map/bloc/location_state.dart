part of 'location_cubit.dart';

/// Current location of user
class LocationState extends Equatable {
  const LocationState(
      {this.status = PermissionStatus.denied,
      this.serviceEnabled = false,
      this.position});

  final PermissionStatus status;
  final bool serviceEnabled;
  final LatLng? position;

  LocationState copyWith(
          {PermissionStatus? status, bool? serviceEnabled, LatLng? position}) =>
      LocationState(
          status: status ?? this.status,
          serviceEnabled: serviceEnabled ?? this.serviceEnabled,
          position: position ?? this.position);

  @override
  List<Object?> get props => [status, serviceEnabled, position];
}
