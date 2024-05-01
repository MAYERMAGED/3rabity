import 'package:abatiy/Classes/Favorites.dart';
import 'package:abatiy/Classes/Product.dart';
import 'package:abatiy/Classes/orders.dart';
import 'package:abatiy/pages/Store2.dart';
import 'package:flutter/material.dart';
import '../customes/buildCart.dart';
import 'package:abatiy/Classes/User.dart';

// void main() => runApp(MaterialApp(
//       home: Profile(),
//     ));

class Profile extends StatefulWidget {
  const Profile({super.key});

  State<Profile> createState() => _MyAppState();
}

class _MyAppState extends State<Profile> with SingleTickerProviderStateMixin {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  bool isReadonly = true;
  static late TabController tabcontroller;

//----------------------Methods--------------------------------------------------------------------------

  @override
  void initState() {
    tabcontroller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: FutureBuilder<CurrentUser>(
        future: CurrentUser().getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else {
            if (snapshot == null) {
              return Center(
                child: Text('No Availabel Data'),
              );
            }
            CurrentUser _userData = snapshot.data!;
            _name.text = _userData.name!;
            _email.text = _userData.email!;
            _phone.text = _userData.phone!;
            _address.text = _userData.address!;

            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                            right: 108,
                          ),
                          child: Image.asset(
                            'assets/image/logo.png',
                            height: 30,
                          )),

                      shoppingCart(),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(20)),
                            margin:
                                EdgeInsets.only(top: 60, left: 10, right: 10),
                            height: 200,
                          ),
                        ),
                        Positioned(
                          top: -40,
                          left: 55,
                          child: Container(
                            width: 300,
                            height: 200,
                            child: Image.asset('assets/image/5.png',
                                fit: BoxFit.fitWidth),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 65),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${_userData.Car}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text(
                                '${_userData.carType}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        TabBar(
                            controller: tabcontroller,
                            indicator: BoxDecoration(),
                            unselectedLabelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            labelColor: Colors.black,
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                            tabs: [
                              Tab(
                                child: const Text('Profile'),
                              ),
                              Tab(
                                child: const Text('Whishlist'),
                              ),
                              Tab(
                                child: const Text('Orders'),
                              )
                            ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 400,
                    child: TabBarView(
                        controller: tabcontroller, children: [
                      ListView(
                        children: [
                          //---------------------------Start of Profile Tab-----------------------------------------------

                          profileTabs(
                            controller: _name,
                            suffixIcon: Icons.person,
                          ),
                          profileTabs(
                            controller: _email,
                            suffixIcon: Icons.email,
                          ),
                          profileTabs(
                            controller: _phone,
                            suffixIcon: Icons.phone,
                          ),
                          profileTabs(
                            controller: _address,
                            suffixIcon: Icons.home,
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  color: Colors.orangeAccent,
                                  onPressed: () {
                                    // updateUserData();
                                    CurrentUser().updateUserData(
                                        _name.text,
                                        _email.text,
                                        _phone.text,
                                        _address.text);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                            content:
                                                Text('Updated Successfully')));
                                  },
                                  child: Text('Save')))
                        ],
                      ),

                      //---------------------------------Start of Car Tab--------------------------------------------
                      FutureBuilder<List<Product>>(
                        future: Favorites().getUserFavorites(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          if (snapshot.hasError)
                            return Text('Error is : ${snapshot.error}');
                          else {
                            List<Product>? _favproducts = snapshot.data;
                            if (snapshot.data == null ||
                                snapshot.data!.isEmpty) {
                              return Column(
                                children: [
                                  Image.asset('assets/image/fav.png'),
                                  Text('No Items added to yor Favourites')
                                ],
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: _favproducts!.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  background: Container(
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    color: Colors.red,
                                    child: Icon(Icons.delete),
                                  ),
                                  key: Key(_favproducts[index].productcode!),
                                  onDismissed: (direction) {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      Favorites().deleteFavorites(
                                          _favproducts[index].productcode!);
                                      setState(() {});
                                    }
                                  },
                                  child: ListTile(
                                    contentPadding: EdgeInsets.only(
                                        bottom: 20, left: 10, right: 20),
                                    isThreeLine: true,
                                    minVerticalPadding: 20,
                                    leading: Image.network(
                                        "${_favproducts[index].url}"),
                                    title: Text("${_favproducts[index].title}"),
                                    subtitle:
                                        Text('${_favproducts[index].subtitle}'),
                                    trailing: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                          'price : ${_favproducts[index].price}'),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                      // ------------------------------Start of Orders Tab-------------------------------------------------
                      FutureBuilder<List<orders>>(
                        future: orders().getUserOrders(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          else if (snapshot.hasError)
                            return Center(
                              child: Text('Error ${snapshot.error}'),
                            );
                          else {
                            List<orders>? _userOrders = snapshot.data;
                            //------------------if Empty------------------------
                            if (_userOrders == null || _userOrders.isEmpty) {
                              return Column(
                                children: [
                                  Image.asset(
                                    'assets/image/empty.png',
                                    height: 250,
                                  ),
                                  Text(
                                    'No Orders?',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                       Navigator.of(context).pushNamed('Store');
                                      },
                                      child: Text(
                                        'Order Now',
                                        style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ))
                                ],
                              );
                            }
                            //---------------if Not empty-----------------------------
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: _userOrders.length,
                              itemBuilder: (context, index) {
                                orders _currentOrder = _userOrders[index];
                                List<Product> _allOrderProducts =
                                    _currentOrder.products!;
                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black, width: 1))),
                                  child: Column(
                                    children: [
                                      Text(
                                          'Order Number ${_currentOrder.ordernumber}'),
                                      ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: _allOrderProducts.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            contentPadding: EdgeInsets.only(
                                                bottom: 20,
                                                left: 10,
                                                right: 20),
                                            isThreeLine: true,
                                            minVerticalPadding: 20,
                                            leading: Image.network(
                                                "${_allOrderProducts[index].url}"),
                                            title: Text(
                                                "${_allOrderProducts[index].title}"),
                                            subtitle: Text(
                                                '${_allOrderProducts[index].subtitle}'),
                                            trailing: Text(
                                                'Quantity : ${_allOrderProducts[index].quantity}'),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      )
                      //----------------------------End of Orders Tab-------------------------------------------------------------
                    ]),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

// class CustomButton extends StatelessWidget {
//   final String name;
//   final Icon icon;
//
//   const CustomButton({super.key, required this.icon, required this.name});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.orangeAccent,
//           borderRadius: BorderRadius.circular(5),
//           border: Border.symmetric(
//               horizontal: BorderSide(width: 2, color: Colors.black))),
//       child: ListTile(
//         title: Text(name),
//         leading: Icon(Icons.help),
//         // tileColor: Colors.orangeAccent,
//         contentPadding: EdgeInsets.all(10),
//       ),
//     );
//     throw UnimplementedError();
//   }
// }

class profileTabs extends StatefulWidget {
  final TextEditingController? controller;
  final IconData? suffixIcon;

  const profileTabs({super.key, required this.controller, this.suffixIcon});

  @override
  State<profileTabs> createState() => _profileTabsState();
}

class _profileTabsState extends State<profileTabs> {
  bool isReadonly = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: isReadonly,
      controller: widget.controller,
      decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide(width: 0.7)),
          contentPadding: EdgeInsets.symmetric(vertical: 20),
          prefixIcon: Icon(widget.suffixIcon),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    isReadonly = !isReadonly;
                  });
                },
                icon: Icon(isReadonly
                    ? Icons.lock_outline
                    : Icons.lock_open_outlined)),
          )),
    );
    throw UnimplementedError();
  }
}
