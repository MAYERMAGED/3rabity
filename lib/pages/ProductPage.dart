import 'package:abatiy/Classes/ShoppingCart.dart';
import 'package:abatiy/Classes/comment.dart';
import 'package:abatiy/pages/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Classes/Favorites.dart';
import '../Classes/Product.dart';
import '../customes/ProductCard.dart';
import '../customes/buildCart.dart';

class productPage extends StatefulWidget {
  final Product data;

  const productPage({super.key, required this.data});

  State<productPage> createState() => _MyAppState();
}

Icon selected = Icon(Icons.favorite_outlined);
bool isfav = false;

class _MyAppState extends State<productPage> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController comment = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shopcart = Provider.of<ShoppingCart>(context);
    return Scaffold(
        key: _key,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [shoppingCart()],
              expandedHeight: 350.0,
              floating: true,
              backgroundColor: Colors.grey[200],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Image.network(
                      widget.data.url!,
                    )),
                titlePadding: EdgeInsets.only(bottom: 60),
              ),
            ),
            //--------------End Of Photo and App Bar---------------------
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text.rich(
                          TextSpan(
                              text: "${widget.data.price!} \$",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                    text: '\n${widget.data.title!}',
                                    style: TextStyle(fontSize: 25)),
                                TextSpan(
                                    text: '\n${widget.data.subtitle!}',
                                    style: TextStyle(fontSize: 20))
                              ]),
                        ),
                      ),
                      Icon(Icons.star),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          "${widget.data.description}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 50),
                        decoration: BoxDecoration(
                            border: Border.symmetric(
                                horizontal: BorderSide(color: Colors.black))),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Image.asset('assets/image/logo.png'),
                            backgroundColor: Colors.white,
                            radius: 20,
                          ),
                          title: Text('Added By'),
                          subtitle: Text(widget.data.Seller!),
                        ),
                      ),
                      Text(
                        'Simillar Items',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          height: 230,
                          margin: EdgeInsets.only(top: 10),
                          child: FutureBuilder<List<Product>>(
                            future: Product().getAll(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              if (snapshot.hasError)
                                return Center(
                                  child: Text('Error +${snapshot.error}'),
                                );
                              else {
                                List<Product>? listProducts = snapshot.data;
                                if (listProducts == null ||
                                    listProducts.isEmpty)
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );

                                return ListView.builder(
                                  itemCount: listProducts.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return CustomeTest(
                                        Width: 160,
                                        product: listProducts[index],
                                        index: index);
                                  },
                                );
                              }
                            },
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Title(
                              color: Colors.black,
                              child: Text(
                                'Comments',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ))),
                      Container(
                        height: 280,
                        child: FutureBuilder(
                          future:
                              Product().getComments(widget.data.productcode!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child:
                                      Text('The Error is ${snapshot.error}'));
                            } else {
                              int count=1;
                              List<Comment> comments = snapshot.data!;
                              if(comments.isNotEmpty){
                                count=comments.length+2;
                              }
                              return ListView.builder(
                                  itemCount: count,
                                  itemBuilder: (context, index) {
                                    //-------------If Comments Not Found --------------------------------
                                    if (comments.isEmpty) {
                                      return Container(
                                        child: TextField(
                                          controller: comment,
                                          autocorrect: true,
                                          minLines: 1,
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    Product().addComment(
                                                        Comment(
                                                            text: comment.text,
                                                            userId: FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            Date:
                                                                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                                                        widget
                                                            .data.productcode!);
                                                    comment.clear();
                                                    setState(() {});
                                                  },
                                                  icon: Icon(Icons.send)),
                                              label: Text(
                                                  'comment as ${nowUser.name}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              )),
                                        ),
                                      );
                                    }
                                    //--------------------If Comments Found ----------------------------------

                                    else {
                                      //---------------View All Comments---------------
                                      if (index == comments.length) {
                                        return MaterialButton(
                                          onPressed: () {
                                            _key.currentState!
                                                .showBottomSheet((context) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 30,
                                                    horizontal: 20),
                                                child: Column(
                                                  children: List.generate(
                                                      comments.length, (index) {
                                                    return Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${comments[index].name}',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15),
                                                          ),
                                                          Text(
                                                              '${comments[index].Date}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize:
                                                                      15)),
                                                          Text(
                                                              '${comments[index].text}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                  fontSize:
                                                                      18)),
                                                          Divider(
                                                            thickness: 1,
                                                            color: Colors.black,
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              );
                                            });
                                          },
                                          child: Text('View All Comments',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                        );
                                      }
                                      //------------Comment Section------------------

                                      if (index == comments.length + 1) {
                                        return Container(
                                          child: TextField(
                                            controller: comment,
                                            autocorrect: true,
                                            minLines: 1,
                                            maxLines: 5,
                                            decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                    onPressed: () {
                                                      Product().addComment(
                                                          Comment(
                                                              text:
                                                                  comment.text,
                                                              userId: FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                              Date:
                                                                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
                                                          widget.data
                                                              .productcode!);
                                                      comment.clear();
                                                      setState(() {});
                                                    },
                                                    icon: Icon(Icons.send)),
                                                label: Text(
                                                    'comment as ${nowUser.name}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                filled: true,
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                )),
                                          ),
                                        );
                                      }
                                      return Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${comments[index].name}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                            Text('${comments[index].Date}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15)),
                                            Text('${comments[index].text}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 18)),
                                            Divider(
                                              thickness: 1,
                                              color: Colors.grey[200],
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  });
                            }
                          },
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: FutureBuilder<bool>(
          future: Favorites().isProductinFav(widget.data.productcode!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (snapshot.hasError)
              return Center(
                child: Text('Error is : ${snapshot.error}'),
              );
            else {
              bool fav = snapshot.data!;
              return Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          child: ElevatedButton(
                              onPressed: () {
                                shopcart.addItem(widget.data, _key);
                              },
                              child: Text('Add to Cart')),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 40),
                        child: IconButton(
                            onPressed: () {
                              fav = !fav;

                              if (fav) {
                                Favorites().addFavorites(widget.data);
                              } else {
                                Favorites()
                                    .deleteFavorites(widget.data.productcode!);
                              }
                              setState(() {});
                            },
                            icon:
                                fav ? selected : Icon(Icons.favorite_outline)),
                      )
                    ],
                  ));
            }
          },
        ));
  }
}
