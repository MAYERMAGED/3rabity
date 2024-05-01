import 'package:abatiy/pages/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentUser {
  String? type;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? id;
  String? url;
  String? Car;
  String? carType;
  CollectionReference usercollection =
      FirebaseFirestore.instance.collection('user');

  //
  // DocumentReference docId = FirebaseFirestore.instance
  //     .collection('user')
  //     .doc("${FirebaseAuth.instance.currentUser!.uid}");

  CurrentUser(
      {this.email,
      this.carType,
      this.Car,
      this.phone,
      this.name,
      this.address,
      this.type,
      this.id,
      this.url});

  void rememberCurrentUser() async {
    final SharedPreferences inAppUser = await SharedPreferences.getInstance();
    CurrentUser _user = await getUserData();

    inAppUser.setString('id', _user.id!);
    inAppUser.setString('name', _user.name!);
    inAppUser.setString('type', _user.type!);
    inAppUser.setString('email', _user.email!);
    inAppUser.setString('phone', _user.phone!);
    inAppUser.setString('address', _user.address!);
    // inAppUser.setString('image', _user.url!);
    inAppUser.setBool('rememberme', rememberme);

    print('User data stored in SharedPreferences.');
  }

  void clearCachedUser() async {
    final SharedPreferences inAppUser = await SharedPreferences.getInstance();
    inAppUser.clear();
  }

  Future<List<CurrentUser>> getUsersByType(String userType) async {
    List<CurrentUser> usersByType = [];

    await usercollection
        .where('type', isEqualTo: userType)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        CurrentUser user = CurrentUser(
          type: userData['type'],
          phone: userData['phone'],
          name: userData['name'],
          id: userData['id'],
          email: userData['email'],
          address: userData['address'],
        );

        usersByType.add(user);
      });
    });

    return usersByType;
  }

  Future<CurrentUser> getUserData() async {
    CurrentUser currentuser =
        CurrentUser(id: "${FirebaseAuth.instance.currentUser!.uid}");

    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        currentuser.name = documentSnapshot.get('name');
        currentuser.email = documentSnapshot.get('email');
        currentuser.phone = documentSnapshot.get('phone');
        currentuser.address = documentSnapshot.get('address');
        currentuser.type = documentSnapshot.get('type');
        currentuser.carType = documentSnapshot.get('carType');
        currentuser.Car = documentSnapshot.get('car');
      } else {
        print('Does Not Exist');
        print(FirebaseAuth.instance.currentUser?.uid);
        return null;
      }
    });
    return currentuser;
  }

  Future<CurrentUser> getUserbyID(String id) async {
    CurrentUser currentuser =
        CurrentUser(id: "${FirebaseAuth.instance.currentUser!.uid}");
    await FirebaseFirestore.instance
        .collection('user')
        .doc(id)
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
        print(FirebaseAuth.instance.currentUser?.uid);
      }
    });
    return currentuser;
  }

  Future<List<CurrentUser>> getAll() async {
    List<CurrentUser> allUsers = [];
    await usercollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> store = doc.data() as Map<String, dynamic>;
        CurrentUser _user = CurrentUser(
            type: store['type'],
            phone: store['phone'],
            name: store['name'],
            id: store['id'],
            email: store['email'],
            address: store['id']);
        allUsers.add(_user);
      });
    });
    return allUsers;
  }

  void updateUserData(
      String name, String email, String phone, String address) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
    });

    // try {
    //   await FirebaseAuth.instance.currentUser!.updateEmail(email);
    //   // The email update was successful
    // } catch (e) {
    //   // Handle any errors that occurred during the email update
    //   print("Error updating email: $e");
    // }
  }

  void updatedType(String type, String userId) async {
    await FirebaseFirestore.instance.collection('user').doc(userId).update({
      "type": type,
    });
  }

  void addUser(String name, String email, String phone, String type,
      String address, String car, String carType) async {
    usercollection
        .doc(
      FirebaseAuth.instance.currentUser!.uid,
    )
        .set({
      "id": FirebaseAuth.instance.currentUser!.uid,
      "name": name,
      "phone": phone,
      "email": email,
      "address": address,
      "type": type,
      "car": car ?? 'None',
      "carType": carType ?? "none",
    });
  }

  void deleteUser(String docId) async {
    await usercollection.doc(docId).delete();
  }
}
