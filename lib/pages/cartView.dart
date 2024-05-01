import 'package:abatiy/Classes/ShoppingCart.dart';
import 'package:abatiy/customes/buildCart.dart';
import 'package:abatiy/pages/Store2.dart';
import 'package:abatiy/payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Classes/Product.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});
  @override
  State<Cart> createState() => _CartState();
}
int itemcount = 1;
int prices=0;
List<Product> order=[];
List<int> counters=[];




class _CartState extends State<Cart> {
  GlobalKey<ScaffoldState> _key=GlobalKey();

  @override
  Widget build(BuildContext context) {
    final shopCart=Provider.of<ShoppingCart>(context);
    order=shopCart.items!;
    return Scaffold(
      key: _key,
        appBar: AppBar(
          title:Image.asset('assets/image/logo.png', width: 200),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
        ),
        body: order.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/image/empty.png'),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Your Cart Is Empty',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 40,
                          fontStyle: FontStyle.italic),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Store2(),));
                        },
                        child: Text('Browse ?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                color: Colors.orangeAccent)))
                  ],
                ),
              )
            : Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Text(
                      'Your Cart',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                        child: ListView.builder(
                      itemCount: order.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.all(20),
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete Item"),
                                    content: Text(
                                        "Are you sure you want to delete this item?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            shopCart.deletItem(index,_key);
                                            shoppingCart.cartCount--;
                                          });
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                        child: Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          minVerticalPadding: 20,
                          shape: OutlineInputBorder(
                              borderSide: BorderSide(
                            width: 0.4,
                          )),
                          title: Text(order[index].title!),
                          subtitle: Text(order[index].subtitle!),
                          leading: Image.network("${order[index].url!}"),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            width: 120,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  child: Container(
                                    child: IconButton(
                                        onPressed: () {
                                          shopCart.incrementItemcount(index);
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.add,
                                        )),
                                  ),
                                  left: 0,
                                ),
                                Positioned(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          shopCart.decrementItemcount(index,_key);

                                        });
                                      },
                                      icon: Icon(Icons.remove)),
                                  right: 0,
                                ),
                                Positioned(
                                  child: Text('${shopCart.itemcount[index]}'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border(
                              top: BorderSide(width: 2, color: Colors.black))),
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Value',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text('${shopCart.calculateprice()}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'VAT %14',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text((shopCart.calculateprice()*14/100).toString() ,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                        Text((shopCart.calculateprice() * 14 / 100 +shopCart.calculateprice()).toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => completion(
                                        data:order,
                                      )));
                            },
                            child: Text('Proceed'),
                            color: Colors.orangeAccent,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));

    throw UnimplementedError();
  }
}
