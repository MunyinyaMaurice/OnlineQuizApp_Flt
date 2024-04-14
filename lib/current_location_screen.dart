
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(37.4223, -122.0848), zoom: 14);

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User current location"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();

          googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));


          markers.clear();

          markers.add(Marker(markerId: const MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));

          setState(() {});

        },
        label: const Text("Current Location"),
        icon: const Icon(Icons.location_history),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("Location permission requested: $permission");


      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// // import 'package:github/map/consts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:location/location.dart';
//
// import 'consts.dart';
//
// class CurrentLocationScreen extends StatefulWidget {
//   const CurrentLocationScreen({super.key});
//
//   @override
//   State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
// }
//
// class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
//   Location _locationController = new Location();
//
//   final Completer<GoogleMapController> _mapController =
//   Completer<GoogleMapController>();
//
//   static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
//   static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
//   LatLng? _currentP = null;
//
//   Map<PolylineId, Polyline> polylines = {};
//
//   @override
//   void initState() {
//     super.initState();
//     getLocationUpdates().then(
//           (_) => {
//         getPolylinePoints().then((coordinates) => {
//           generatePolyLineFromPoints(coordinates),
//         }),
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Location', // Add this line to set the title
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Theme.of(context).primaryColor,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: _currentP == null
//           ? const Center(
//         child: Text("Loading..."),
//       )
//           : GoogleMap(
//         onMapCreated: ((GoogleMapController controller) =>
//             _mapController.complete(controller)),
//         initialCameraPosition: CameraPosition(
//           target: _pGooglePlex,
//           zoom: 13,
//         ),
//         markers: {
//           Marker(
//             markerId: MarkerId("_currentLocation"),
//             icon: BitmapDescriptor.defaultMarker,
//             position: _currentP!,
//           ),
//           Marker(
//               markerId: MarkerId("_sourceLocation"),
//               icon: BitmapDescriptor.defaultMarker,
//               position: _pGooglePlex),
//           Marker(
//               markerId: MarkerId("_destionationLocation"),
//               icon: BitmapDescriptor.defaultMarker,
//               position: _pApplePark)
//         },
//         polylines: Set<Polyline>.of(polylines.values),
//       ),
//     );
//   }
//
//   Future<void> _cameraToPosition(LatLng pos) async {
//     final GoogleMapController controller = await _mapController.future;
//     CameraPosition _newCameraPosition = CameraPosition(
//       target: pos,
//       zoom: 13,
//     );
//     await controller.animateCamera(
//       CameraUpdate.newCameraPosition(_newCameraPosition),
//     );
//   }
//
//   Future<void> getLocationUpdates() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//
//     _serviceEnabled = await _locationController.serviceEnabled();
//     if (_serviceEnabled) {
//       _serviceEnabled = await _locationController.requestService();
//     } else {
//       return;
//     }
//
//     _permissionGranted = await _locationController.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await _locationController.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     _locationController.onLocationChanged
//         .listen((LocationData currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null) {
//         setState(() {
//           _currentP =
//               LatLng(currentLocation.latitude!, currentLocation.longitude!);
//           _cameraToPosition(_currentP!);
//         });
//       }
//     });
//   }
//
//   Future<List<LatLng>> getPolylinePoints() async {
//     List<LatLng> polylineCoordinates = [];
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       GOOGLE_MAPS_API_KEY,
//       PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
//       PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
//       travelMode: TravelMode.driving,
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     return polylineCoordinates;
//   }
//
//   void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
//     PolylineId id = PolylineId("poly");
//     Polyline polyline = Polyline(
//         polylineId: id,
//         color: Colors.black,
//         points: polylineCoordinates,
//         width: 8);
//     setState(() {
//       polylines[id] = polyline;
//     });
//   }
// }
