import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mao/utils/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapComponent extends StatelessWidget {
  const GoogleMapComponent(
      {super.key,
      required this.currentLoc,
      required this.sourceLoc,
      required this.destinationLoc,
      required this.polyline,
      required this.sourceIcon,
      required this.destinationIcon,
      required this.currentLocationIcon,
      required this.controller});
  final LocationData currentLoc;
  final LatLng sourceLoc;
  final LatLng destinationLoc;
  final List<LatLng> polyline;
  final BitmapDescriptor sourceIcon;
  final BitmapDescriptor destinationIcon;
  final BitmapDescriptor currentLocationIcon;
  final Completer<GoogleMapController> controller;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(
          target: LatLng(currentLoc.latitude!, currentLoc.longitude!),
          zoom: 13.5),
      polylines: {
        Polyline(
            polylineId: PolylineId("route"),
            points: polyline,
            color: primaryColor,
            width: 6)
      },
      markers: {
        Marker(
            markerId: const MarkerId("currentLocation"),
            icon: currentLocationIcon,
            position: LatLng(currentLoc.latitude!, currentLoc.longitude!),
            infoWindow: InfoWindow(title: 'User', snippet: '22kms')),
        Marker(
            markerId: MarkerId("source"),
            icon: sourceIcon,
            position: currentLoc == null
                ? sourceLoc
                : LatLng(currentLoc.latitude!, currentLoc.longitude!)),
        Marker(
            markerId: MarkerId("destination"),
            icon: destinationIcon,
            position: destinationLoc)
      },
      onMapCreated: (mapController) {
        controller.complete(mapController);
      },
    );
  }
}
