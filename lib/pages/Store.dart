import 'dart:io';

import 'package:abatiy/pages/Profile.dart';
import 'package:abatiy/pages/Store2.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: Store()));

class Store extends StatefulWidget {
  const Store({super.key});

  State<Store> createState() => _MyAppState();
}

final List test = [
  {"img": "assets/image/1.png", "name": "Car number 1"},
  {"img": "assets/image/2.png", "name": "Car number 2"},
  {"img": "assets/image/3.png", "name": "Car number 3"},
  {"img": "assets/image/4.png", "name": "Car number 4"},
  {"img": "assets/image/4.png", "name": "Car number 4"},
  {"img": "assets/image/5.png", "name": "Car number 5"},
  {"img": "assets/image/6.png", "name": "Car number 6"},
  {"img": "assets/image/1.png", "name": "Car number 6"},
  {"img": "assets/image/4.png", "name": "Car number 7"},
  {"img": "assets/image/5.png", "name": "Car number 7"},
  {"img": "assets/image/1.png", "name": "Car number 8"},
  {"img": "assets/image/3.png", "name": "Car number 8"},
];
GlobalKey<ScaffoldState> scaffoldstate = GlobalKey();
TextEditingController user = TextEditingController();
TextEditingController pass = TextEditingController();
GlobalKey<FormState> formstate = GlobalKey();
bool isDark = false;
Color modecolor = Colors.transparent;
Color isPressed = Colors.black;
int navindex = 0!;

class _MyAppState extends State<Store> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: scaffoldstate,
        appBar: AppBar(
          title: Text('Store'),
          bottom: TabBar(
              indicatorColor: Colors.black,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              unselectedLabelStyle:
                  TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              tabs: [
                Tab(
                  text: 'Cars',
                  icon: Icon(Icons.store),
                ),
                Tab(
                  text: 'Motorcycle',
                  icon: Icon(Icons.motorcycle_rounded),
                ),
                Tab(
                  text: 'Planes',
                  icon: Icon(Icons.airplanemode_active),
                ),
              ]),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.only(top: 40, left: 10),
            children: [
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Profile()));
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/image/me.png',
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Mohamed Alaa'),
                      subtitle: Text(
                        'mohamedelkarn2003@gmail.com',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              CustomeListtile(name: 'Home', icon: Icon(Icons.home)),
              CustomeListtile(name: 'Settings', icon: Icon(Icons.settings)),
              CustomeListtile(name: 'Call Us', icon: Icon(Icons.call)),
              CustomeListtile(name: 'Help', icon: Icon(Icons.help)),
              CustomeListtile(name: 'Help', icon: Icon(Icons.help)),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              setState(() {
                navindex = value;
                if(navindex==2){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Store2(),));
                }
              });
            },
            selectedItemColor: Colors.blueAccent,
            currentIndex: navindex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.storefront), label: 'Store')
            ]),
        body: Container(
            padding: EdgeInsets.all(10),
            child: TabBarView(
              children: [
                GridView.builder(
                    itemCount: test.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 8),
                    itemBuilder: (context, i) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.black),
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 150,
                              child: Image.asset(
                                test[i]['img'],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                test[i]['name'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            MaterialButton(
                              color: Colors.blueAccent,
                              onPressed: () {},
                              child: Text('View'),
                            )
                          ],
                        ),
                      );
                    }),
                GridView.builder(
                    itemCount: test.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 8),
                    itemBuilder: (context, i) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(width: 3, color: Colors.black),
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 150,
                              child: Image.asset(
                                test[i]['img'],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                test[i]['name'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            MaterialButton(
                              color: Colors.blueAccent,
                              onPressed: () {},
                              child: Text('View'),
                            )
                          ],
                        ),
                      );
                    }),
                GridView.builder(
                    itemCount: test.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 8),
                    itemBuilder: (context,counter) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            border: Border.all(width: 3, color: Colors.black),
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 150,
                              child: Image.asset(
                                test[counter]['img'],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                test[counter]['name'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            MaterialButton(
                              color: Colors.blueAccent,
                              onPressed: () {},
                              child: Text('View'),
                            )
                          ],
                        ),
                      );
                    }),
              ],
            )),
      ),
    );
    throw UnimplementedError();
  }
}

class Secondpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class CustomeListtile extends StatelessWidget {
  const CustomeListtile({super.key, required this.name, required this.icon});

  final Icon icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        '$name',
        style: TextStyle(fontSize: 20),
      ),
    );
    throw UnimplementedError();
  }
}
