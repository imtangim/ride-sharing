import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const LatLng dest_location = LatLng(37.42796133580664, -122.085749655962);

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  late GoogleMapController mapController;

  LatLng currentPosition = const LatLng(37.42796133580664, -122.085749655962);
  // Markers to show points on the map
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();

  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

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
          GoogleMapController googleMapController = await _controller.future;
          _addMarker(
            LatLng(currentPosition.latitude, currentPosition.longitude),
            "current",
            BitmapDescriptor.defaultMarkerWithHue(10),
          );

          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 15.5,
                target: LatLng(event.latitude!, event.longitude!),
              ),
            ),
          );
        }

        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = _kGooglePlex;
    if (currentPosition != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 14.4746);
    }
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          padding: const EdgeInsets.only(top: 135),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;
            _getPolyline();
          },
          polylines: Set<Polyline>.of(polylines.values),
          markers: Set<Marker>.of(markers.values),
        ),
      ),
    );
  }

  // This method will add markers to the map based on the LatLng position
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    /// add origin marker origin marker
    _addMarker(
      LatLng(currentPosition.latitude, currentPosition.longitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    // Add destination marker
    _addMarker(
      LatLng(dest_location.latitude, dest_location.longitude),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );

    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "API KEY",
      PointLatLng(currentPosition.latitude, currentPosition.longitude),
      PointLatLng(dest_location.latitude, dest_location.longitude),
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }
}
