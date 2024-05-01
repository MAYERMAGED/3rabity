import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class signtest extends StatefulWidget {
  const signtest({super.key});

  @override
  State<signtest> createState() => _signtestState();
}

TextEditingController _currentemail = TextEditingController();
TextEditingController _currentpass = TextEditingController();
GlobalKey<FormState> _thisformstate = GlobalKey();

class _signtestState extends State<signtest> {

  void signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if(googleUser==null)
      return;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    Navigator.of(context).pushNamedAndRemoveUntil('Homepage', (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: ListView(
          children: [
            SizedBox(height: 70),
            Image.asset(
              'assets/image/logo.png',
              height: 60,
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              'Login',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Form(
                key: _thisformstate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'Email',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    TextFormField(
                      controller: _currentemail,
                      validator: (value) {
                        if (value!.isEmpty) return 'Empty Field';
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey[300],
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none)),
                    ),

                    // Password TextField
                    SizedBox(height: 30),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    TextFormField(
                      controller: _currentpass,
                      validator: (value) {
                        if (value!.isEmpty) return 'Empty Field';
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey[300],
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none)),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Forget Your Password?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    IconButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 130, vertical: 20),
                        color: Colors.orangeAccent,
                        onPressed: () async {
                          if(_thisformstate.currentState!.validate())
                          if (FirebaseAuth
                              .instance.currentUser!.emailVerified) {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: _currentemail.text,
                                password: _currentpass.text,
                              );
                              Navigator.of(context)
                                  .pushReplacementNamed('Homepage');
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              }
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.orangeAccent,
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Pleae Verfiy Email',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )));
                          }
                        },
                        icon: Icon(
                          Icons.arrow_circle_right_rounded,
                          size: 80,
                        )),
                    Container(
                      alignment: Alignment.center,
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: 'Dosen\' Have an Account ?'),
                        TextSpan(
                            text: 'Press Here',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context)
                                    .pushReplacementNamed("test");
                              })
                      ])),
                    ),
                    MaterialButton(
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {
                        signInWithGoogle();
                      },
                      child: TextFormField(
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                              enabled: false,
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              suffixIcon: Container(
                                margin:
                                    const EdgeInsets.only(right: 80, left: 10),
                                child: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                              ),
                              hintText: 'Login with Google')),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}

void showErrorDialog(BuildContext context, String message) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.info,
    animType: AnimType.rightSlide,
    title: 'Error',
    desc: message,
    btnCancelOnPress: () {},
    btnOkOnPress: () {},
  )..show();
}

bool isverified() {
  if (FirebaseAuth.instance.currentUser!.emailVerified) return true;
  return false;
}
