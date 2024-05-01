import 'package:abatiy/Classes/ShoppingCart.dart';
import 'package:abatiy/Classes/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class completion extends StatefulWidget {
  final data;

  const completion({super.key, this.data});

  @override
  State<completion> createState() => _completionState();
}

class _completionState extends State<completion> {
  @override
  Widget build(BuildContext context) {
    final shopcart = Provider.of<ShoppingCart>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Image.asset('assets/image/logo.png', width: 180),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose Your payment Method',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 40,
            ),
            ListTile(
              onTap: () {
                orders().makeOrder(shopcart.items, shopcart.itemcount);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => donepayment()));
              },
              tileColor: Colors.grey[200],
              minVerticalPadding: 30,
              title: Text('Fawry'),
              leading: Image.asset('assets/image/fawry logo.png', width: 80),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                orders().makeOrder(shopcart.items, shopcart.itemcount);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => donepayment()));
              },
              tileColor: Colors.grey[200],
              minVerticalPadding: 30,
              title: Text('Visa'),
              leading: Image.asset('assets/image/visa.png', width: 80),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                orders().makeOrder(shopcart.items, shopcart.itemcount);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => donepayment()));
              },
              tileColor: Colors.grey[200],
              minVerticalPadding: 30,
              title: Text('InstaPay'),
              leading: Image.asset('assets/image/instapay.png', width: 80),
            ),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}

class donepayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shopCart = Provider.of<ShoppingCart>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        leading: IconButton(
            onPressed: () {
              shopCart.removeAll();
              Navigator.popUntil(context, ModalRoute.withName('Store'));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/image/confirmed.png'),
            SizedBox(
              height: 30,
            ),
            Text(
              'Your Order Has been placed',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}
