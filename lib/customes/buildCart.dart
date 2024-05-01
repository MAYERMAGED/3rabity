import 'package:abatiy/Classes/ShoppingCart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/cartView.dart';

class shoppingCart extends StatefulWidget {
  static int cartCount = 0;
  final data;

  const shoppingCart({super.key, this.data});

  @override
  State<shoppingCart> createState() => _shoppingCartState();
}

class _shoppingCartState extends State<shoppingCart> {
  @override
  Widget build(BuildContext context) {
    final shopcart=Provider.of<ShoppingCart>(context);
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Text(
              '${shopcart.cartCount}',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            top: 22,
          ),
          IconButton(
            tooltip: 'View shopping Cart',
            iconSize: 40,
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Cart(),
                ));
              });
            },
          ),
        ],
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}
