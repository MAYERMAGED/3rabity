// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class Location {
//   StreamSubscription<Position>? userposition;
//   StreamSubscription<Position>? nearestposition;
//   GoogleMapController? controllerMap;
//   LatLng? loc;
//
//   void getcurrentlocation() async {
//     userposition = Geolocator.getPositionStream().listen((Position? pos) {
//       markers.add(Marker(
//           markerId: MarkerId('1'),
//           position: loc = LatLng(pos!.latitude, pos.longitude)));
//       controllerMap!.moveCamera(
//           CameraUpdate.newLatLng(LatLng(pos.latitude, pos.longitude)));
//     });
//   }
//
//   getNearestLocation(List<Map<String,double>>positions) async {
//     int index = -1;
//     double minDistance = double.infinity;
//     for (int i = 0; i < positions.length; i++) {
//       if (Geolocator.distanceBetween(loc!.latitude, loc!.longitude,
//               positions[i]['lat']!, positions[i]['long']!) <
//           minDistance) {
//         minDistance = Geolocator.distanceBetween(loc!.latitude, loc!.longitude,
//             positions[i]['lat']!, positions[i]['long']!);
//         index = i;
//         print(index);
//       }
//     }
//     nearestposition = Geolocator.getPositionStream().listen((Position? pos) {
//       markers.add(Marker(
//           markerId: MarkerId('2'),
//           position: loc =
//               LatLng(positions[index]['lat']!, positions[index]['long']!)));
//       controllerMap!.animateCamera(CameraUpdate.newLatLng(
//           LatLng(positions[index]['lat']!, positions[index]['long']!)));
//     });
//   }
//
//   isLocationenabled() async {
//     bool service;
//     service = await Geolocator.isLocationServiceEnabled();
//     if (!service) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Error'),
//               content: Text('Please open the Location'),
//               actions: [
//                 TextButton(
//                     onPressed: () async {
//                       Geolocator.openLocationSettings();
//                       service = await Geolocator.isLocationServiceEnabled();
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('Ok')),
//                 TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('Cancel')),
//               ],
//             );
//           });
//     }
//   }
//
//   getpermission() async {
//     LocationPermission premission;
//     premission = await Geolocator.requestPermission();
//     if (premission == LocationPermission.denied) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Error'),
//               content: Text('Please open the Location'),
//               actions: [
//                 TextButton(
//                     onPressed: () async {
//                       premission = await Geolocator.requestPermission();
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('Ok')),
//                 TextButton(
//                     onPressed: () {
//                       Geolocator.openLocationSettings();
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('Cancel')),
//               ],
//             );
//           });
//     }
//   }
// }
