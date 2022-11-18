import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_mao/models/UnitMeasure.dart';
import 'package:google_mao/screens/Home/components/card_body.dart';
import 'package:google_mao/utils/constants.dart';
import 'package:google_mao/screens/Home/components/custom_app_bar.dart';
import 'package:google_mao/screens/Home/components/custom_menu.dart';
import 'package:google_mao/screens/Home/components/dashboard_detail.dart';
import 'package:google_mao/screens/Home/components/google_map.dart';
import 'package:google_mao/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mao/models/Businesses.dart';
import 'package:google_mao/models/Menus.dart';
import 'package:location/location.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String selectedBusiness = "";
  double distanceInKm = 0.0;
  int travelDuration = 0;
  String timeUnit = "sec";
  bool isSelectedItem = false;
  bool isDockMenu = false;
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  LatLng? destination;

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  bool isMenuOpened = false;

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

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        currentLocation == null
            ? PointLatLng(sourceLocation.latitude, sourceLocation.longitude)
            : PointLatLng(
                currentLocation!.latitude!, currentLocation!.longitude!),
        PointLatLng(destination!.latitude, destination!.longitude));

    if (result.points.isNotEmpty) {
      setState(() {
        result.points.forEach((PointLatLng point) =>
            polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
        isSelectedItem = true;
      });
    } else {
      print('no polylines');
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

  void onTapBusiness(id, name, lat, lng) {
    selectedBusiness = name;
    isSelectedItem = false;

    polylineCoordinates.clear();

    isSetSelected(id);

    getTravelTime(
            currentLocation!.latitude, currentLocation!.longitude, lat, lng)
        .then((value) {
      distanceInKm = double.parse(value.distance);
      travelDuration = int.parse(value.time);
      timeUnit = value.timeUnit;
    });

    setState(() {
      destination = LatLng(lat, lng);
      refreshIndicator();
    });
  }

  void isSetSelected(id) {
    for (var item in itemList) {
      if (item.id == id) {
        item.isSelected = true;
      } else {
        item.isSelected = false;
      }
    }
  }

  void isOpenMenu() {
    setState(() {
      isMenuOpened = !isMenuOpened;
      isDockMenu = true;
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
    destination = const LatLng(16.93614706510525, 121.76414004065758);
    getCurrentLocation();
    setCustomMarkerIcon();
    getPolyPoints();
    refreshIndicator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                      // Google Maps
                      GoogleMapComponent(
                          currentLoc: currentLocation!,
                          sourceLoc: sourceLocation,
                          destinationLoc: destination!,
                          polyline: polylineCoordinates,
                          sourceIcon: sourceIcon,
                          destinationIcon: destinationIcon,
                          currentLocationIcon: currentLocationIcon,
                          controller: _controller),

                      // Load if polyline is on process
                      !isSelectedItem
                          ? Center(
                              child: Container(
                                  margin: const EdgeInsets.all(13),
                                  padding: const EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFE8E9EB)
                                          .withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: const CircularProgressIndicator(
                                      color: primaryColor)),
                            )
                          : const SizedBox(),

                      // Custom App Bar
                      Positioned(
                          top: 30,
                          child: CustomAppBar(
                            onTap: () => isOpenMenu(),
                          )),

                      // Dashboard
                      Positioned(
                          top: 105,
                          child: DashboardDetail(
                              distance: distanceInKm,
                              time: travelDuration,
                              timeUnit: timeUnit)),

                      // Menus button
                      Positioned(
                          top: size.height * 0.1,
                          child: isMenuOpened
                              ? Container(
                                  width: 130,
                                  height: 100,
                                  margin: EdgeInsets.all(13),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${menus[0].name}'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${menus[1].name}'),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox()),

                      // List of business
                      Positioned(
                          top: 218,
                          child: CardBody(
                            itemList: itemList,
                          )),

                      // List of nearest businesses
                      Positioned(
                          bottom: isDockMenu ? 10 : 30,
                          child: Menu(
                            resize: isDockMenu,
                            onResized: () {
                              isDockMenu = !isDockMenu;
                            },
                            itemList: itemList,
                            onPressed: (id, name, lat, lng) =>
                                onTapBusiness(id, name, lat, lng),
                          )),
                    ]))
        ],
      ),
    );
  }
}
