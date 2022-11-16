import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_mao/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination =
      LatLng(16.93614706510525, 121.76414004065758);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      setState(() {
        currentLocation = location;
        print(currentLocation);
      });
    });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      setState(() {
        currentLocation = newLoc;

        googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                zoom: 13.5,
                target: LatLng(newLoc.latitude!, newLoc.longitude!))));
      });
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        currentLocation == null
            ? PointLatLng(sourceLocation.latitude, sourceLocation.longitude)
            : PointLatLng(
                currentLocation!.latitude!, currentLocation!.longitude!),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.points.isNotEmpty) {
      setState(() {
        result.points.forEach((PointLatLng point) =>
            polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      });
    } else {
      print('no polyline');
    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_source.png")
        .then((icon) {
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_destination.png")
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Badge.png")
        .then((icon) {
      currentLocationIcon = icon;
    });
  }

  void refreshIndicator() async {
    await Future.delayed(Duration(milliseconds: 3000));
    setState(() {
      getCurrentLocation();
      setCustomMarkerIcon();
      getPolyPoints();
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    getPolyPoints();
    refreshIndicator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Business Locator",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Stack(
        children: [
          currentLocation == null
              ? const Center(child: Text('Loading..'))
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                      zoom: 13.5),
                  polylines: {
                    Polyline(
                        polylineId: PolylineId("route"),
                        points: polylineCoordinates,
                        color: primaryColor,
                        width: 6)
                  },
                  markers: {
                    Marker(
                        markerId: const MarkerId("currentLocation"),
                        icon: currentLocationIcon,
                        position: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                        infoWindow:
                            InfoWindow(title: 'User', snippet: '22kms')),
                    Marker(
                        markerId: MarkerId("source"),
                        icon: sourceIcon,
                        position: currentLocation == null
                            ? sourceLocation
                            : LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!)),
                    Marker(
                        markerId: MarkerId("destination"),
                        icon: destinationIcon,
                        position: destination)
                  },
                  onMapCreated: (mapController) {
                    _controller.complete(mapController);
                  },
                ),
          Positioned(
              child: Row(
            children: [
              Expanded(
                child: Container(
                    margin: EdgeInsets.all(13),
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Stack(
                      children: [Text('data')],
                    )),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
