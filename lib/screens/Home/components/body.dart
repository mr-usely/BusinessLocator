import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_mao/function/function.dart';
import 'package:google_mao/models/ProfileMenus.dart';
import 'package:google_mao/models/UnitMeasure.dart';
import 'package:google_mao/models/menus.dart';
import 'package:google_mao/screens/Home/components/card_body.dart';
import 'package:google_mao/screens/Home/components/menu_contianer.dart';
import 'package:google_mao/screens/Home/components/profile_menu_container.dart';
import 'package:google_mao/screens/Login/login_screen.dart';
import 'package:google_mao/utils/constants.dart';
import 'package:google_mao/screens/Home/components/custom_app_bar.dart';
import 'package:google_mao/screens/Home/components/custom_menu.dart';
import 'package:google_mao/screens/Home/components/dashboard_detail.dart';
import 'package:google_mao/screens/Home/components/google_map.dart';
import 'package:google_mao/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mao/models/Businesses.dart';
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
  bool isLoadPolyline = false;
  bool isDockMenu = false;
  bool isCardBody = false;
  String cardBodyTitle = "";
  bool isMenuOpened = false;
  bool isProfileMenuOpened = false;
  bool showFavoriteIcon = false;
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  LatLng? destination;

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    try {
      Location location = Location();
      if (!mounted) return;

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
    } catch (e) {
      print(e);
    }
  }

  void getPolyPoints() async {
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      if (!mounted) return;

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          google_api_key,
          currentLocation == null
              ? PointLatLng(sourceLocation.latitude, sourceLocation.longitude)
              : PointLatLng(
                  currentLocation!.latitude!, currentLocation!.longitude!),
          PointLatLng(destination!.latitude, destination!.longitude));

      if (result.points.isNotEmpty && mounted) {
        setState(() {
          result.points.forEach((PointLatLng point) =>
              polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
          isLoadPolyline = true;
        });
      } else {
        print('no polylines');
        isLoadPolyline = true;
      }
    } catch (e) {
      print(e);
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
    isLoadPolyline = false;

    polylineCoordinates.clear();

    isSetSelected(id);

    isOnDelete(id);

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

  void isOnDelete(id) {
    for (var item in itemList) {
      if (item.id == id) {
        item.isOnDelete = true;
      } else {
        item.isSelected = false;
      }
    }
  }

  void isOpenMenu() {
    isMenuOpened = !isMenuOpened;
  }

  void isMenu(menu) {
    if (menu == "Businesses") {
      isCardBody = true;
      isDockMenu = true;
      isMenuOpened = false;
      showFavoriteIcon = false;
      cardBodyTitle = "List of Businesses";
    } else if (menu == "Favorites") {
      isCardBody = true;
      isDockMenu = true;
      isMenuOpened = false;
      showFavoriteIcon = true;
      cardBodyTitle = "Favorites";
    }
  }

  void isOpenProfileMenu() {
    isProfileMenuOpened = !isProfileMenuOpened;
  }

  void profileMenu(menu) {
    if (menu == "Profile") {
      isProfileMenuOpened = false;
    } else if (menu == "Logout") {
      Fun.loggedUser = null;
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => const LoginScreen())));
    }
  }

  void refreshIndicator() {
    setState(() {
      getCurrentLocation();
      setCustomMarkerIcon();
      getPolyPoints();
    });
  }

  @override
  void initState() {
    destination = const LatLng(16.93614706510525, 121.76414004065758);

    if (mounted) {
      getCurrentLocation();
      setCustomMarkerIcon();
      getPolyPoints();
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                          distance: distanceInKm,
                          user: Fun.loggedUser == null
                              ? 'Invalid User'
                              : Fun.loggedUser!.firstName!,
                          currentLoc: currentLocation!,
                          sourceLoc: sourceLocation,
                          destinationLoc: destination!,
                          polyline: polylineCoordinates,
                          sourceIcon: sourceIcon,
                          destinationIcon: destinationIcon,
                          currentLocationIcon: currentLocationIcon,
                          controller: _controller),

                      // Load if polyline is on process
                      !isLoadPolyline
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
                              onTapMenu: () => isOpenMenu(),
                              onTapProfileMenu: () => isOpenProfileMenu())),

                      // Dashboard
                      Positioned(
                          top: 105,
                          child: DashboardDetail(
                              distance: distanceInKm,
                              time: travelDuration,
                              timeUnit: timeUnit)),

                      // Menus button
                      Positioned(
                          top: size.height * 0.12,
                          child: isMenuOpened
                              ? MenuContainer(
                                  onPressed: (menu) => isMenu(menu),
                                  menusList: menus)
                              : SizedBox()),

                      // Profile Menus button
                      Positioned(
                          top: size.height * 0.12,
                          right: 0,
                          child: isProfileMenuOpened
                              ? ProfileMenuContainer(
                                  onPressed: (menu) => profileMenu(menu),
                                  menusList: profileMenus)
                              : SizedBox()),

                      // List of business
                      Positioned(
                          top: 218,
                          child: isCardBody
                              ? Stack(
                                  children: [
                                    CardBody(
                                      title: cardBodyTitle,
                                      itemList: itemList,
                                      favoriteIcon: showFavoriteIcon,
                                      onPressed: (id, name, lat, lng) {
                                        onTapBusiness(id, name, lat, lng);
                                        isCardBody = false;
                                      },
                                    ),
                                    Positioned(
                                        left: size.width * 0.37,
                                        bottom: 20,
                                        child: GestureDetector(
                                          onTap: () => isCardBody = false,
                                          child: Container(
                                            width: size.width * 0.25,
                                            height: 3,
                                            decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ))
                                  ],
                                )
                              : SizedBox()),

                      // List of nearest businesses
                      Positioned(
                          bottom: isDockMenu ? 10 : 30,
                          child: Menu(
                            dockMenu: isDockMenu,
                            onDockMenu: () {
                              isDockMenu = !isDockMenu;
                              isCardBody = false;
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
