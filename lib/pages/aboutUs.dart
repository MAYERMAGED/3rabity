import 'package:flutter/material.dart';

class aboutUs extends StatelessWidget {
  const aboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showAboutDialog(
            context: context,
            applicationIcon: Container(
                padding: EdgeInsets.only(top: 20),
                child: Image.asset(
                  'assets/image/logo.png',
                  width: 100,
                )),
            applicationName: 'About us',
            applicationVersion: '0.0.1',
            applicationLegalese: 'Developer by Arabity Team ',
            children: <Widget>[
              Text(
                  'Users can make reservations for various car services such as cleaning,oil change, upgrading, or Tire change. The app provides a convenient way to book these services based on availability, allowing users to secure their desired service.'),
              Text(
                  'The app allows user to browse online for accessories for their cars and allowing them to search for the products they desire also the app offers a service for sellers to sell their products online and offer services using our  for a small commission'),
              Text('The app offers to location services to enable users to use our services under any circumstances and to help users any where anytime they needed help'),
              Text(
                  'Overall, The app focuses on enhancing car owner\'s experience buy enabling them to reach anything related to their car online and easy and enable service owner\'s to offer their services for all the users.'),
            ]);
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 40,
                color: Colors.black,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 4)),
              Text(
                'about us',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          )),
    );
  }
}
