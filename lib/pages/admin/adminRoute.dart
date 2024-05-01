import 'package:abatiy/pages/Chat.dart';
import 'package:abatiy/pages/Profile.dart';
import 'package:abatiy/pages/aboutUs.dart';
import 'package:abatiy/pages/admin/adminHomepage.dart';
import 'package:abatiy/pages/admin/requestAdminPanel.dart';
import 'package:abatiy/pages/admin/usersPanel.dart';
import 'package:abatiy/pages/map.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import '../Login.dart';
import '../maintenance.dart';
import '../toLocation.dart';
import '../user/services.dart';
import 'adminstore.dart';


class adminRoute extends StatefulWidget {
  @override
  State<adminRoute> createState() => _adminRouteState();
}

Widget? _child;

class _adminRouteState extends State<adminRoute> {
  @override
  void initState() {
    _child = adminHomepage();
    super.initState();
  }

  void handleNavigation(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = Profile();
          break;
        case 1:
          _child = adminHomepage();
          break;
        case 2:
          _child = suppChat();

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
        "Requests" :(context)=> requestPanel(),
        "UserPanel": (context)=> usersPanel(),
        "Login": (context) => arabity(),
        "Maintenance": (context) => maintenance(),
        "Wrench":(context)=>wrenchpage(),
        "Store":(context) => adminStore(),
        "Services" : (context)=> servicesPage(),
        "Aboutus" :(context) => aboutUs(),
        // testing
        "test" :(context)=> location(),
        "chat": (context)=>suppChat(),
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
              FluidNavBarIcon(icon: Icons.support_agent)
            ]),
        body: _child,
      ),
    );
    throw UnimplementedError();
  }
}
