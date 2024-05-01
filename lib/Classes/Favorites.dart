import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Product.dart';

class Favorites with ChangeNotifier {
  List<Product>? favorites;

  CollectionReference products = FirebaseFirestore.instance
      .collection('Favorites')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('products');
  Favorites({this.favorites}) ;




  void addFavorites(Product product) async {
    await products.add({
      "productCode": product.productcode,
      "title": product.title,
      "subtitle": product.subtitle,
      "img": product.url,
      "price": product.price,
    });
    notifyListeners();
  }

  void deleteFavorites(String code) async {
    QuerySnapshot querySnapshot =
        await products.where('productCode', isEqualTo: code).get();

    if (querySnapshot.size > 0) {
      DocumentReference docRef = querySnapshot.docs[0].reference;

      await docRef.delete();
    }
    notifyListeners();
  }

  Future<List<Product>> getUserFavorites() async {
    List<Product> favProducts = [];
    await products.get().then((value) {
      value.docs.forEach((element) {
        Map<String, dynamic> store = element.data() as Map<String, dynamic>;
        Product _product = Product(
          url: store['img'],
          price: store['price'],
          productcode: store['productCode'],
          title: store['title'],
          subtitle: store['subtitle'],
        );
        favProducts.add(_product);
      });
    });

    return favProducts;
  }

  Future<bool> isProductinFav(String productCode) async {
    bool isfav = false;

    QuerySnapshot querySnapshot =
        await products.where("productCode", isEqualTo: productCode).get();

    if (querySnapshot.docs.isNotEmpty) {
      isfav = true;
    }
   return isfav;
  }

}
