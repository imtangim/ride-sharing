import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:location/location.dart';
import 'package:ticket_manager/Model/autocomplete.dart';
import 'package:ticket_manager/provider/searchplaces.dart';
import 'package:ticket_manager/service/mapService.dart';
import 'package:ticket_manager/service/secccret.dart';
import 'package:ticket_manager/widget/customtextfield.dart';
import 'package:ticket_manager/widget/stickwithball_dotted.dart';

import 'ticketpage.dart';

class RideSharing extends ConsumerStatefulWidget {
  const RideSharing({super.key});

  @override
  ConsumerState<RideSharing> createState() => _RideSharingState();
}

class _RideSharingState extends ConsumerState<RideSharing>
    with TickerProviderStateMixin {
  Future? yourFuture;
  static LatLng initialPosition = const LatLng(23.8760, 90.3138);
  LatLng currentPosition = const LatLng(23.8760, 90.3138);
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  Map<MarkerId, Marker> markers = {};
  Map<MarkerId, Marker> driverandUsermarkers = {};
  Map<PolylineId, Polyline> polylines = {};
  Map<PolylineId, Polyline> driverToUserpolylines = {};
  List<LatLng> polylineCoordinates = [];

  bool polylineCreated = false;
  bool beArider = true;
  bool driverFound = false;

  PolylinePoints polylinePoints = PolylinePoints();

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    driverFound == false
        ? markers[markerId] = marker
        : driverandUsermarkers[markerId] = marker;
    setState(() {});
  }

  _addPolyLine(List<LatLng> polylineCoordinates, Color color) {
    polylineCreated = true;
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 4,
      color: color,
    );

    driverFound == false
        ? polylines[id] = polyline
        : driverToUserpolylines[id] = polyline;
    setState(() {});
  }

  void _driverToUserPolyLine(LatLng driverLoc) async {
    _addMarker(
      LatLng(currentPosition.latitude, currentPosition.longitude),
      "User",
      BitmapDescriptor.defaultMarker,
    );
    _addMarker(
      LatLng(driverLoc.latitude, driverLoc.longitude),
      "Driver",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );
    print("$fromLatLong");
    print("$currentPosition");
    print("$driverLoc");
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapAPIKey,
      PointLatLng(currentPosition.latitude, currentPosition.longitude),
      PointLatLng(driverLoc.latitude, driverLoc.longitude),
      travelMode: TravelMode.driving,
      optimizeWaypoints: true,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates, Colors.red);
  }

  void _getPolyline() async {
    setState(() {
      markers.remove(const MarkerId("current"));
      polylines.clear();
      markers.clear();
    });

    /// add origin marker origin marker
    _addMarker(
      LatLng(fromLatLong.latitude, fromLatLong.longitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    // Add destination marker
    _addMarker(
      LatLng(toLatLong.latitude, toLatLong.longitude),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );

    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapAPIKey,
      PointLatLng(fromLatLong.latitude, fromLatLong.longitude),
      PointLatLng(toLatLong.latitude, toLatLong.longitude),
      travelMode: TravelMode.driving,
      optimizeWaypoints: true,
    );
    GoogleMapController googleMapController = await _controler.future;
    polylineCreated == false
        ? googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 10.5,
                target: LatLng(fromLatLong.latitude, fromLatLong.longitude),
              ),
            ),
          )
        : "";

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates, Colors.green);
    print(markers);
  }

  LatLng fromLatLong = const LatLng(32.08676, 32.08676);
  LatLng toLatLong = const LatLng(32.08676, 32.08676);
  bool isSwap = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  final Completer<GoogleMapController> _controler = Completer();
  bool isOtherTextFieldFilled = false;

  bool hideCont = false;

  int counter = 0;

  //debouncer
  Timer? _debouncer;

  bool heightMaintainer = false;
  bool searchRider = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
    getCurrentLocation();
    setState(() {});
  }

  bool isKeyboardOpen(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return viewInsets.bottom > 0;
  }

  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then(
      (value) {
        currentLocation = value;

        if (kDebugMode) {
          print("Current Location: $currentLocation");
        }
      },
    );
    location.onLocationChanged.listen(
      (event) async {
        currentLocation = event;

        // This ensures that the controller is available before trying to animate the camera.
        if (_controller.isCompleted) {
          GoogleMapController googleMapController = await _controler.future;

          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 40.5,
                target:
                    LatLng(currentPosition.latitude, currentPosition.longitude),
              ),
            ),
          );
        }
        if (mounted) {
          setState(() {
            polylineCreated == false
                ? _addMarker(
                    LatLng(currentPosition.latitude, currentPosition.longitude),
                    "current",
                    BitmapDescriptor.defaultMarkerWithHue(10),
                  )
                : "";
          });
        }
      },
    );
  }

  Future fetchData() async {
    LatLng driverLocation = const LatLng(23.8753, 90.3113);

    await Future.delayed(const Duration(seconds: 10));
    setState(() {
      driverFound = true;
    });
    _driverToUserPolyLine(driverLocation); // Simulate a 2-second delay.
    GoogleMapController googleMapController = await _controler.future;

    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 100.5,
          target: driverLocation,
        ),
      ),
    );
    return driverLocation;
  }

  Future driverDecision() async {
    await Future.delayed(const Duration(seconds: 6));

    return true;
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the AnimationController
    _animation;
    heightMaintainer;
    polylineCoordinates.clear();
    hideCont;
    markers.clear();
    isSwap;
    isOtherTextFieldFilled;
    polylineCreated;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allSearchResult = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(initialPosition.latitude, initialPosition.longitude),
              zoom: 10.5,
            ),
            polylines: driverFound == false
                ? Set<Polyline>.of(polylines.values)
                : Set<Polyline>.of(driverToUserpolylines.values),
            markers: driverFound == false
                ? Set<Marker>.of(markers.values)
                : Set<Marker>.of(driverandUsermarkers.values),
            onMapCreated: (controller) {
              _controler.complete(controller);
            },
          ),
          Positioned(
            top: 0,
            child: hideCont == false
                ? Material(
                    elevation: 30,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: heightMaintainer == true
                          ? MediaQuery.of(context).size.height * 0.7
                          : MediaQuery.of(context).size.height * 0.51,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        color: Colors.white,
                        border: Border.all(style: BorderStyle.none),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Gap(10),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width * 0.84,
                                decoration: BoxDecoration(
                                  border: Border.all(style: BorderStyle.none),
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(222, 227, 241, 255),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const StickWithBall(),
                                    Stack(children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomTextField(
                                            currentLocation: () {
                                              print("Finding your location");
                                              FocusScope.of(context).unfocus();
                                              // searchFlag.toggleSearch();
                                              setState(() {
                                                // hideCont = true;
                                                heightMaintainer = false;
                                                fromLatLong = currentPosition;
                                                gotoSearchedPlace(
                                                    fromLatLong.latitude,
                                                    fromLatLong.longitude,
                                                    15.7);

                                                to.text == "Your Location"
                                                    ? to.clear()
                                                    : from.clear();
                                                from.text = "Your Location";
                                                print(from.text);
                                                print(to.text);
                                                isOtherTextFieldFilled == false
                                                    ? fromLatLong =
                                                        currentPosition
                                                    : toLatLong =
                                                        currentPosition;
                                                from.text.isNotEmpty
                                                    ? isOtherTextFieldFilled =
                                                        true
                                                    : isOtherTextFieldFilled =
                                                        false;
                                              });
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                hideCont = false;
                                                markers.clear();
                                                polylines.clear();
                                                heightMaintainer = true;
                                                isOtherTextFieldFilled = false;
                                              });

                                              if (_debouncer?.isActive ??
                                                  false) {
                                                _debouncer?.cancel();
                                              }

                                              _debouncer = Timer(
                                                const Duration(
                                                    milliseconds: 700),
                                                () async {
                                                  if (value.length > 2) {
                                                    searchFlag.toggleSearch();

                                                    List<AutoCompleteResult>
                                                        searchResults =
                                                        await MapServices()
                                                            .searchplaces(
                                                                value);

                                                    allSearchResult.setResults(
                                                        searchResults);
                                                  } else {
                                                    List<AutoCompleteResult>
                                                        emptyList = [];
                                                    allSearchResult
                                                        .setResults(emptyList);
                                                  }
                                                },
                                              );
                                            },
                                            labelText: "From",
                                            controller: from,
                                          ),
                                          const Gap(10),
                                          IgnorePointer(
                                            ignoring: !isOtherTextFieldFilled,
                                            child: CustomTextField(
                                              currentLocation: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                print("Finding your location");
                                                // searchFlag.toggleSearch();
                                                setState(() {
                                                  // hideCont = true;
                                                  heightMaintainer = false;
                                                  toLatLong = currentPosition;
                                                  gotoSearchedPlace(
                                                      toLatLong.latitude,
                                                      toLatLong.longitude,
                                                      15.7);

                                                  isOtherTextFieldFilled == true
                                                      ? from.clear()
                                                      : to.clear();
                                                  to.text = "Your Location";
                                                  toLatLong = currentPosition;
                                                  from.text.isNotEmpty
                                                      ? isOtherTextFieldFilled =
                                                          true
                                                      : isOtherTextFieldFilled =
                                                          false;
                                                });
                                              },
                                              onChanged: (value) async {
                                                setState(() {
                                                  hideCont = false;
                                                  markers.clear();
                                                  polylines.clear();
                                                  heightMaintainer = true;
                                                  // isOtherTextFieldFilled = false;
                                                });

                                                if (_debouncer?.isActive ??
                                                    false) {
                                                  _debouncer?.cancel();
                                                }

                                                _debouncer = Timer(
                                                  const Duration(
                                                      milliseconds: 700),
                                                  () async {
                                                    if (value.length > 2) {
                                                      searchFlag.toggleSearch();

                                                      List<AutoCompleteResult>
                                                          searchResults =
                                                          await MapServices()
                                                              .searchplaces(
                                                                  value);

                                                      allSearchResult
                                                          .setResults(
                                                              searchResults);
                                                    } else {
                                                      List<AutoCompleteResult>
                                                          emptyList = [];
                                                      allSearchResult
                                                          .setResults(
                                                              emptyList);
                                                    }
                                                  },
                                                );
                                              },
                                              labelText: "To",
                                              controller: to,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.09,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        child: IconButton(
                                          style: const ButtonStyle(
                                            shape: MaterialStatePropertyAll(
                                              CircleBorder(),
                                            ),
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                              Color.fromRGBO(240, 141, 134, 1),
                                            ),
                                          ),
                                          onPressed: () {
                                            print("From LatLng: $fromLatLong");
                                            print("To LatLng: $toLatLong");
                                            setState(() {
                                              LatLng tempp = const LatLng(0, 0);
                                              String temp = "";
                                              temp = from.text;
                                              from.clear();
                                              from.text = to.text;
                                              to.clear();
                                              to.text = temp;
                                              tempp = fromLatLong;
                                              fromLatLong = toLatLong;
                                              toLatLong = tempp;

                                              isSwap = !isSwap;
                                            });
                                            print("From LatLng: $fromLatLong");
                                            print("To LatLng: $toLatLong");

                                            if (isSwap) {
                                              _controller.forward(from: 0);
                                            } else {
                                              _controller.reverse(from: 1);
                                            }
                                          },
                                          icon: RotationTransition(
                                            turns: _animation,
                                            child: Transform.rotate(
                                              angle: 80 * 3.1416 / 190,
                                              child: const Icon(
                                                Icons.compare_arrows,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                                  ],
                                ),
                              ),
                              const Gap(7),
                              searchFlag.searchToggle
                                  ? allSearchResult.allReturns.isNotEmpty
                                      ? Container(
                                          height: 150,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Colors.white.withOpacity(0.9),
                                          ),
                                          child: Stack(
                                            children: [
                                              ListView(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 25,
                                                        horizontal: 3),
                                                children: [
                                                  ...allSearchResult.allReturns
                                                      .map((e) => buildListItem(
                                                          e,
                                                          searchFlag,
                                                          from,
                                                          to,
                                                          isOtherTextFieldFilled,
                                                          allSearchResult
                                                              .allReturns))
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          height: 150,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Colors.white.withOpacity(0.7),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "No Search Results",
                                                  style: TextStyle(
                                                    fontFamily: 'WorkSans',
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: 125.0,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      searchFlag.toggleSearch();
                                                      setState(() {});
                                                      heightMaintainer = false;
                                                    },
                                                    child: const Center(
                                                      child: Text(
                                                        "Close This",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                  : Container(),
                              // : Container(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          color:
                                              Color.fromRGBO(240, 141, 134, 1),
                                        ),
                                        Gap(2),
                                        Text(
                                          "Today",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                          ),
                                        )
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "1 Passenger",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Gap(5),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.8,
                                    MediaQuery.of(context).size.height * 0.06,
                                  ),
                                ),
                                onPressed: () {
                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) {
                                  //       return TicketCounter(
                                  //         arrival_place: to.text,
                                  //         depart_place: from.text,
                                  //       );
                                  //     },
                                  //   ),
                                  // );
                                  _getPolyline();
                                  setState(() {
                                    yourFuture = fetchData();
                                    hideCont = !hideCont;
                                    searchRider = true;
                                  });
                                },
                                child: const Text(
                                  "Search",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const Gap(15),
                              Center(
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      hideCont = !hideCont;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.arrow_upward_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Material(
                    elevation: 30,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.17,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        color: Colors.white,
                        border: Border.all(style: BorderStyle.none),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              hideCont = !hideCont;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Positioned(
            left: 10,
            bottom: heightMaintainer ? -100 : 15,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.3,
                  MediaQuery.of(context).size.height * 0.06,
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Ride Share",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          searchRider == true
              ? Positioned(
                  bottom: 0,
                  child: Material(
                    elevation: 30,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.46,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FutureBuilder(
                          future: yourFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // Display a loading indicator while waiting for the future to complete.
                              return Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Finding your ride",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3,
                                      ),
                                    ),
                                    JumpingDots(
                                      color: Colors.black,
                                      radius: 10,
                                      numberOfDots: 3,
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              // Display an error message if the future encounters an error.
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "FOUND YOUR RIDE",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                  const Gap(20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Material(
                                      elevation: 20,
                                      borderRadius: BorderRadius.circular(30),
                                      child: ListTile(
                                        title: const Text("MD Tangim Haque"),
                                        minLeadingWidth: 40,
                                        subtitle: const Text(
                                            "Student, Department of CSE"),
                                        trailing: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Color.fromARGB(
                                                    255, 241, 103, 23),
                                              ),
                                              Text(
                                                "4.5",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                        leading: const ClipOval(
                                          child: CircleAvatar(
                                            child: Image(
                                              image: NetworkImage(
                                                "https://randomuser.me/api/portraits/men/75.jpg",
                                                scale: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(20),
                                  const Row(
                                    children: [
                                      Text(
                                        "Pricing Starts From: ",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Gap(45),
                                      Text(
                                        "৳ 80",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    ],
                                  ),
                                  const Gap(15),
                                  Row(
                                    children: [
                                      const Text(
                                        "What's your price: ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const Gap(20),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: const TextField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      const Gap(20),
                                      IconButton(
                                        style: IconButton.styleFrom(
                                          elevation: 30,
                                          shape: const CircleBorder(),
                                          backgroundColor: Colors.green,
                                          shadowColor: Colors.black,
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            // driverFound = true;
                                            searchRider = false;
                                          });
                                          GoogleMapController
                                              googleMapController =
                                              await _controler.future;

                                          googleMapController.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                zoom: 400.5,
                                                target: snapshot.data,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  const Gap(20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      minimumSize: Size(
                                        MediaQuery.of(context).size.width * 0.9,
                                        MediaQuery.of(context).size.height *
                                            0.06,
                                      ),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        driverToUserpolylines.clear();
                                        driverandUsermarkers.clear();
                                        polylines.clear();
                                        markers.clear();
                                        from.clear();
                                        to.clear();
                                        driverFound = false;
                                        hideCont = false;
                                        searchRider = false;
                                        _addMarker(
                                          currentPosition,
                                          "CurrentPosition",
                                          BitmapDescriptor.defaultMarker,
                                        );
                                      });
                                      GoogleMapController googleMapController =
                                          await _controler.future;

                                      googleMapController.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            zoom: 100.5,
                                            target: currentPosition,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          searchFlag.searchToggle
              ? allSearchResult.allReturns.isNotEmpty
                  ? Positioned(
                      top: MediaQuery.of(context).size.width * 0.58,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0, right: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: IconButton(
                                onPressed: () {
                                  searchFlag.toggleSearch();
                                  setState(() {});
                                  print(heightMaintainer);
                                  heightMaintainer = false;
                                  print(heightMaintainer);
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container()
              : Container(),
        ],
      ),
    );
  }

  Future<void> gotoSearchedPlace(double lat, double long, num zoom) async {
    if (_controler.isCompleted) {
      GoogleMapController googleMapController = await _controler.future;
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, long), zoom: zoom.toDouble()),
        ),
      );
    }
  }

  Widget buildListItem(placeitem, searchFlag, TextEditingController from,
      TextEditingController to, bool isOtherTextField, List result) {
    return GestureDetector(
      onTapDown: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onTap: () async {
        var place = await MapServices().getPlace(placeitem.placeId);
        gotoSearchedPlace(place['geometry']['location']['lat'],
            place['geometry']['location']['lng'], 15);
        searchFlag.toggleSearch();

        setState(() {
          if (isOtherTextFieldFilled == false) {
            from.clear();
            fromLatLong = LatLng(place['geometry']['location']['lat'],
                place['geometry']['location']['lng']);
            // hideCont = true;
            heightMaintainer = false;
            from.text = placeitem.description.toString();
            isOtherTextFieldFilled = true;
          } else {
            to.clear();
            toLatLong = LatLng(place['geometry']['location']['lat'],
                place['geometry']['location']['lng']);
            heightMaintainer = false;
            hideCont = true;
            to.text = placeitem.description.toString();
          }
        });

        print("From LatLng: $fromLatLong");
        print("To LatLng: $toLatLong");
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_on,
            color: Colors.green,
            size: 24,
          ),
          const SizedBox(
            width: 4.0,
          ),
          SizedBox(
            height: 40,
            width: MediaQuery.of(context).size.width - 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                placeitem.description ?? "",
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
          )
        ],
      ),
    );
  }
}
