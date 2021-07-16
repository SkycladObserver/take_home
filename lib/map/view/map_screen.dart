import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:take_home/components/tap_to_retry_screen.dart';
import 'package:take_home/map/bloc/camera_cubit.dart';
import 'package:take_home/map/bloc/destination_cubit.dart';
import 'package:take_home/map/bloc/location_cubit.dart';
import 'package:take_home/map/repository/directions_repository.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  static Page get page => const MaterialPage<void>(child: MapScreen());
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => DirectionsRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DestinationCubit(
              RepositoryProvider.of<DirectionsRepository>(context),
            ),
          ),
          BlocProvider(create: (_) => LocationCubit()..init()),
          BlocProvider(create: (_) => CameraCubit()),
        ],
        child: _MapScreenContent(),
      ),
    );
  }
}

class _MapScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationData =
        context.select((LocationCubit cubit) => cubit.state.position);

    if (locationData == null) {
      return TapToRetryScreen(
        content: Text("Location permissions denied. Tap to enable."),
        onTap: () => context.read<LocationCubit>().requestPermission(),
      );
    }

    return Scaffold(
      body: _MapMain(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => onPressedToggleDirections(context),
      ),
    );
  }

  void onPressedToggleDirections(BuildContext context) async {
    final destCubit = BlocProvider.of<DestinationCubit>(context);
    final locCubit = BlocProvider.of<LocationCubit>(context);
    final camCubit = BlocProvider.of<CameraCubit>(context);

    // if destination is not shown, animate to current position
    // and also generate a random destination
    if (destCubit.state.isHidden) {
      final currentLoc = await locCubit.getUserLocation();
      destCubit.showRandomDestination(currentLoc);
      camCubit.animateTo(currentLoc);
    } else {
      destCubit.hideDestination();
    }
  }
}

class _MapMain extends StatefulWidget {
  @override
  State<_MapMain> createState() => _MapMainState();
}

class _MapMainState extends State<_MapMain> {
  final _controller = Completer<GoogleMapController>();

  static const double _zoom = 11;

  @override
  Widget build(BuildContext context) {
    final currentLoc =
        context.select((LocationCubit cubit) => cubit.state.position)!;

    final destinationState =
        context.select((DestinationCubit cubit) => cubit.state);

    return BlocListener<CameraCubit, CameraState>(
      listener: (context, state) {
        animateTo(state);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: currentLoc,
              zoom: _zoom,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('origin'),
                infoWindow: const InfoWindow(title: 'Origin'),
                position: currentLoc,
              ),
              if (!destinationState.isHidden)
                Marker(
                  markerId: const MarkerId('destination'),
                  infoWindow: const InfoWindow(title: 'Destination'),
                  position: destinationState.position,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueMagenta),
                ),
            },
            polylines: {
              if (destinationState.hasDirections)
                Polyline(
                  polylineId: const PolylineId('origin_dest_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: destinationState.polylineToLatLng!,
                ),
            },
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
          )
        ],
      ),
    );
  }

  Future<void> animateTo(CameraState state) async {
    final controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: state.position,
      zoom: _zoom,
    )));
  }
}
