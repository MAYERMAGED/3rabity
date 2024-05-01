import 'package:abatiy/customes/bottomnavbar.dart';
import 'package:abatiy/pages/Homepage.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../customes/HomepageButton.dart';

void main() => runApp(MaterialApp(
      home: wrenchpage(),
    ));

class wrenchpage extends StatefulWidget {
  @override
  State<wrenchpage> createState() => _wrenchpageState();
}

class _wrenchpageState extends State<wrenchpage> {
  void isLocationenabled() async {
    bool service;
    service = await Geolocator.isLocationServiceEnabled();
    if (!service) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Can\'t continue without permission'),
              actions: [
                TextButton(
                    onPressed: () async {
                      Geolocator.openLocationSettings();
                      service = await Geolocator.isLocationServiceEnabled();
                      Navigator.of(context).pop();
                    },
                    child: Text('Allow')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel')),
              ],
            );
          });
    }
  }

  void getpermission() async {
    LocationPermission premission;
    premission = await Geolocator.requestPermission();
    if (premission == LocationPermission.denied) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please open the Location'),
              actions: [
                TextButton(
                    onPressed: () async {
                      premission = await Geolocator.requestPermission();
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok')),
                TextButton(
                    onPressed: () {
                      Geolocator.openLocationSettings();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel')),
              ],
            );
          });
    } else if (premission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Can\'t continue without permission'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void initState() {
    getpermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'To Location Services',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 100),
          child: ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              HomepageIcons(
                onTap: isLocationenabled,
                  icon: Icons.local_gas_station,
                  servicename: 'Order Gas',
                  pagename: 'test'),
              SizedBox(
                height: 20,
              ),
              HomepageIcons(
                onTap: isLocationenabled,
                  icon: Icons.tire_repair_rounded,
                  servicename: 'Mechanic',
                  pagename: 'test'),
              SizedBox(
                height: 20,
              ),
              HomepageIcons(
                onTap: isLocationenabled,
                  icon: Icons.fire_truck_sharp,
                  servicename: 'Wrench',
                  pagename: 'test'),


            ],
          ),
        ));
    throw UnimplementedError();
  }
}
