import 'package:abatiy/Classes/Product.dart';
import 'package:abatiy/Classes/orders.dart';
import 'package:abatiy/Classes/service.dart';
import 'package:abatiy/pages/Login.dart';
import 'package:abatiy/pages/cartView.dart';
import 'package:flutter/material.dart';

class providerOrders extends StatefulWidget {
  @override
  State<providerOrders> createState() => _providerOrdersState();
}

class _providerOrdersState extends State<providerOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(Icons.refresh,size: 30,color: Colors.black,))
          ],
          backgroundColor: Colors.orangeAccent,
          title: Text(
            'View Orders',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Product>>(
          future: orders().getProviderOrderProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            } else {
              List<Product> _providerOrderProducts = snapshot.data!;
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/image/empty.png'),
                        Text('No Orders',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                      ],
                    )
                );
              }
              return Stack(
                children: [
                  Container(
                    child: ListView.builder(
                      itemCount: _providerOrderProducts.length,
                      itemBuilder: (context, index) {
                        Product _prodcuts = _providerOrderProducts[index];
                        return InkWell(
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Remove'),
                                    content: Text(
                                        'Are you Sure you want to Cancel this Service ?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('No')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {});
                                          },
                                          child: Text('Yes')),
                                    ],
                                  );
                                });
                            setState(() {});
                          },
                          child: Card(
                            child: ListTile(
                              minVerticalPadding: 30,
                              leading: Image.network("${_prodcuts.url}"),
                              title: Text('${_prodcuts.title}'),
                              subtitle: Text("${_prodcuts.subtitle}"),
                              trailing: Text("Price :${_prodcuts.price}"),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ));
    throw UnimplementedError();
  }
}
