import 'package:flutter/material.dart';

class datePickerField extends StatefulWidget {
  final TextEditingController controller;
  DateTime? dateTime;

  datePickerField(
      {super.key, required this.controller, required this.dateTime});

  @override
  State<datePickerField> createState() => _datePickerFieldState();
}

class _datePickerFieldState extends State<datePickerField> {
  List<DateTime?> selecteDate = [
    DateTime.now(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      width: 350,
      child: TextField(
        onTap: () => openCalender(widget.controller),
        readOnly: true,
        canRequestFocus: false,
        controller: widget.controller,
        decoration: InputDecoration(
            hintText: 'Choose Date',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.black, width: 1))),
      ),
    );
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
      lastDate: DateTime(DateTime
          .now()
          .year + 1),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.orangeAccent,
            colorScheme: ColorScheme.light(primary: Colors.orangeAccent),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            // Additional styling options
          ),
          child: child!,
        );
      },
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
      else {
        setState(() {
          selecteDate[0] = pickedDate;
          controller.text = pickedDate.day.toString() +
              "/" +
              pickedDate.month.toString() +
              "/" +
              pickedDate.year.toString();
        });
      }
    }
  }
}
