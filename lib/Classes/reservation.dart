import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class reservation {
  String? reservationNumber;
  String? providerId;
  String? userId;

  String? ServiceName;
  String? notes;
  DateTime? date;
  String? time;

  CollectionReference ReservationCollection =
      FirebaseFirestore.instance.collection('Reservation');

  reservation(
      {this.notes,
      this.userId,
      this.date,
      this.providerId,
      this.time,
      this.reservationNumber,
      this.ServiceName});

  Future<List<String>> getSelectedTime(DateTime date,String providerID) async {
    List<String> allTimes = ['10:00 AM', '11:00 AM', '12:00 PM', '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM', '06:00 PM'];

    QuerySnapshot querySnapshot = await ReservationCollection.where("Date",isEqualTo: date).where("providerId" , isEqualTo: providerID).get();

    List<String> reservedTimes = List<String>.from(querySnapshot.docs.map((doc) {
      Map<String, dynamic> store = doc.data() as Map<String, dynamic>;
      return store['time'] as String;
    }));

    List<String> availableTimes = List<String>.from(allTimes.where((time) => !reservedTimes.contains(time)));

    print(availableTimes);
    return availableTimes;
  }


  String generateRandomRequestId() {
    Random random = Random();
    int randomNumber =
        random.nextInt(1000000); // You can adjust the range as needed
    return randomNumber.toString();
  }

  void addReservation(String providerId, String serviceName, DateTime date,String time,
      {String? notes}) async {
    await ReservationCollection.add({
      "reservationNumber": generateRandomRequestId(),
      "serviceName": serviceName,
      "providerId": providerId,
      "UserId": FirebaseAuth.instance.currentUser!.uid,
      "notes": notes ?? '',
      "Date": date,
      "time" :time
    });
  }

  Future<List<reservation>> getProviderReservations() async {
    List<reservation> providerReservations = [];
    await ReservationCollection.where('providerId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((querysnapshot) {
      querysnapshot.docs.forEach((doc) {
        Map<String, dynamic> store = doc.data() as Map<String, dynamic>;

        // Convert Timestamp to DateTime
        DateTime dateTime = store['Date'].toDate();
        reservation Reservation = reservation(
          userId: store['UserId'],
          reservationNumber: store['reservationNumber'],
          providerId: store['providerId'],
          ServiceName: store['serviceName'],
          notes: store['notes'] ?? '',
          date: dateTime,
          time: store['time']
        );
        providerReservations.add(Reservation);
      });
    });
    providerReservations.sort((a, b) => a.date!.compareTo(b.date!));
    return providerReservations;
  }

  Future<List<reservation>> getUserReservation() async {
    List<reservation> providerReservations = [];
    await ReservationCollection.where('UserId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((querysnapshot) {
      querysnapshot.docs.forEach((doc) {
        Map<String, dynamic> store = doc.data() as Map<String, dynamic>;

        // Convert Timestamp to DateTime
        DateTime dateTime = store['Date'].toDate();
        reservation Reservation = reservation(
            userId: store['UserId'],
            reservationNumber: store['reservationNumber'],
            providerId: store['providerId'],
            ServiceName: store['serviceName'],
            notes: store['notes'] ?? '',
            date: dateTime,
            time: store['time']
          );
        providerReservations.add(Reservation);
      });
    });
    return providerReservations;
  }
}
