import 'dart:io';
import 'package:abatiy/Classes/request.dart';
import 'package:abatiy/pages/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'comment.dart';

class Product {
  String? sellerID;
  String? Seller;
  String? title;
  String? subtitle;
  String? description;
  String? url;
  String? productcode;
  int? quantity;
  String? categorie;
  int? price;
  List<Product> Products = [];
  List<Comment> comments = [];

  CollectionReference productCollection =
      FirebaseFirestore.instance.collection('products');

  QuerySnapshot? querySnapshot;

  Product(
      {this.title,
      this.price,
      this.subtitle,
      this.description,
      this.categorie,
      this.productcode,
      this.quantity,
      this.url,
      this.Seller,
      this.sellerID});

  Future<List<Product>> getAll() async {
    List<Product> allProducts = [];
    await productCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> store = doc.data() as Map<String, dynamic>;
        Product product = Product(
            title: store['title'],
            price: store['price'],
            subtitle: store['subtitle'],
            description: store['description'],
            sellerID: store['sellerID'],
            productcode: store['code'],
            Seller: store['seller'],
            categorie: store['categorie'],
            // quantity: store['quantity'],   // Under Implementation
            url: store['url']);
        allProducts.add(product);
      });
    });
    return allProducts;
  }

  Future<List<Product>> getCurrentProviderProducts() async {
    List<Product> currentUserProducts = [];
    await productCollection
        .where("sellerID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> store = doc.data() as Map<String, dynamic>;
        Product product = Product(
          title: store['title'],
          price: store['price'],
          subtitle: store['subtitle'],
          description: store['description'],
          sellerID: store['sellerID'],
          productcode: store['code'],
          Seller: store['seller'],
          url: store['url'],
        );
        currentUserProducts.add(product);
      });
    });

    return currentUserProducts;
  }

  // Future<Product> getProductByCode(String productCode) async {
  //   Product product = Product();
  //
  //   await productCollection
  //       .where("sellerID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       Map<String, dynamic> store = doc.data() as Map<String, dynamic>;
  //       Product product = Product(
  //         title: store['title'],
  //         price: store['price'],
  //         subtitle: store['subtitle'],
  //         description: store['description'],
  //         sellerID: store['sellerID'],
  //         productcode: store['code'],
  //         Seller: store['seller'],
  //         url: store['url'],
  //       );
  //     });
  //   });
  //   return product;
  // }

  void addProduct(String title, String subtitle, String description, int price,
      String categorie, String imgUrl) {
    productCollection.add({
      "title": title,
      "subtitle": subtitle,
      "description": description,
      "seller": nowUser.name,
      "sellerID": nowUser.id,
      "price": price,
      "url": imgUrl,
      "categorie": categorie,
      "code": serviceRequest().generateRandomRequestId()
    });
  }

  void deleteProduct(String code, String sellerId, String imageUrl) async {
    try {
      // Delete the product document from Firestore
      QuerySnapshot querySnapshot = await productCollection
          .where("code", isEqualTo: code)
          .where("sellerID", isEqualTo: sellerId)
          .get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await productCollection.doc(documentSnapshot.id).delete();
      }

      // Delete the associated image from Firebase Storage
      await deleteImage(imageUrl);
    } catch (e) {
      print('Error deleting product: $e');
      // Handle error as needed
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      // Get a reference to the storage location of the image
      Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);

      // Delete the image from storage
      await imageRef.delete();
    } catch (e) {
      print('Error deleting image: $e');
      // Handle error as needed
    }
  }

  Future<String> getImage() async {
    String imgUrl;
    File? file;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) file = File(image.path);

    var imagename = basename(image!.path);

    var refStorage = FirebaseStorage.instance.ref('products/$imagename');
    await refStorage.putFile(file!);
    imgUrl = await refStorage.getDownloadURL();

    return imgUrl;
  }

  Future<List<Product>> filterCategories(String categorie) async {
    List<Product> _products = [];
    await productCollection
        .where('categorie', isEqualTo: categorie)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> store = doc.data() as Map<String, dynamic>;
        Product _product = Product(
          url: store['url'],
          productcode: store['code'],
          sellerID: store['sellerID'],
          price: store['price'],
          Seller: store['seller'],
          description: store['description'],
          subtitle: store['subtitle'],
          title: store['title'],
        );
        _products.add(_product);
      });
    });
    if (_products.isEmpty) return _products = [];

    return _products;
  }

  void addComment(Comment comment, String productId) async {
    QuerySnapshot productQuery =
        await productCollection.where('code', isEqualTo: productId).get();

    if (productQuery.docs.isNotEmpty) {
      String productDocId = productQuery.docs.first.id;

      CollectionReference productCommentsCollection =
          productCollection.doc(productDocId).collection('comment');

      await productCommentsCollection.add({
        'text': comment.text,
        'date': comment.Date,
        'userId': comment.userId,
        'name': nowUser.name ?? 'default'
      });
    } else {
      print('Product not found for code: $productId');
    }
  }

  Future<List<Comment>> getComments(String prodcutCode) async {
    List<Comment> comments = [];
    QuerySnapshot productQuery =
        await productCollection.where('code', isEqualTo: prodcutCode).get();
    if (productQuery.docs.isNotEmpty) {
      String productDocId = productQuery.docs.first.id;
      await productCollection
          .doc(productDocId)
          .collection('comment')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          Map<String, dynamic> store = element.data() as Map<String, dynamic>;
          Comment comment = Comment(
            text: store['text'],
            Date: store['date'],
            userId: store['userId'],
            name: store['name']
          );
          comments.add(comment);
        });
      });
    }
    return comments;
  }
}
