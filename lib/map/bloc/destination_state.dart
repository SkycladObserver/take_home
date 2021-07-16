part of 'destination_cubit.dart';

enum DestinationStatus { show, hide }

class DestinationState extends Equatable {
  DestinationState(
      {this.status = DestinationStatus.hide,
      this.position = const LatLng(0, 0),
      this.directions});

  DestinationState copyWith(
          {LatLng? position,
          DestinationStatus? status,
          Directions? directions}) =>
      DestinationState(
          status: status ?? this.status,
          position: position ?? this.position,
          directions: directions);

  final DestinationStatus status;
  final LatLng position;
  final Directions? directions;

  bool get isHidden => DestinationStatus.hide == this.status;
  bool get hasDirections => this.directions != null;

  List<LatLng>? get polylineToLatLng => directions?.polylinePoints
      ?.map((point) => LatLng(point.latitude, point.longitude))
      .toList();

  @override
  List<Object?> get props => [status, position, directions];
}
