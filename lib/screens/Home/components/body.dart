import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_mao/constants.dart';
import 'package:google_mao/screens/Home/components/custom_app_bar.dart';
import 'package:google_mao/screens/Home/components/custom_menu.dart';
import 'package:google_mao/screens/Home/components/google_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mao/models/Businesses.dart';
import 'package:location/location.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
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

  void getPolyPoints() {
    PolylinePoints polylinePoints = PolylinePoints();
    final streamController = StreamController<PolylinePoints>();
    late StreamSubscription<PolylinePoints> subscription;

    streamController.add(polylinePoints);

    subscription = streamController.stream.listen((event) async {
      PolylineResult result = await event.getRouteBetweenCoordinates(
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
        print('no polylines');
      }
    });
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

  void onTapBusiness(name) {
    print(name);
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: currentLocation == null
                  ? Center(
                      child: Container(
                          margin: EdgeInsets.all(13),
                          padding: EdgeInsets.all(13),
                          decoration: BoxDecoration(
                              color: Color(0xFFE8E9EB),
                              borderRadius: BorderRadius.circular(15)),
                          child:
                              CircularProgressIndicator(color: primaryColor)),
                    )
                  : Stack(children: [
                      GoogleMapComponent(
                          currentLoc: currentLocation!,
                          sourceLoc: sourceLocation,
                          destinationLoc: destination,
                          polyline: polylineCoordinates,
                          sourceIcon: sourceIcon,
                          destinationIcon: destinationIcon,
                          currentLocationIcon: currentLocationIcon,
                          controller: _controller),
                      Positioned(top: 55, child: CustomAppBar()),
                      Positioned(
                          bottom: 30,
                          child: Menu(
                            itemList: itemList,
                            onPressed: (name) => onTapBusiness(name),
                          ))
                    ]))
        ],
      ),
    );
  }
}
