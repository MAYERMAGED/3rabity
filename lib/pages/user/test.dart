import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Test(),
    ));

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

bool validateuser(
    List<Map<String, String>> test, String mail, String password) {
  for (var user in test) {
    if (user['mail'] == mail && user['pass'] == password) {
      return true;
    }
  }
  return false;
}

class _TestState extends State<Test> {
  List<Map<String, String>> users = [
    {'mail': 'mohamedfarouk@gmail.com', 'pass': '12345678'},
    {'mail': 'aboseif@gmail.com', 'pass': '12345678'},
    {'mail': 'admin', 'pass': 'admin1'},
    {'mail': 'admin2', 'pass': 'admin2'}
  ];
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  GlobalKey<FormState> secondkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Container(
          margin: EdgeInsets.all(30),
          child: ListView(children: [
            Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 340)),
                Form(
                  key: formstate,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) return 'Required';
                          if (!validateuser(users, emailController.text,
                              passwordController.text)) return 'Check Email';
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white54,
                            labelText: 'Email',
                            hintText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) return 'Required';
                            if (!validateuser(users, emailController.text,
                                passwordController.text))
                              return 'Check password';
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white54,
                              filled: true,
                              labelText: 'Passowrd',
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)))),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        color: Colors.white54,
                        onPressed: () {
                          if (formstate.currentState!.validate()) {

                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Text(
                          'Forget Password?',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
