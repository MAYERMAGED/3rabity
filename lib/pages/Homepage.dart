import 'package:abatiy/Classes/User.dart';
import 'package:abatiy/pages/aboutUs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Classes/request.dart';
import '../customes/HomepageButton.dart';


class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _myapp();
}

Widget? child = Homepage();
GoogleSignIn googlesignin = GoogleSignIn();

class _myapp extends State<Homepage> {
  String? imgUrl;
  bool isUploaded = false;

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
                  await FirebaseAuth.instance.signOut();
                  CurrentUser().clearCachedUser();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("Login", (route) => false);
                },
                icon: Icon(
                  Icons.output,
                  color: Colors.black,
                  size: 30,
                ))
          ],
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30),
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
                    icon: Icons.store, servicename: 'Store', pagename: 'Store'),
                HomepageIcons(
                    icon: Icons.car_repair_rounded,
                    servicename: 'Services',
                    pagename: 'Services'),
                HomepageIcons(
                    icon: Icons.location_on,
                    servicename: 'To Location ',
                    pagename: 'Wrench'),
                aboutUs(),
              ],
            ),
            MaterialButton(
              color: Colors.grey[300],
              elevation: 10,
              shape: RoundedRectangleBorder(),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Request'),
                        content: Container(
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Add photo',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                MaterialButton(
                                  onPressed: imgUrl != null
                                      ? () {
                                          // Handle button click when image is loaded
                                        }
                                      : null,
                                  child: FutureBuilder<String>(
                                    future: serviceRequest().getImage(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator(); // Show loading indicator while waiting for the image
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Error loading image'); // Show an error message if image loading fails
                                      } else {
                                        imgUrl = snapshot.data;
                                        isUploaded = imgUrl != null;
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          height: 90,
                                          width: 150,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image:
                                                      NetworkImage('${imgUrl}'),
                                                  fit: BoxFit.contain)),
                                        );
                                      }
                                    },
                                  ),
                                )
                              ],
                            )),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                if (imgUrl != null) {
                                  Navigator.of(context).pop();
                                  serviceRequest().addRequest(imgUrl!);
                                }
                              },
                              child: Text('Send')),
                        ],
                      );
                    });
              },
              child: Text(
                'Join Our System Now',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ));
    throw UnimplementedError();
  }
}
