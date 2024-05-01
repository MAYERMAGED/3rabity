import 'package:flutter/material.dart';

import '../Classes/Product.dart';
import '../pages/ProductPage.dart';


class CustomeTest extends StatelessWidget {
  final Product product;
  final int index;
  double? Width;

  CustomeTest({
    super.key,
    required this.product,
    this.Width,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('data'),
                content: Text('Are You Sure you want to Delete this User ?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Product().deleteProduct(
                            product.productcode!, product.sellerID!,product.url!);
                        print(product.productcode!);
                        print(product.sellerID!);
                      },
                      child: Text('Delete')),
                ],
              );
            });
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => productPage(
            data: product,
          ),
        ));
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: Width ?? 300,
              color: Colors.grey[200],
              child: Image.network('${product.url}',
                  height: 100, fit: BoxFit.fill),
            ),
            Text(
              '${product.title}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              '${product.subtitle}',
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
            Text(
              '${product.price} \$'.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}

