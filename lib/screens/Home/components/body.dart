import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_mao/function/function.dart';
import 'package:google_mao/models/ProfileMenus.dart';
import 'package:google_mao/models/UnitMeasure.dart';
import 'package:google_mao/models/menus.dart';
import 'package:google_mao/screens/Home/components/card_body.dart';
import 'package:google_mao/screens/Home/components/custom_card.dart';
import 'package:google_mao/screens/Home/components/item_barangays.dart';
import 'package:google_mao/screens/Home/components/list_businesses.dart';
import 'package:google_mao/screens/Home/components/menu_contianer.dart';
import 'package:google_mao/screens/Home/components/profile_menu_container.dart';
import 'package:google_mao/screens/Login/login_screen.dart';
import 'package:google_mao/screens/Profile/profile_screen.dart';
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
  final TextEditingController _searchItem = TextEditingController();
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
  bool showSearchCard = false;
  bool isSearchLoad = false;
  Timer? timer;
  List<Businesses> itemBusinesses = Fun.itemListBusinesses;
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
      if (kDebugMode) print(e);
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
        if (kDebugMode) print('no polylines');
        isLoadPolyline = true;
      }
    } catch (e) {
      if (kDebugMode) print(e);
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

    isSetSelected(id);

    polylineCoordinates.clear();

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

  void onSearchItem(item) {
    isSearchLoad = true;

    Fun.isSearchItem(item);

    if (Fun.searchedItems != null) {
      setState(() {
        itemBusinesses = Fun.searchedItems;
        isSearchLoad = false;
      });
    }
  }

  void isOnAddFavorite(businessId) async {
    var res = await Fun.addFavorites(Fun.loggedUser!.id, businessId);

    if (res == "added") {
      Fun.openDialog(context, CupertinoIcons.check_mark_circled,
          "Added favorites", Colors.green);
    } else {
      Fun.openDialog(
          context,
          CupertinoIcons.check_mark,
          "The service may not be available please try again later.",
          primaryColor);
    }
  }

  void isSetSelected(id) {
    for (var item in Fun.businessList) {
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

  void isOpenListBusinesses(barangay) {
    cardBodyTitle = "Businesses in $barangay";
    showFavoriteIcon = false;

    List<Businesses> businessesInBrgys = Fun.filterBusinesses(barangay);

    setState(() {
      itemBusinesses = businessesInBrgys;
    });
  }

  void isOpenMenu() {
    isMenuOpened = !isMenuOpened;
  }

  void isMenu(menu) {
    if (menu == "Barangays") {
      isCardBody = true;
      isDockMenu = true;
      isMenuOpened = false;
      showFavoriteIcon = false;
      showSearchCard = false;
      cardBodyTitle = "Barangays";
    } else if (menu == "Favorites") {
      cardBodyTitle = "Favorites";
      Fun.loadAllFavorites(Fun.loggedUser!.id);
      setState(() {
        itemBusinesses = Fun.itemFavorites;
        isCardBody = true;
        isDockMenu = true;
        isMenuOpened = false;
        showFavoriteIcon = true;
        showSearchCard = false;
      });
    } else if (menu == "Search") {
      isCardBody = false;
      showSearchCard = true;
      isDockMenu = true;
      isMenuOpened = false;
      showFavoriteIcon = false;
    }
  }

  void isOpenProfileMenu() {
    isProfileMenuOpened = !isProfileMenuOpened;
  }

  void profileMenu(menu) {
    if (menu == "Profile") {
      isProfileMenuOpened = false;
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => const ProfileScreen())));
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
      Fun.isGetNearbyBusinesses(
          Fun.currentLoc!.latitude, Fun.currentLoc!.longitude);
      Fun.loadAllFavorites(Fun.loggedUser!.id);
    }

    timer = Timer.periodic(
        Duration(seconds: 10),
        (Timer timer) => Fun.isGetNearbyBusinesses(
            currentLocation!.latitude, currentLocation!.longitude));

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

                      // Main Card
                      Positioned(
                          top: 218,
                          child: isCardBody
                              ? Stack(
                                  children: [
                                    if (cardBodyTitle == "Barangays")
                                      CardBody(
                                        title: cardBodyTitle,
                                        onPressedBack: () => null,
                                        widget: Container(
                                          height: size.height * 0.37,
                                          margin: EdgeInsets.only(top: 10),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: GridView.builder(
                                              itemCount:
                                                  Fun.barangayList.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      mainAxisSpacing: 20,
                                                      crossAxisSpacing: 20,
                                                      childAspectRatio: 0.75),
                                              itemBuilder: (context, index) =>
                                                  ItemBarangays(
                                                    barangays:
                                                        Fun.barangayList[index],
                                                    pressed: (barangay) =>
                                                        isOpenListBusinesses(
                                                            barangay),
                                                  )),
                                        ),
                                      ),
                                    cardBodyTitle != "Barangays"
                                        ? CardBody(
                                            title: cardBodyTitle,
                                            onPressedBack: () =>
                                                isMenu("Barangays"),
                                            widget: Container(
                                              height: size.height * 0.37,
                                              margin: EdgeInsets.only(top: 10),
                                              child: ListView.builder(
                                                  itemCount:
                                                      itemBusinesses.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return ListBusinesses(
                                                        favoriteIcon:
                                                            showFavoriteIcon,
                                                        business:
                                                            itemBusinesses[
                                                                index],
                                                        addFavorite: (id) =>
                                                            isOnAddFavorite(id),
                                                        onPressed: (id, name,
                                                            lat, lng) {
                                                          onTapBusiness(id,
                                                              name, lat, lng);
                                                          isCardBody = false;
                                                        },
                                                        onSlideRight: () =>
                                                            itemBusinesses[
                                                                        index]
                                                                    .isOnDelete =
                                                                true,
                                                        onSlideLeft: () =>
                                                            itemBusinesses[
                                                                        index]
                                                                    .isOnDelete =
                                                                false);
                                                  }),
                                            ),
                                          )
                                        : SizedBox(),
                                    // Close Bar
                                    Positioned(
                                        bottom: 20,
                                        child: GestureDetector(
                                          onTap: () => isCardBody = false,
                                          child: Container(
                                            width: size.width,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8.0,
                                                  bottom: 8.0,
                                                  left: size.width * 0.35,
                                                  right: size.width * 0.35),
                                              child: Container(
                                                width: size.width * 0.25,
                                                height: 3,
                                                decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        ))
                                  ],
                                )
                              : SizedBox()),

                      // Card for search
                      if (showSearchCard)
                        Positioned(
                            top: 218,
                            child: isSearchLoad
                                ? Center(
                                    child: Container(
                                        margin: EdgeInsets.all(13),
                                        padding: EdgeInsets.all(13),
                                        decoration: BoxDecoration(
                                            color: Color(0xFFE8E9EB),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: CircularProgressIndicator(
                                            color: primaryColor)),
                                  )
                                : Stack(
                                    children: [
                                      CustomCard(
                                        textController: _searchItem,
                                        onSearch: (items) =>
                                            onSearchItem(items),
                                        widget: Container(
                                          height: size.height * 0.37,
                                          margin: EdgeInsets.only(top: 10),
                                          child: ListView.builder(
                                              itemCount: itemBusinesses.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ListBusinesses(
                                                    favoriteIcon:
                                                        showFavoriteIcon,
                                                    business:
                                                        itemBusinesses[index],
                                                    addFavorite: (id) =>
                                                        isOnAddFavorite(id),
                                                    onPressed:
                                                        (id, name, lat, lng) {
                                                      onTapBusiness(
                                                          id, name, lat, lng);
                                                      showSearchCard = false;
                                                    },
                                                    onSlideRight: () =>
                                                        itemBusinesses[index]
                                                            .isOnDelete = true,
                                                    onSlideLeft: () =>
                                                        itemBusinesses[index]
                                                                .isOnDelete =
                                                            false);
                                              }),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 20,
                                          child: GestureDetector(
                                            onTap: () => showSearchCard = false,
                                            child: Container(
                                              width: size.width,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 8.0,
                                                    bottom: 8.0,
                                                    left: size.width * 0.35,
                                                    right: size.width * 0.35),
                                                child: Container(
                                                  width: size.width * 0.25,
                                                  height: 3,
                                                  decoration: BoxDecoration(
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              ),
                                            ),
                                          ))
                                    ],
                                  )),

                      // List of nearest businesses
                      Positioned(
                          bottom: isDockMenu ? 10 : 30,
                          child: Menu(
                            dockMenu: isDockMenu,
                            onDockMenu: () {
                              isDockMenu = !isDockMenu;
                              isCardBody = false;
                            },
                            itemList: Fun.businessList,
                            onPressed: (id, name, lat, lng) =>
                                onTapBusiness(id, name, lat, lng),
                          )),
                    ]))
        ],
      ),
    );
  }
}
