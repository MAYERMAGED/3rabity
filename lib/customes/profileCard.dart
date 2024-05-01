import 'package:flutter/material.dart';

class profileCard extends StatelessWidget {
  // late TabController _controller;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Card(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.red[200],
                borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.only(top: 50),
            height: 200,
          ),
        ),
        Positioned(
          top: -40,
          left: 45,
          child: Container(
            width: 300,
            height: 200,
            child: Image.asset('assets/image/5.png', fit: BoxFit.fitWidth),
          ),
        ),
        Container(
          child: Column(
            children: [
              Text(
                'Skoda Kodiak',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                'Suv',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: TabBar(
                  // controller: TabController(length: length, vsync: vsync),
                    indicator: BoxDecoration(),
                    unselectedLabelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                    labelColor: Colors.black,
                    labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    tabs: [
                      Tab(
                        child: Text('Hello'),
                      ),
                      Tab(
                        child: Text('Fk'),
                      ),
                      Tab(
                        child: Text('Quit'),
                      )
                    ]),
              )
            ],
          ),
        ),
      ],
    );
    throw UnimplementedError();
  }
}