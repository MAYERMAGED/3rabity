import 'package:flutter/material.dart';

class HomepageIcons extends StatelessWidget {
  final IconData icon;
  final String servicename;
  final String pagename;
  final Function()? onTap;

  const HomepageIcons(
      {super.key,
      this.onTap,
      required this.icon,
      required this.servicename,
      required this.pagename});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
        Navigator.of(context).pushNamed("$pagename");
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center ,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.black,
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 4)),
              Text(
                '$servicename',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          )),
    );
  }
}
