import 'package:abatiy/pages/ProductPage.dart';
import 'package:flutter/material.dart';
import '../../Classes/Product.dart';
import '../../customes/addProductButton.dart';

class providerProducts extends StatefulWidget {
  const providerProducts({super.key});

  State<providerProducts> createState() => _Myappstate();
}

List? filtred;

class _Myappstate extends State<providerProducts> {
  GlobalKey<ScaffoldState> _scaffolState = GlobalKey();
  TextEditingController _title = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolState,
      floatingActionButton: addProductButton(globalKey: _scaffolState),
      appBar: AppBar(
        title: Image.asset('assets/image/logo.png',width: 220,),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(
                Icons.refresh,
                size: 30,
                color: Colors.black,
              ))
        ],
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder<List<Product>>(
        future: Product().getCurrentProviderProducts(),
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
                child: Image.asset('assets/image/nodata.png')
                );
            }
            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          'My Products',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: products.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 230, crossAxisCount: 2),
                              itemBuilder: (context, i) {
                                Product cardProduct = products[i];
                                return CustomeTest(
                                  product: cardProduct,
                                  index: i,
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
    throw UnimplementedError();
  }
}

class CustomeCategorie extends StatelessWidget {
  final IconData categorieicon;
  final String txt;

  const CustomeCategorie(
      {super.key, required this.categorieicon, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(50)),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              categorieicon,
              color: Colors.black,
            ),
          ),
          height: 80,
          width: 80,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            '$txt',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// class CutomeSearch extends SearchDelegate {
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//           onPressed: () {
//             query = '';
//           },
//           icon: Icon(Icons.close))
//     ];
//     throw UnimplementedError();
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           close(context, null);
//         },
//         icon: Icon(Icons.arrow_back_outlined));
//     throw UnimplementedError();
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return Text("");
//     throw UnimplementedError();
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     if (query == '') {
//       return ListView.builder(
//           itemCount: products.length,
//           itemBuilder: (context, i) {
//             return InkWell(
//               child: Card(
//                   child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '${products[i]['title']}',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   Image.asset(
//                     '${products[i]['img']}',
//                     width: 70,
//                     height: 70,
//                   )
//                 ],
//               )),
//             );
//           });
//     } else {
//       filtred = products.where((element) => element.contains(query)).toList();
//       return ListView.builder(
//           itemCount: products.length,
//           itemBuilder: (context, i) {
//             return InkWell(
//               onTap: () => productPage(data: products[i]),
//               child: Card(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '${products[i]['title']}',
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     Image.asset(
//                       '${products[i]['img']}',
//                       width: 70,
//                       height: 70,
//                     )
//                   ],
//                 ),
//               ),
//             );
//           });
//     }
//     throw UnimplementedError();
//   }
// }

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
