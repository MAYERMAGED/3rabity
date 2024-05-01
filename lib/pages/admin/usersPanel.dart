import 'package:abatiy/Classes/User.dart';
import 'package:flutter/material.dart';


class usersPanel extends StatefulWidget {
  @override
  State<usersPanel> createState() => _usersPanelState();
}

class _usersPanelState extends State<usersPanel> {
  GlobalKey<FormState> _formState = GlobalKey();

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _pass = TextEditingController();
  String? Type;
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: Image.asset('assets/image/logo.png', width: 220),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  isEditable = !isEditable;
                  setState(() {});
                },
                icon: isEditable? const Icon(
                  Icons.cancel_outlined,
                  size: 25,
                  color: Colors.black,
                ): const Icon(
                  Icons.edit,
                  size: 25,
                  color: Colors.black,
                ))
          ],
        ),
        body: FutureBuilder<List<CurrentUser>>(
          future: CurrentUser().getAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('The error is ${snapshot.error}'),
              );
            } else {
              List<CurrentUser>? users = snapshot.data;
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                        itemCount: users!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete'),
                                      content: Text(
                                          'Are You Sure you want to Delete this User ?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              CurrentUser().deleteUser(
                                                  '${users[index].id}');
                                              setState(() {});
                                            },
                                            child: Text('Delete')),
                                      ],
                                    );
                                  });
                            },
                            child: Card(
                              color: Colors.grey[200],
                              child: ListTile(
                                minVerticalPadding: 40,
                                leading: Image.asset('assets/image/logo.png',
                                    width: 75, fit: BoxFit.cover),
                                title: Text('${users[index].name}'),
                                subtitle: Text(
                                    '${users[index].email} \n ${users[index].phone}'),
                                trailing: isEditable
                                    ? Container(
                                        height: 50,
                                        width: 90,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                              hintText: '${users[index].type}'),
                                          items: const [
                                            DropdownMenuItem(
                                                value: 'user',
                                                child: Text('user')),
                                            DropdownMenuItem(
                                                value: 'admin',
                                                child: Text('admin')),
                                            DropdownMenuItem(
                                                value: 'provider',
                                                child: Text('provider')),
                                          ],
                                          onChanged: (value) {
                                            CurrentUser().updatedType(value!,users[index].id!);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    content: Text(
                                                        'Updated Successfully')));
                                          },
                                        ),
                                      )
                                    : Text('${users[index].type}'),
                              ),
                            ),
                          );
                        },
                      ))
                    ],
                  ),
                  Positioned(
                      bottom: 20,
                      right: 15,
                      child: FloatingActionButton(
                        shape: CircleBorder(),
                        backgroundColor: Colors.orangeAccent,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Enter The data'),
                                  content: SingleChildScrollView(
                                    child: Container(
                                      height: 430,
                                      width: 300,
                                      child: Form(
                                          key: _formState,
                                          child: Column(
                                            children: [
                                              DropdownButtonFormField(
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Required';
                                                  }
                                                },
                                                decoration: const InputDecoration(
                                                    hintText: 'Type'),
                                                items: const [
                                                  DropdownMenuItem(
                                                      value: 'user',
                                                      child: Text('user')),
                                                  DropdownMenuItem(
                                                      value: 'admin',
                                                      child: Text('admin')),
                                                  DropdownMenuItem(
                                                      value: 'provider',
                                                      child: Text('provider')),
                                                ],
                                                onChanged: (value) {
                                                  Type = value;
                                                },
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: _name,
                                                decoration: InputDecoration(
                                                    hintText: 'Name',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8))),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: _email,
                                                decoration: InputDecoration(
                                                    hintText: 'email',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8))),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: _phone,
                                                decoration: InputDecoration(
                                                    hintText: 'phone',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8))),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: _pass,
                                                decoration: InputDecoration(
                                                    hintText: 'pass',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8))),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: _address,
                                                decoration: InputDecoration(
                                                    hintText: 'address',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8))),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel')),
                                    // TextButton(
                                    //     onPressed: () {
                                    //       if(_formState.currentState!.validate())
                                    //       Navigator.of(context).pop();
                                    //       CurrentUser().addUser(
                                    //           _name.text,
                                    //           _email.text,
                                    //           _phone.text,
                                    //           Type!,
                                    //           _address.text,
                                    //           _pass.text);
                                    //       setState(() {});
                                    //     },
                                    //     child: Text('Add')),
                                  ],
                                );
                              });
                        },
                        child: const Icon(Icons.add),
                      )),
                  // MaterialButton(onPressed: (){
                  //   print("${FirebaseAuth.instance.currentUser}");
                  //   print("${FirebaseAuth.instance.currentUser!.uid}");
                  // },child: Text('print'),)
                ],
              );
            }
          },
        ));
    
  }
}
