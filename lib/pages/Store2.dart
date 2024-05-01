import 'package:abatiy/customes/FloatinglabelTextField.dart';
import 'package:abatiy/customes/buildCart.dart';
import 'package:abatiy/pages/ProductPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Classes/Product.dart';
import '../Classes/ShoppingCart.dart';
import '../customes/CategorieButton.dart';
import '../customes/CutomeSearch.dart';
import '../customes/ProductCard.dart';

void main() => runApp(MaterialApp(
      home: Store2(),
    ));

class Store2 extends StatefulWidget {
  const Store2({super.key});

  State<Store2> createState() => _Myappstate();
}

List? filtred;

class _Myappstate extends State<Store2> {
  GlobalKey<FormState> _formstate = GlobalKey();
  TextEditingController _title = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopcart = Provider.of<ShoppingCart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          child: TextField(
            onTap: () => showSearch(context: context, delegate: CustomSearch()),
            readOnly: true,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Search',
              suffixIcon: Icon(Icons.search_rounded),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        actions: [shoppingCart()],
      ),
      body: FutureBuilder<List<Product>>(
        future: Product().getAll(),
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
              return Center(
                child: Text('No Avilable Data'),
              );
            }
            return ListView(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50, bottom: 30),
                  child: Text(
                    'Categories',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Container(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CustomeCategorie(
                        categorieicon: Icons.abc,
                        txt: 'Interior Accessories',
                      ),
                      CustomeCategorie(
                        categorieicon: Icons.android_outlined,
                        txt: 'Exterior Accessories',
                      ),
                      CustomeCategorie(
                        categorieicon: Icons.add,
                        txt: 'Safety Accessories',
                      ),
                      CustomeCategorie(
                        categorieicon: Icons.camera_alt,
                        txt: 'Performance Accessories',
                      ),
                      CustomeCategorie(
                        categorieicon: Icons.apple,
                        txt: 'Electronics and Technology',
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'Best Selling',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 230, crossAxisCount: 2),
                    itemBuilder: (context, i) {
                      Product cardProduct = products[i];
                      return customeStoreUser(
                        product: cardProduct,
                        index: i,
                      );
                    }),
              ],
            );
          }
        },
      ),
    );
    throw UnimplementedError();
  }
}

class customeStoreUser extends StatelessWidget {
  final Product product;
  final int index;
  double? Width;

  customeStoreUser({
    super.key,
    required this.product,
    this.Width,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            Text(
              '${product.price}'.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}
