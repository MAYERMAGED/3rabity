import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/Login.dart';

class Services {
  String? serviceName;
  String? providerName;
  String? providerId;
  String? serviceCode;
  String? notes;
  int? price;
  String? reservationCode;
  DateTime? date;
  CollectionReference servicesCollection =
      FirebaseFirestore.instance.collection('services');

  Services(
      {this.serviceName,
      this.notes,
      this.providerId,
      this.reservationCode,
      this.providerName,
      this.date,
      this.price,
      this.serviceCode});

  String generateRandomRequestId() {
    Random random = Random();
    int randomNumber =
        random.nextInt(1000000); // You can adjust the range as needed
    return randomNumber.toString();
  }

  // Create a service
  void addService(String servicename, int price, String serviceCode) async {
    await servicesCollection.add({
      "reservationCode": generateRandomRequestId(),
      "servicename": servicename,
      "providername": nowUser.name,
      "providerId": nowUser.id,
      "price": price,
      "notes": 'Working Perfect',
      "Date": DateTime.now(),
      "servicecode": "30",
    });
  }

  // Read all services for a user
  Future<List<Services>> getUserServices(String userId) async {
    QuerySnapshot querySnapshot =
        await servicesCollection.where("providerId", isEqualTo: userId).get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Timestamp dateTimestamp = data['Date'] as Timestamp;
      DateTime date = dateTimestamp.toDate();
      return Services(
        serviceName: data['servicename'],
        providerName: data['providername'],
        providerId: data['providerId'],
        price: data['price'],
        notes: data['notes'],
        date: date,
        serviceCode: data['servicecode'],
        reservationCode: data['reservationCode'],
      );
    }).toList();
  }

  // Update a service
  void updateService(String documentId, String newNotes) async {
    await servicesCollection.doc(documentId).update({
      "notes": newNotes,
    });
  }

  // Delete a service
  void deleteService(String reservationCode) async {
    QuerySnapshot<Object?> docID = await servicesCollection
        .where("reservationCode", isEqualTo: reservationCode)
        .get();
    for (QueryDocumentSnapshot documentSnapshot in docID.docs) {
      await servicesCollection.doc(documentSnapshot.id).delete();
    }
  }

  // Delete all services for a user
  void deleteAllUserServices(String userId) async {
    QuerySnapshot querySnapshot =
        await servicesCollection.where("providerId", isEqualTo: userId).get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await servicesCollection.doc(documentSnapshot.id).delete();
    }
  }
}
