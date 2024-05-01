import 'package:abatiy/pages/Homepage.dart';
import 'package:abatiy/pages/Profile.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class CustomeNavBar extends StatefulWidget {
  @override
  State<CustomeNavBar> createState() => _CustomeNavBarState();
}

Widget? _child;

class _CustomeNavBarState extends State<CustomeNavBar> {
  void handleNavigation(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = Profile();
        case 1:
          _child = Homepage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FluidNavBar(
        style: FluidNavBarStyle(
            iconUnselectedForegroundColor: Colors.grey[200],
            barBackgroundColor: Colors.orangeAccent),
        // defaultIndex: 1,
        onChange:handleNavigation,
        icons: [
          FluidNavBarIcon(icon: Icons.person),
          FluidNavBarIcon(icon: Icons.home),
        ]

    );
    throw UnimplementedError();
  }
}
