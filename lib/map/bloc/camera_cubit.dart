import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraState());

  animateTo(LatLng destination) {
    emit(state.doForceAnimate(position: destination));
  }
}
