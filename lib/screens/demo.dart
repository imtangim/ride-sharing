// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ticket_manager/service/secccret.dart';

class DemoMap extends StatefulWidget {
  const DemoMap({super.key});

  @override
  State<DemoMap> createState() => _DemoMapState();
}

class _DemoMapState extends State<DemoMap> {
  final Completer<GoogleMapController> _controler = Completer();
  List<LatLng> polylineCordinate = [];

  static const LatLng sourceLocation = LatLng(23.8760, 90.3138);
  static const LatLng destination = LatLng(23.8759, 90.3299);

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

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
        if (_controler.isCompleted) {
          GoogleMapController googleMapController = await _controler.future;
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

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapAPIKey,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
      optimizeWaypoints: true,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCordinate.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  void setCustomMarketIcon() async {
    // Load the custom marker icons
    final sourceIconBytes = await _loadAssetBytes("assets/Pin_source.png");
    final destinationIconBytes =
        await _loadAssetBytes("assets/Pin_destination.png");
    final currentLocationIconBytes =
        await _loadAssetBytes("assets/Pin_current_location.png");

    // Resize the icons to your desired size (e.g., 48x48)
    final iconSize = Size(60, 60);
    final iconSize2 = Size(100, 100);
    final resizedSourceIcon =
        await _resizeBitmapDescriptor(sourceIconBytes, iconSize);
    final resizedDestinationIcon =
        await _resizeBitmapDescriptor(destinationIconBytes, iconSize);
    final resizedCurrentLocationIcon =
        await _resizeBitmapDescriptor(currentLocationIconBytes, iconSize2);

    // Now you can use the resized icons
    sourceIcon = resizedSourceIcon;
    destinationIcon = resizedDestinationIcon;
    currentLocationIcon = resizedCurrentLocationIcon;
  }

  Future<Uint8List> _loadAssetBytes(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Future<BitmapDescriptor> _resizeBitmapDescriptor(
      Uint8List originalBytes, Size newSize) async {
    final Completer<BitmapDescriptor> completer = Completer();

    final ui.Codec codec = await ui.instantiateImageCodec(
      originalBytes,
      targetHeight: newSize.height.toInt(),
      targetWidth: newSize.width.toInt(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    final ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception("Unable to resize the BitmapDescriptor");
    }

    final Uint8List resizedBytes = byteData.buffer.asUint8List();
    final BitmapDescriptor resizedBitmapDescriptor =
        BitmapDescriptor.fromBytes(resizedBytes);

    completer.complete(resizedBitmapDescriptor);
    return completer.future;
  }

  @override
  void initState() {
    setCustomMarketIcon();
    getPolyPoints();
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentLocation!.latitude!,
                  currentLocation!.longitude!,
                ),
                zoom: 15.5,
              ),
             markers: {
                Marker(
                    icon: sourceIcon,
                    markerId: const MarkerId("source"),
                    position: sourceLocation),
                Marker(
                    icon: destinationIcon,
                    markerId: const MarkerId("destination"),
                    position: destination),
                Marker(
                  icon: currentLocationIcon,
                  markerId: const MarkerId("currentLocation"),
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCordinate,
                  color: Colors.blue,
                  width: 5,
                  onTap: () {},
                ),
              },
              onMapCreated: (controller) {
                _controler.complete(controller);
              },
            ),
    );
  }
}
