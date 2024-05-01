import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Message {
  String? text;
  String? senderId;
  String? receiverId;
  DateTime? dateTime;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('messages');

  Message({this.text, this.dateTime, this.receiverId, this.senderId});

  void sendMessage(Message message) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('messages')
        .doc('${FirebaseAuth.instance.currentUser!.uid}_${message.receiverId}').collection('sent');
    await collectionReference.add({
      'text': message.text,
      'senderId': message.senderId,
      'receiverId': message.receiverId,
      'date': message.dateTime,
    });
  }
}
