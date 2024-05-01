import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Signuptest extends StatefulWidget {
  const Signuptest({super.key});

  @override
  State<Signuptest> createState() => _SignuptestState();
}

TextEditingController _username = TextEditingController();
TextEditingController _email = TextEditingController();
TextEditingController _pas = TextEditingController();
GlobalKey<FormState> _signupstate = GlobalKey();

class _SignuptestState extends State<Signuptest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: ListView(
          children: [
            SizedBox(height: 40),
            Image.asset(
              'assets/image/logo.png',
              height: 60,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Sign Up',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Form(
                key: _signupstate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Username',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    TextFormField(
                      controller: _username,
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
                      'Email',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    TextFormField(
                      controller: _email,
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
                      controller: _pas,
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
                    IconButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: 130, vertical: 15),
                        color: Colors.orangeAccent,
                        onPressed: () async {
                          if(_signupstate.currentState!.validate())
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: _email.text,
                              password: _pas.text,
                            );
                            FirebaseAuth.instance.currentUser!.sendEmailVerification();
                            Navigator.of(context)
                                .pushReplacementNamed('login');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Weak Password',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              )..show();
                            } else if (e.code == 'email-already-in-use') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.info,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'This Email is Already Registred',
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {},
                              )..show();
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        icon: Icon(
                          Icons.arrow_circle_right_rounded,
                          size: 80,
                        )),
                    Container(
                      alignment: Alignment.center,
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: 'Already Have an Account ?'),
                        TextSpan(
                            text: 'Press Here',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamed('login');
                              })
                      ])),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}
