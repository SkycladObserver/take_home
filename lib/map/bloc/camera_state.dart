part of 'camera_cubit.dart';

class CameraState extends Equatable {
  CameraState({this.position = const LatLng(0, 0), this.forceAnimate = false});

  final LatLng position;
  // even if position hasn't change, force animate to same position. Toggling
  // forceAnimate will signal Equatable that the object is not the same
  final bool forceAnimate;

  CameraState doForceAnimate({required LatLng position}) =>
      CameraState(position: position, forceAnimate: !this.forceAnimate);

  @override
  List<Object?> get props => [position, forceAnimate];
}
