import 'dart:async';
import 'package:abatiy/pages/Login.dart';
import 'package:abatiy/payment.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MaterialApp(home: location()));

class location extends StatefulWidget {
  const location({super.key});

  @override
  State<location> createState() => _locationState();
}

class _locationState extends State<location> {
  List<Marker> markers = [];
  LatLng? userPostion;
  Future<Position>? currentlocation;
  Future<Position>? nearestLocation;
  GoogleMapController? controllerMap;
  bool isfound = false;
  CameraPosition currentCamera =
      CameraPosition(target: LatLng(27.181935, 31.186007), zoom: 15);

  List positions = [
    {"lat": 27.198228, "long": 31.173686},
    {"lat": 27.203289, "long": 31.173615},
    {"lat": 27.1840, "long": 31.1819},
  ];

  double? lat;
  double? long;

  //----------------------------Methods-------------------------------------

  void getcurrentlocation() async {
    currentlocation = await Geolocator.getCurrentPosition().then((value) {
      markers.add(Marker(
          markerId: MarkerId('1'),
          position: userPostion = LatLng(value.latitude, value.longitude)));
    });

    userPostion!.latitude != lat;
    controllerMap!.moveCamera(CameraUpdate.newLatLng(userPostion!));
    setState(() {});
  }

  getNearestLocation() async {
    int index = -1;
    double minDistance = double.infinity;
    for (int i = 0; i < positions.length; i++) {
      if (Geolocator.distanceBetween(
              userPostion!.latitude,
              userPostion!.longitude,
              positions[i]['lat'],
              positions[i]['long']) <
          minDistance) {
        minDistance = Geolocator.distanceBetween(userPostion!.latitude,
            userPostion!.longitude, positions[i]['lat'], positions[i]['long']);
        index = i;
        print(index);
      }
    }

    nearestLocation = await Geolocator.getCurrentPosition().then((value) {
      markers.add(Marker(
          markerId: MarkerId('2'),
          position: userPostion =
              LatLng(positions[index]['lat'], positions[index]['long'])));
    });
    controllerMap!.animateCamera(CameraUpdate.newLatLng(
        LatLng(positions[index]['lat'], positions[index]['long'])));
    isfound = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //--------------------Page Content---------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.orangeAccent),
        body: Container(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GoogleMap(
                onTap: (LatLng latlang) {
                  markers.clear();
                  markers.add(Marker(
                      icon: BitmapDescriptor.defaultMarker,
                      markerId: MarkerId("1"),
                      position: userPostion =
                          LatLng(latlang.latitude, latlang.longitude)));
                  // getNearestLocation();
                  isfound=false;
                  setState(() {});
                },
                mapType: MapType.normal,
                markers: markers.toSet(),
                initialCameraPosition: currentCamera,
                onMapCreated: (GoogleMapController hello) {
                  controllerMap = hello;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 15,
                ),
                child: isfound
                    ? MaterialButton(
                  shape: CircleBorder(),
                        height: 50,
                        color: Colors.green,
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => resrveDone(),));
                        },
                        child: Icon(Icons.done,size: 30,)
                      )
                    : MaterialButton(
                        height: 40,
                        color: Colors.orangeAccent,
                        onPressed: () {
                          getNearestLocation();
                        },
                        child: Text(
                          'Find Nearest',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
              ),
              Positioned(
                  right: 6,
                  bottom: 110,
                  child: FloatingActionButton(
                    backgroundColor: Colors.orangeAccent,
                    onPressed: () async {
                      getcurrentlocation();
                    },
                    child: Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                  ))
            ],
          ),
        ));
  }
}


class resrveDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/image/ontheway.png'),
            Text('Help is on the way to you ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
  
}