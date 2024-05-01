import 'package:abatiy/pages/Profile.dart';
import 'package:abatiy/pages/Service%20Provider/providerHomepage.dart';
import 'package:abatiy/pages/Service%20Provider/providerOrders.dart';
import 'package:abatiy/pages/Service%20Provider/providerProducts.dart';
import 'package:abatiy/pages/admin/adminHomepage.dart';
import 'package:abatiy/pages/map.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../Login.dart';
import '../Store2.dart';
import 'providerReservation.dart';
import '../admin/requestAdminPanel.dart';
import '../admin/usersPanel.dart';
import '../maintenance.dart';
import '../toLocation.dart';


class providerRoute extends StatefulWidget {
  @override
  State<providerRoute> createState() => _providerRouteState();
}

Widget? _child;

class _providerRouteState extends State<providerRoute> {
  @override
  void initState() {
    _child = providerHome();
    super.initState();
  }

  void handleNavigation(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = Profile();
          break;
        case 1:
          _child = providerHome();
          break;

      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        //main   (All Main capital Letters in first )
        "Login": (context) => arabity(),
        "Store": (context) => providerProducts(),
        "Wrench":(context)=>wrenchpage(),
        "Reservations" :(context)=> providerReservation(),
        "Orders" : (context)=> providerOrders(),
        // "Orders": (context)=>providerOrders(),

        // testing
        "test" :(context)=> location(),
      },
      home: Scaffold(
        extendBody: true,
        bottomNavigationBar: FluidNavBar(
            onChange: handleNavigation,
            style: FluidNavBarStyle(
                iconUnselectedForegroundColor: Colors.grey[200],
                barBackgroundColor: Colors.orangeAccent),
            defaultIndex: 1,
            // onChange:handleNavigation,
            icons: [
              FluidNavBarIcon(icon: Icons.person),
              FluidNavBarIcon(icon: Icons.home),
            ]),
        body: _child,
      ),
    );
    throw UnimplementedError();
  }
}
