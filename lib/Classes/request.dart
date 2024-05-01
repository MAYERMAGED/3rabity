import 'dart:io';
import 'dart:math';
import 'package:abatiy/pages/Login.dart';
import 'package:path/path.dart';
import 'package:abatiy/Classes/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class serviceRequest {
  String? requestId;
  String? requestorName;
  String? userId;
  String? status;
  String? imgUrl;
  CollectionReference requestCollection =
      FirebaseFirestore.instance.collection('request');

  serviceRequest(
      {this.status,
      this.userId,
      this.requestId,
      this.requestorName,
      this.imgUrl});

  Future<List<serviceRequest>> getAllRequests() async {
    List<serviceRequest> requests = [];
    await requestCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> store = doc.data() as Map<String, dynamic>;
        serviceRequest request = serviceRequest(
            requestId: store['requestID'],
            status: store['status'],
            userId: store['userID'],
            imgUrl: store['imgUrl'],
            requestorName: store['requestorName']);
        requests.add(request);
      });
    });
    return requests;
  }

  Future<CurrentUser> getRequestor() async {
    CurrentUser currentuser = CurrentUser(id: userId);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        currentuser.name = documentSnapshot.get('name');
        currentuser.email = documentSnapshot.get('email');
        currentuser.phone = documentSnapshot.get('phone');
        currentuser.address = documentSnapshot.get('address');
        currentuser.type = documentSnapshot.get('type');
      } else {
        print('Does Not Exist');
      }
    });
    return currentuser;
  }

  void addRequest(String imgUrl) {

    requestCollection.doc(FirebaseAuth.instance.currentUser!.uid).set({
      "requestorName": nowUser.name,
      "userID": "${FirebaseAuth.instance.currentUser!.uid}",
      "status": "pending",
      "imgUrl": imgUrl,
      "requestID": generateRandomRequestId()
    });
  }

  void acceptRequest(String ID) async {
    requestCollection.doc(ID).delete();
    await FirebaseFirestore.instance.collection('user').doc(ID).update({
      "type": 'provider',
    });
  }

  void deleteRequeset(String ID) async {
    requestCollection.doc(ID).delete();
  }

  Future<String> getImage() async {
    String imgUrl;
    File? file;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) file = File(image.path);

    var imagename = basename(nowUser.name!);

    var refStorage = FirebaseStorage.instance.ref('Request/$imagename');
    await refStorage.putFile(file!);
    imgUrl = await refStorage.getDownloadURL();

    return imgUrl;
  }

  String generateRandomRequestId() {
    Random random = Random();
    int randomNumber =
    random.nextInt(1000000);
    return randomNumber.toString();
  }

}
