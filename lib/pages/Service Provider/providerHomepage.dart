import 'package:abatiy/Classes/User.dart';
import 'package:abatiy/pages/aboutUs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../customes/HomepageButton.dart';

void main() => runApp(MaterialApp(home: providerHome()));

class providerHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _myapp();
}

class _myapp extends State<providerHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Image.asset('assets/image/logo.png', width: 200),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  GoogleSignIn googlesignin = GoogleSignIn();
                  googlesignin.disconnect();
                  CurrentUser().clearCachedUser();

                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("Login", (route) => false);
                },
                icon: Icon(
                  Icons.output,
                  color: Colors.black,
                  size: 30,
                )),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(30),
          children: [
            ImageSlideshow(autoPlayInterval: 3000, isLoop: true, children: [
              Image.asset(
                'assets/image/1.png',
              ),
              Image.asset('assets/image/2.png'),
              Image.asset('assets/image/3.png'),
              Image.asset('assets/image/4.png')
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                'Services :',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            GridView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 130,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              children: [
                HomepageIcons(
                  icon: Icons.content_paste,
                  servicename: 'View Reservation',
                  pagename: 'Reservations',
                ),
                HomepageIcons(
                    icon: Icons.my_library_add,
                    servicename: 'View orders ',
                    pagename: 'Orders'),
                HomepageIcons(
                    icon: Icons.store,
                    servicename: 'My Products',
                    pagename: 'Store'),
                aboutUs()
              ],
            ),
          ],
        ));
    throw UnimplementedError();
  }
}
