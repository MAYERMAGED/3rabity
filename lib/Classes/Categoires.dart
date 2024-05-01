import 'package:cloud_firestore/cloud_firestore.dart';

class Categoire {
  String? name;
  CollectionReference categorieCollection =
      FirebaseFirestore.instance.collection('categorie');

  Categoire({this.name});

  void addCategorie(String name) {
    categorieCollection.add({"name": name});
  }

  Future<List<Categoire>> getAllCategoire() async {
      List<Categoire> Cat = [];
    await categorieCollection.get().then((value) {
      value.docs.forEach((element) {
        Map<String, dynamic> store = element.data() as Map<String, dynamic>;
        Categoire _cat = Categoire(name: store['name']);
        Cat.add(_cat);
      });
    });
    return Cat;
  }
}
