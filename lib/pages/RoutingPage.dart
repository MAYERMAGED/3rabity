
import 'package:abatiy/pages/map.dart';
import 'package:abatiy/pages/user/services.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'Homepage.dart';
import 'Login.dart';
import 'Profile.dart';
import 'Sign up.dart';
import 'Store2.dart';
import 'toLocation.dart';
import 'maintenance.dart';


class userRouting extends StatefulWidget {
  @override
  State<userRouting> createState() => _userRoutingState();
}

Widget? _child;

class _userRoutingState extends State<userRouting> {
  @override
  void initState() {
    _child = Homepage();
    super.initState();
  }

  void handleNavigation(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = Profile();
          break;
        case 1:
          _child = Homepage();
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
        "Signup": (context) => Signup(),
        "Homepage": (context) => Homepage(),
        "Maintenance": (context) => maintenance(),
        "Store": (context) => Store2(),
        "Wrench":(context)=>wrenchpage(),
        "Services": (context)=>servicesPage(),
        "hello":  (context) => Homepage(),
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
