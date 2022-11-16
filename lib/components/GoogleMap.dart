import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mao/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapComponent extends StatelessWidget {
  const GoogleMapComponent(
      {Key? key,
      required this.current,
      required this.polyline,
      required this.currentIcon,
      required this.sourceIcon,
      required this.source,
      required this.destinationIcon,
      required this.destination,
      required this.controller})
      : super(key: key);
  final LocationData current;
  final List<LatLng> polyline;
  final LatLng source;
  final LatLng destination;
  final BitmapDescriptor currentIcon;
  final BitmapDescriptor sourceIcon;
  final BitmapDescriptor destinationIcon;
  final Completer<GoogleMapController> controller;
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
          target: LatLng(current.latitude!, current.longitude!), zoom: 13.5),
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
            icon: currentIcon,
            position: LatLng(current.latitude!, current.longitude!),
            infoWindow: InfoWindow(title: 'User', snippet: '22kms')),
        Marker(
            markerId: MarkerId("source"),
            icon: sourceIcon,
            position: current == null
                ? source
                : LatLng(current.latitude!, current.longitude!)),
        Marker(
            markerId: MarkerId("destination"),
            icon: destinationIcon,
            position: destination)
      },
      onMapCreated: (mapController) {
        controller.complete(mapController);
      },
    );
  }
}
