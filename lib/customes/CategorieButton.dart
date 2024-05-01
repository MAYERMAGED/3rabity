import 'package:flutter/material.dart';

import '../pages/categorie.dart';

class CustomeCategorie extends StatelessWidget {
  final IconData categorieicon;
  final String txt;

  // final Function(String) onTap;

  const CustomeCategorie(
      {super.key, required this.categorieicon, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CategoriePage(cat: txt),
              ));
            },
            icon: Icon(
              categorieicon,
              color: Colors.black,
            ),
          ),
          height: 80,
          width: 80,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            width: 90,
            child: Text(textAlign: TextAlign.center,
              softWrap: true,
              '$txt',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
