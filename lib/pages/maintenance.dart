import 'package:abatiy/Classes/ShoppingCart.dart';
import 'package:abatiy/customes/buildCart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Classes/service.dart';
import '../customes/FloatinglabelTextField.dart';

class maintenance extends StatefulWidget {
  @override
  State<maintenance> createState() => _maintenanceState();
}

List<String> services = [
  'Cleaning',
  'Oil Change',
  'Car Check',
  'Tire Change',
  'Upgrading',
  'Else',
];
List<String> Cleaning = [
  'Mohamed ',
  'Morsy',
  'Motaz',
  'Mostafa',
  'Mansour',
];
List<String> OilChange = [
  'Ahmed',
  'Asmaa',
  'Azhar',
  'Amira',
  'Amal',
];
TextEditingController _servicetxt =
    TextEditingController(text: 'Choose a Service');
TextEditingController _DateController =
    TextEditingController(text: 'Select The Date');
TextEditingController _choose = TextEditingController();
TextEditingController _notes = TextEditingController();
TextEditingController _garage =
    TextEditingController(text: 'Select the garage');
String service = '';
String Garage = '';
String date = '';

List<DateTime?> selecteDate = [
  DateTime.now(),
];

class _maintenanceState extends State<maintenance> {
  GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final shopCart = Provider.of<ShoppingCart>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [shoppingCart()],
      ),
      key: _scaffoldstate,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: ListView(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(
                  'Services',
                  style: Theme.of(context).textTheme.headline1,
                )),
            SizedBox(
              height: 20,
            ),
            Form(
                child: Column(
              children: [
                FloatingTextField(
                  hinttext: _servicetxt.text,
                  onTap: () => showBottomUp(services, _servicetxt),
                  label: 'Choose a Service',
                  controller: _servicetxt,
                ),
                SizedBox(
                  height: 20,
                ),
                FloatingTextField(
                  hinttext: _servicetxt.text,
                  label: 'Choose Garage',
                  controller: _garage,
                  onTap: () => availablegarage(),
                ),
                SizedBox(
                  height: 20,
                ),
                FloatingTextField(
                  hinttext: _servicetxt.text,
                  label: 'Choose Date',
                  controller: _DateController,
                  onTap: () => openCalender(_DateController),
                ),
                SizedBox(height: 20),
                FloatingTextField(
                    label: 'Notes',
                    controller: _notes,
                    hinttext: 'Notes',
                    enable: true,
                    padding:
                        EdgeInsets.symmetric(vertical: 40, horizontal: 20)),
                SizedBox(height: 20),
                MaterialButton(
                  color: Colors.orangeAccent,
                  onPressed: () {
                    if (_servicetxt.text != 'Choose a Service' &&
                        _garage.text != 'Select The garage' &&
                        _DateController.text != 'Select The Date') {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Done'),
                              content: Text('Added to Cart'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Ok'))
                              ],
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('You Must fill all The boxes'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Ok'))
                              ],
                            );
                          });
                    }
                  },
                  child: Text("Submit"),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    shape: CircleBorder(),
                    backgroundColor: Colors.orangeAccent,
                    onPressed: () {
                      Services().addService('Oil Change', 1000, '500');
                      print('Siiiiiiiiiiiiu');
                      setState(() {});
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }

  void openCalender(TextEditingController controller) async {
    if (_servicetxt.text == 'Choose a Service' ||
        _garage.text == 'Select the garage') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please Check the other boxes."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selecteDate[0] ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null && pickedDate != selecteDate[0]) {
      if (pickedDate.isBefore(DateTime.now()))
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Invalid Date"),
              content: Text("Please choose a Valid Date."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      else
        setState(() {
          selecteDate[0] = pickedDate;
          controller.text = pickedDate.day.toString() +
              "/" +
              pickedDate.month.toString() +
              "/" +
              pickedDate.year.toString();
          date = controller.text;
          print(controller.text);
          print(selecteDate);
        });
    }
  }

  void showBottomUp(List<String> values, TextEditingController controller) {
    setState(() {
      _scaffoldstate.currentState!.showBottomSheet(
          backgroundColor: Color(0x0000FF00),
          // Fully transparent red
          (context) => Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.only(top: 150, left: 10, right: 10),
              width: double.maxFinite,
              height: 450,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  itemCount: values.length,
                  itemBuilder: (context, i) {
                    return Card(
                      child: ListTile(
                          onTap: () {
                            service = values[i];
                            controller.text = values[i];
                            Navigator.of(context).pop();
                          },
                          trailing: Icon(Icons.wash),
                          contentPadding: EdgeInsets.all(4),
                          title: Text(
                            values[i],
                            textAlign: TextAlign.left,
                          )),
                      color: Colors.grey[300],
                    );
                  })));
    });
  }

  void availablegarage() async {
    if (_servicetxt.text == 'Choose a Service') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please choose a Service'),
              actions: [
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("ok"),
                )
              ],
            );
          });
    } else
      switch (_servicetxt.text) {
        case 'Cleaning':
          showBottomUp(Cleaning, _garage);
        case 'Oil Change':
          showBottomUp(OilChange, _garage);
        default:
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('No Available garage for This Services'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Ok'))
                  ],
                );
              });
      }
  }
}
