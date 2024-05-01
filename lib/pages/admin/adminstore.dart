
import 'package:abatiy/customes/addProductButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Classes/Product.dart';
import '../../Classes/ShoppingCart.dart';
import '../../customes/CategorieButton.dart';
import '../../customes/CutomeSearch.dart';
import '../../customes/ProductCard.dart';
import '../../customes/buildCart.dart';

void main() => runApp(MaterialApp(
      home: adminStore(),
    ));

class adminStore extends StatefulWidget {
  const adminStore({super.key});

  State<adminStore> createState() => _Myappstate();
}

class _Myappstate extends State<adminStore> {
  String? imgUrl;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final shopcart = Provider.of<ShoppingCart>(context);
    return Scaffold(
      key: _scaffoldState,
      floatingActionButton: addProductButton(globalKey: _scaffoldState),
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
      body: RefreshIndicator(
        color: Colors.orangeAccent,
        edgeOffset: 5,
        onRefresh: () async {
          await Future.delayed(Duration(microseconds: 300));
          setState(() {});
        },
        child: FutureBuilder<List<Product>>(
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
                return Center(child: Image.asset('assets/image/nodata.png'));
              }

              return ListView(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.add))
                      ],
                    ),
                  ),
                  Container(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CustomeCategorie(
                          categorieicon: Icons.add,
                          txt: 'Safety Accessories',
                        ),
                        CustomeCategorie(
                          categorieicon: Icons.android_outlined,
                          txt: 'Exterior Accessories',
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
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
