import 'dart:math';
import 'package:abatiy/Classes/ShoppingCart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/Login.dart';
import 'Product.dart';

class orders {
  String? ordernumber;
  String? userName;
  String? userId;
  int? price;
  DateTime? dateOforder;
  List<Product>? products;
  List<int>? itemcount;
  CollectionReference orderCollection =
  FirebaseFirestore.instance.collection('order');
  String currentUser = FirebaseAuth.instance.currentUser!.uid;

  orders({this.products,
    this.price,
    this.userId,
    this.itemcount,
    this.ordernumber,
    this.dateOforder,
    this.userName});

  void makeOrder(List<Product> items, List<int> itemcounter) {
    String generateRandomRequestId() {
      Random random = Random();
      int randomNumber =
      random.nextInt(1000000); // You can adjust the range as needed
      return randomNumber.toString();
    }

    String orderId = generateRandomRequestId().toString();

    CollectionReference orderProductsCollection =
    orderCollection.doc(orderId).collection('products');

    orderCollection.doc(orderId).set({
      "orderNumber": orderId,
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "userName": FirebaseAuth.instance.currentUser!.uid,
      "Date": DateTime.now(),
    });

    for (int i = 0; i < items.length; i++) {
      orderProductsCollection.add({
        "productCode": items[i].productcode,
        "sellerId": items[i].sellerID,
        "price": items[i].price,
        "title": items[i].title,
        "subtitle": items[i].subtitle,
        "url": items[i].url,
        "quantity": itemcounter[i]
      });
    }
    ShoppingCart().removeAll();
  }

  Future<List<orders>> getUserOrders() async {
    List<orders> userOrders = [];
bool isres=false;
    await orderCollection
        .where("userId", isEqualTo: nowUser.id)
        .get()
        .then((querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> store = doc.data() as Map<String, dynamic>;

        orders _order = orders(
          userId: store['userId'],
          price: store['price'],
          userName: store['userName'],
          ordernumber: store['orderNumber'],
          products: [], // Initialize products list for each order
        );
        isres ? null : false;

        // Getting the Products from the Collection
        await orderCollection
            .doc("${_order.ordernumber}")
            .collection('products')
            .get()
            .then((queryProducts) {
          for (var docproduct in queryProducts.docs) {
            Map<String, dynamic> subcollection = docproduct.data() as Map<String, dynamic>;
            Product orderproduct = Product(
              title: subcollection['title'],
              subtitle: subcollection['subtitle'],
              price: subcollection['price'],
              sellerID: subcollection['sellerId'],
              productcode: subcollection['productCode'],
              url: subcollection['url'],
                quantity: subcollection['quantity']
            );
            _order.products!.add(orderproduct);
          }
        });

        userOrders.add(_order);
      }
    });

    return userOrders;
  }


  Future<List<Product>> getProviderOrderProducts() async {
    List<Product> orderProducts = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querysnapshot =
      await FirebaseFirestore.instance.collection('order').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> element
      in querysnapshot.docs) {
        Map<String, dynamic> store = element.data();
        orders _order = orders(ordernumber: store['orderNumber']);

        QuerySnapshot<Map<String, dynamic>> queryProducts =
        await orderCollection
            .doc("${_order.ordernumber}")
            .collection('products')
            .where('sellerId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();

        queryProducts.docs.forEach((docproduct) {
          Map<String, dynamic> subcollection = docproduct.data();
          Product orderproduct = Product(
            title: subcollection['title'],
            subtitle: subcollection['subtitle'],
            price: subcollection['price'],
            sellerID: subcollection['sellerId'],
            productcode: subcollection['productCode'],
            url: subcollection['url'],
          );
          orderProducts.add(orderproduct);
        });
      }
    } catch (e) {
      print('Error fetching orders and products: $e');
      // Handle the error as needed
    }

    return orderProducts;
  }
}
