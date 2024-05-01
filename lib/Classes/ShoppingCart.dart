

import 'package:abatiy/Classes/Product.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ShoppingCart with ChangeNotifier {
  // int itemCount = 1;
  int cartCount = 0;
  List<Product> items = [];
  List<int> itemcount = [];
  CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('order');

  // void incrementItemCount() {
  //   itemCount++;
  //   notifyListeners();
  // }
  //
  // void decrementItemCount(index) {
  //   itemCount--;
  //   if (itemCount < 1) deletItem(index);
  //   notifyListeners();
  // }

  void incrementItemcount(int index) {
    itemcount[index]++;
  }

  void decrementItemcount(int index,GlobalKey key) {
    itemcount[index]--;
    if(itemcount[index]<1)
      deletItem(index,key);
  }

  void addItem(Product product,GlobalKey key) {
    items.add(product);
    itemcount.add(1);
    cartCount++;
    Message('Added to Cart', key,Colors.green);
    notifyListeners();
  }

  void deletItem(int index,GlobalKey key) {
    items.removeAt(index);
    cartCount--;
    itemcount.removeAt(index);
    Message('Item removed', key,Colors.red);
    notifyListeners();
  }

  void removeAll() {
    items.removeRange(0, items.length);
    cartCount = 0;
    notifyListeners();
  }

  int calculateprice() {
    int total = 0;
    for (int i = 0; i < items.length; i++) {
      try {
        total = (items[i].price! * itemcount[i]) + total;

      } catch (e) {
        print('Error is $e');
      }
    }
    return total;
  }
  void Message(String text,GlobalKey key,Color color){
    ScaffoldMessenger.of(key.currentContext!).showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
      content: Text('$text'),
      backgroundColor: color,
    ));
  }
}
