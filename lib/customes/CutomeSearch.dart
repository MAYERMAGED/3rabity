
import 'package:flutter/material.dart';

import '../Classes/Product.dart';
import '../pages/ProductPage.dart';

class CustomSearch extends SearchDelegate {


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: Product().getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        List<Product> products = snapshot.data ?? [];

        if (query == '') {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => productPage(data: products[i]),));

                },
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${products[i].title}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Image.network(
                        '${products[i].url}',
                        width: 70,
                        height: 70,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          List<Product> filteredProducts =
          products.where((element) => element.title!.contains(query)).toList();

          return ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => productPage(data: filteredProducts[i]),));
                },
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredProducts[i].title}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Image.network(
                        '${filteredProducts[i].url}',
                        width: 70,
                        height: 70,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
