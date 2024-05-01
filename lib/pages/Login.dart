import 'package:abatiy/Classes/User.dart';
import 'package:abatiy/pages/RoutingPage.dart';
import 'package:abatiy/pages/Service%20Provider/providerRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:abatiy/pages/Store.dart';
import 'package:abatiy/pages/Sign up.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'admin/adminRoute.dart';

class arabity extends StatefulWidget {
  const arabity({super.key});

  State<arabity> createState() => _MyAppState();
}

CurrentUser nowUser = CurrentUser();
bool rememberme = false;

class _MyAppState extends State<arabity> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  GlobalKey<FormState> _formstate = GlobalKey();
  bool isloading = false;
  bool _ispassvisible = true;

  void signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;
    print(FirebaseAuth.instance.currentUser!.uid);
    nowUser.getUserbyID(user!.uid);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => RouteUserOnType(nowUser.type!)!,
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isloading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  color: modecolor,
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(top: 70),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 30),
                        child: Image.asset('assets/image/logo.png'),
                      ),
                      Container(
                        width: 300,
                        child: Form(
                          key: _formstate,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _email,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _email.text = '';
                                          });
                                        },
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.black45,
                                        )),
                                    labelText: 'Email',
                                    hintText: 'Email',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 4),
                                        borderRadius:
                                            BorderRadius.circular(600))),
                                validator: (value) {
                                  if (value!.isEmpty) return 'Required';
                                },
                              ),
                              Container(
                                height: 20,
                              ),
                              TextFormField(
                                controller: _pass,
                                obscureText: _ispassvisible,
                                validator: (value) {
                                  if (value!.isEmpty) return 'Required';
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.password),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _ispassvisible = !_ispassvisible;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.black45,
                                        )),
                                    labelText: 'Password',
                                    hintText: 'password',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 4),
                                        borderRadius:
                                            BorderRadius.circular(600))),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: Colors.orangeAccent,
                                      value: rememberme,
                                      onChanged: (value) {
                                        setState(() {
                                          rememberme = value!;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Remember me',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MaterialButton(
                                      onPressed: () async {
                                        if (_formstate.currentState!
                                            .validate()) {
                                          isloading = true;
                                          setState(() {});
                                          try {
                                            final credential =
                                                await FirebaseAuth.instance
                                                    .signInWithEmailAndPassword(
                                              email: _email.text,
                                              password: _pass.text,
                                            );
                                              nowUser = await CurrentUser()
                                                  .getUserData();
                                              if(nowUser.type!=null){
                                            if (rememberme == true) {
                                              CurrentUser()
                                                  .rememberCurrentUser();
                                            }
                                            Widget _route =
                                                RouteUserOnType(nowUser.type!)!;
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                              builder: (context) => _route,
                                            ));
                                            }else{
                                                isloading = false;
                                                setState(() {});
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        'Email Was not found')));
                                              }
                                          } on FirebaseAuthException catch (e) {
                                            isloading = false;
                                            setState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        'Wrong Email Or Password')));
                                          }
                                        } else
                                          isloading = false;
                                        setState(() {});
                                      },
                                      child: Text(
                                        'Login',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.orangeAccent,
                                    ),
                                  ],
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    isPressed = Colors.red;
                                  });
                                },
                                child: Text(
                                  'Forget your Password?',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 17,
                                      color: isPressed),
                                ),
                              ),
                              Container(
                                color: Colors.transparent,
                                child: Text(
                                  '---------- Login With ---------',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 80,
                                      child: Column(
                                        children: [
                                          MaterialButton(
                                            onPressed: () {},
                                            child: Image.asset(
                                              'assets/image/facebook.png',
                                            ),
                                          ),
                                          Text(
                                            'Facebook',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      height: 80,
                                      child: Column(
                                        children: [
                                          MaterialButton(
                                            onPressed: () {
                                              signInWithGoogle();
                                            },
                                            child: Image.asset(
                                              'assets/image/gmail.png',
                                            ),
                                          ),
                                          Text(
                                            'Gamil',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      height: 80,
                                      child: Column(
                                        children: [
                                          MaterialButton(
                                            onPressed: () {},
                                            child: Image.asset(
                                              'assets/image/twitter.png',
                                            ),
                                          ),
                                          Text(
                                            'Twitter',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Not Registered Yet ?',
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Signup()));
                              },
                              child: Text(
                                'Register Here',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }

  Widget? RouteUserOnType(String type) {
    Widget? home;
    switch (type) {
      case "user":
        home = userRouting();
      case "admin":
        home = adminRoute();
      case "provider":
        home = providerRoute();
    }
    return home;
  }
}
