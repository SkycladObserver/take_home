import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:take_home/map/model/directions.dart';
import 'package:take_home/map/repository/directions_repository.dart';

part 'destination_state.dart';

/// shows/hides random destination. Every show will be a random destination within
/// 10km.
class DestinationCubit extends Cubit<DestinationState> {
  DestinationCubit(this._dirRepo) : super(DestinationState());

  final DirectionsRepository _dirRepo;
  final Random random = Random();

  // note that google's docs themselves mentioned that ~10km away from center point
  // is +/- 0.1 LatLng.
  // https://developers.google.com/maps/documentation/javascript/examples/places-autocomplete-multiple-countries
  static const double maxDistance = .1;

  /// shows the directions from [origin] to destination
  Future<void> showRandomDestination(LatLng origin) async {
    final destination = _generateRandomDestination(origin);

    // show marker, the directions can come later
    emit(state.copyWith(status: DestinationStatus.show, position: destination));

    final directions =
        await _dirRepo.getDirections(origin: origin, destination: destination);

    emit(state.copyWith(directions: directions));
  }

  void hideDestination() {
    // hide, clear directions
    emit(state.copyWith(status: DestinationStatus.hide, directions: null));
  }

  /// generate a random point within a circle where radius = [maxDistance]
  /// and center = [origin]
  LatLng _generateRandomDestination(LatLng origin) {
    final r = maxDistance * sqrt(random.nextDouble());
    final theta = random.nextDouble() * 2 * pi;

    final x = origin.latitude + r * cos(theta);
    final y = origin.longitude + r * sin(theta);

    return LatLng(x, y);
  }
}
