import 'package:abatiy/Classes/User.dart';
import 'package:abatiy/pages/RoutingPage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../customes/singupField.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  List<Map<String, String>> carsList = [
    {"car": "Skoda Kodiaq", "type": "SUV"},
    {"car": "Toyota Camry", "type": "Sedan"},
    {"car": "Ford Mustang", "type": "Sports Car"},
    {"car": "Chevrolet Tahoe", "type": "SUV"},
    {"car": "Honda Accord", "type": "Sedan"},
    {"car": "Porsche 911", "type": "Sports Car"},
    {"car": "Jeep Wrangler", "type": "SUV"},
    {"car": "BMW 3 Series", "type": "Sedan"},
    {"car": "Ferrari 488 GTB", "type": "Sports Car"},
    {"car": "Mercedes-Benz GLE", "type": "SUV"},
    {"car": "Nissan Altima", "type": "Sedan"},
    {"car": "Lamborghini Huracan", "type": "Sports Car"},
    {"car": "Audi Q5", "type": "SUV"},
    {"car": "Hyundai Sonata", "type": "Sedan"},
    {"car": "Chevrolet Corvette", "type": "Sports Car"},
    {"car": "Ford Explorer", "type": "SUV"},
    {"car": "Mazda6", "type": "Sedan"},
    {"car": "Aston Martin Vantage", "type": "Sports Car"},
    {"car": "Subaru Outback", "type": "SUV"},
    {"car": "Volkswagen Passat", "type": "Sedan"},
    {"car": "McLaren 720S", "type": "Sports Car"},
    {"car": "Volvo XC90", "type": "SUV"},
    {"car": "Kia Optima", "type": "Sedan"},
    {"car": "Jaguar F-Type", "type": "Sports Car"},
    {"car": "Land Rover Range Rover", "type": "SUV"},
    {"car": "Chrysler 300", "type": "Sedan"},
    {"car": "Tesla Model S", "type": "Electric"},
    {"car": "Tesla Model 3", "type": "Electric"},
    {"car": "Tesla Model X", "type": "Electric"},
    {"car": "Tesla Model Y", "type": "Electric"},
    {"car": "Acura MDX", "type": "SUV"},
    {"car": "Acura TLX", "type": "Sedan"},
    {"car": "Acura NSX", "type": "Sports Car"},
    {"car": "Buick Enclave", "type": "SUV"},
    {"car": "Buick Regal", "type": "Sedan"},
    {"car": "Chevrolet Blazer", "type": "SUV"},
    {"car": "Chevrolet Malibu", "type": "Sedan"},
    {"car": "Dodge Challenger", "type": "Sports Car"},
    {"car": "Dodge Durango", "type": "SUV"},
    {"car": "Fiat 500", "type": "Compact Car"},
    {"car": "Fiat 124 Spider", "type": "Sports Car"},
    {"car": "GMC Acadia", "type": "SUV"},
    {"car": "GMC Terrain", "type": "SUV"},
    {"car": "Honda CR-V", "type": "SUV"},
    {"car": "Honda Civic", "type": "Compact Car"},
    {"car": "Honda Fit", "type": "Subcompact Car"},
  ];
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _repassword = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _car = TextEditingController();
  GlobalKey<FormState> _formstate = GlobalKey();
  Map<String, String>? car;
  bool _isVisible1 = true;
  bool _isVisible2 = true;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 40),
                          child: Image.asset(
                            'assets/image/logo.png',
                            height: 50,
                          )),
                      Form(
                          key: _formstate,
                          child: Column(
                            children: [
                              Container(
                                child: const Text('Sign Up',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.orangeAccent)),
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(bottom: 20),
                              ),
                              Customtextfield(
                                label: ' Name',
                                hint: ' Name',
                                controller: _name,
                                validator: (p0) {
                                  if (p0!.isEmpty) return 'Required';
                                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(p0))
                                    return 'Can\'t Contain Characters or Numbers';
                                },
                              ),
                              Customtextfield(
                                label: ' Email',
                                hint: ' Email',
                                controller: _email,
                                validator: (p0) {
                                  if (p0!.isEmpty) return 'Required';
                                  if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(p0)) {
                                    return "Enter a valid email address";
                                  }
                                },
                              ),
                              Customtextfield(
                                label: ' Phone',
                                hint: ' Phone',
                                controller: _phone,
                                validator: (p0) {
                                  if (p0!.isEmpty) return 'Required';
                                  if (!RegExp(r'^\d+$').hasMatch(p0)) return "Enter a valid Phone Number";
                                    if(!p0.startsWith('010')&&!p0.startsWith('012')&& !p0.startsWith('011')&& !p0.startsWith('015')) return 'must start with valid code';
                                    if(  p0.length != 11) return 'Number must be 11';
                                },
                              ),

                              //----------------------------------------Start of Car DropDown menu---------------------------------------------------------
                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: DropdownMenu(
                                    menuStyle: MenuStyle(
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                    controller: _car,
                                    width: 370,
                                    inputDecorationTheme: InputDecorationTheme(
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orangeAccent),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    enableFilter: true,
                                    requestFocusOnTap: true,
                                    onSelected: (value) {
                                      setState(() {
                                        car=value;
                                      });
                                    },
                                    label: Text('Choose Your Car Model'),
                                    dropdownMenuEntries: carsList.map((e) {
                                      return DropdownMenuEntry(
                                          value: e, label: '${e['car']}');
                                    }).toList()),
                              ),

                              //------------------------------End CarDropDown Menu------------------------------------------------
                              Customtextfield(
                                validator: (p0) {
                                  if (p0!.isEmpty) return 'Required';
                                  if (!RegExp(
                                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$')
                                      .hasMatch(p0))
                                    return 'Enter a valid Password';
                                  //At least 8 characters long (.{8,})
                                  // Contains at least one lowercase letter ((?=.*[a-z]))
                                  // Contains at least one uppercase letter ((?=.*[A-Z]))
                                  // Contains at least one digit ((?=.*\d)
                                },
                                label: 'Password',
                                hint: 'Password',
                                isvisible: _isVisible1,
                                controller: _password,
                                prefiexicon: Icon(Icons.password),
                                suffixicon: IconButton(
                                    onPressed: () {
                                      _isVisible1 = !_isVisible1;
                                      setState(() {});
                                    },
                                    icon: _isVisible1
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.remove_red_eye)),
                              ),
                              Customtextfield(
                                validator: (p0) {
                                  if (p0!.isEmpty) return 'Required';
                                  if (_repassword.text != _password.text)
                                    return 'Password Dosen\'t match';
                                },
                                label: 'Retype Password',
                                hint: 'Retype Password',
                                controller: _repassword,
                                isvisible: _isVisible2,
                                prefiexicon: Icon(Icons.password),
                                suffixicon: IconButton(
                                    onPressed: () {
                                      _isVisible2 = !_isVisible2;
                                      setState(() {});
                                    },
                                    icon: _isVisible1
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.remove_red_eye)),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 40),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  onPressed: () async {
                                    if (_formstate.currentState!.validate())
                                      try {
                                        final credential = await FirebaseAuth
                                            .instance
                                            .createUserWithEmailAndPassword(
                                          email: _email.text,
                                          password: _password.text,
                                        );
                                        CurrentUser().addUser(
                                            _name.text,
                                            _email.text,
                                            _phone.text,
                                            'user',
                                            "no Address",
                                            car!['car']!,
                                            car!['type']!);
                                        isloading = true;
                                        // FirebaseAuth.instance.currentUser!
                                        //     .sendEmailVerification();
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    userRouting()));
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
                                        } else if (e.code ==
                                            'email-already-in-use') {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.info,
                                            animType: AnimType.rightSlide,
                                            title: 'Error',
                                            desc:
                                                'This Email is Already Registered',
                                            btnOkOnPress: () {
                                              // Navigator.of(context).pop();
                                            },
                                          )..show();
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                  },
                                  child: Text('Sign Up'),
                                  color: Colors.orangeAccent,
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ));
  }
}
