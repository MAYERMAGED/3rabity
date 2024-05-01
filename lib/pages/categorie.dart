import 'package:flutter/material.dart';

import '../Classes/Product.dart';
import '../customes/ProductCard.dart';

class CategoriePage extends StatefulWidget {
  final String cat;

  const CategoriePage({super.key, required this.cat});

  @override
  State<CategoriePage> createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "${widget.cat}",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: Colors.orangeAccent,
        edgeOffset: 5,
        onRefresh: () async {
          await Future.delayed(Duration(microseconds: 300));
          setState(() {});
        },
        child: FutureBuilder<List<Product>>(
          future: Product().filterCategories(widget.cat),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Loading state
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Error state
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Product>? products = snapshot.data;
              if (products == null || products.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/image/nodata.png'),
                    Text('No Available items for this Categorie',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                  ],
                );
              }

              return ListView(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                children: [
                  GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 230, crossAxisCount: 2),
                      itemBuilder: (context, i) {
                        Product cardProduct = products[i];
                        return CustomeTest(
                          product: cardProduct,
                          index: i,
                        );
                      }),
                ],
              );
            }
          },
        ),
      ),
    );
    throw UnimplementedError();
  }
}
