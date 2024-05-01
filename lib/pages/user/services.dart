import 'package:abatiy/Classes/User.dart';
import 'package:abatiy/Classes/reservation.dart';
import 'package:abatiy/Classes/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class servicesPage extends StatefulWidget {
  @override
  State<servicesPage> createState() => _servicesPageState();
}

class _servicesPageState extends State<servicesPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _service = TextEditingController();
  TextEditingController _garage = TextEditingController();

  List<String> _services = [
    'Cleaning',
    'Oil Change',
    'Car Check',
    'Tire Change',
    'Upgrading',
    'Else',
  ];

  List<DateTime?> selecteDate = [
    DateTime.now(),
  ];
  GlobalKey<ScaffoldState> _key = GlobalKey();

  String? _selectedService;
  String? _providerId;
  String? reservedTime;
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(
            'Services',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
        ),
        body: FutureBuilder<List<CurrentUser>>(
          future: CurrentUser().getUsersByType('provider'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (snapshot.hasError)
              return Center(
                child: Text('Error  : ${snapshot.error}'),
              );
            else {
              List<CurrentUser> _currentProviders = snapshot.data!;
              List<Services> _currentProviderServices;
              return Container(
                margin: EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Book a Service',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 50, bottom: 10),
                      child: DropdownMenu(
                          controller: _service,
                          width: 350,
                          onSelected: (value) => _selectedService = value,
                          label: Text('Choose a service'),
                          dropdownMenuEntries: List.generate(
                              _services.length,
                              (index) => DropdownMenuEntry(
                                  value: '${_services[index]}',
                                  label: '${_services[index]}'))),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 20, bottom: 30),
                      child: DropdownMenu(
                          controller: _garage,
                          width: 350,
                          onSelected: (value) => _providerId = value,
                          label: Text('Choose the Garage'),
                          dropdownMenuEntries: List.generate(
                              _currentProviders.length,
                              (index) => DropdownMenuEntry(
                                  value: '${_currentProviders[index].id}',
                                  label: '${_currentProviders[index].name}'))),
                    ),
                    // ---------------------Date Picker---------------------------
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      width: 350,
                      child: TextField(
                        onTap: () {
                          openCalender(_dateController);
                        },
                        readOnly: true,
                        canRequestFocus: false,
                        controller: _dateController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  if (_dateTime == null ||
                                      _providerId == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Please fill other Boxes'),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else
                                    showTime(_dateTime!, _providerId!);
                                },
                                icon: Icon(Icons.timer)),
                            hintText: 'Choose Date',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1))),
                      ),
                    ),
                    //--------------------End of Date Picker---------------------------------
                    SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (_providerId == null ||
                              _selectedService == null ||
                              _dateTime == null ||
                              reservedTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please Fill all the Fields'),
                              backgroundColor: Colors.red,
                            ));
                          } else {
                            reservation().addReservation(_providerId!,
                                _selectedService!, _dateTime!, reservedTime!);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Reservation Completed'),
                              backgroundColor: Colors.green,
                            ));
                            setState(() {
                              _dateController.clear();
                              _service.clear();
                              _garage.clear();
                              _dateTime = null;
                              _selectedService = null;
                              _providerId = null;
                              reservedTime = null;
                            });
                          }
                        },
                        child: Text('Reserve Now'))
                  ],
                ),
              );
            }
          },
        ));
  }

  void openCalender(TextEditingController controller) async {
    // if (_servicetxt.text == 'Choose a Service' ||
    //     _garage.text == 'Select the garage') {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text("Error"),
    //         content: Text("Please Check the other boxes."),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: Text("OK"),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return;
    // }
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selecteDate[0] ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) {
        return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Colors.orangeAccent,
              colorScheme: ColorScheme.light(primary: Colors.orangeAccent),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
              // Additional styling options
            ),
            child: child!);
      },
    );

    if (pickedDate != null) {
      setState(() {
        print(pickedDate);
        selecteDate[0] = pickedDate;
        controller.text = pickedDate.day.toString() +
            "/" +
            pickedDate.month.toString() +
            "/" +
            pickedDate.year.toString();
        _dateTime = pickedDate;
        if (_providerId != null)
          showTime(pickedDate, _providerId!);
        else
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please choose a garage First'),
            backgroundColor: Colors.red,
          ));
      });
    }
  }

  void showTime(DateTime Date, String providerId) {
    _key.currentState!.showBottomSheet(backgroundColor: Colors.orangeAccent,
        (context) {
      return Container(
        height: 200,
        child: FutureBuilder<List<String>>(
          future: reservation().getSelectedTime(Date,providerId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (snapshot.hasError)
              return Center(
                child: Text('Error is dfsfsd :${snapshot.error}'),
              );
            else {
              if (snapshot.data == null || snapshot.data!.isEmpty)
                return Center(
                  child: Text(
                    'No available Time for This Day',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                );
              else {
                List<String> _avilableTime = snapshot.data!;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 16),
                    Container(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _avilableTime.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: ElevatedButton(
                              onPressed: () {
                                reservedTime = _avilableTime[index];
                                _dateController.text +=
                                    "            ${reservedTime}";
                                Navigator.of(context).pop();
                              },
                              child: Text('${_avilableTime[index]}'),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              }
            }
          },
        ),
      );
    });
  }
}
