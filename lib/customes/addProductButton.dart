import 'package:abatiy/pages/Store.dart';
import 'package:flutter/material.dart';

import '../Classes/Product.dart';

class addProductButton extends StatefulWidget {
  GlobalKey<ScaffoldState> globalKey = GlobalKey();

  @override
  State<addProductButton> createState() => _addProductButtonState();

  addProductButton({super.key, required this.globalKey});
}

class _addProductButtonState extends State<addProductButton> {
  GlobalKey<FormState> _formState = GlobalKey();

  TextEditingController _title = TextEditingController();
  TextEditingController _subtitle = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _categorie = TextEditingController();

  final List<String> _categories = [
    'Interior Accessories',
    'Exterior Accessories',
    'Performance Accessories',
    'Electronics and Technology',
    'Safety Accessories'
  ];

  bool ispressed = false;

  String? imgUrl;

  bool isUploaded = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: CircleBorder(),
      backgroundColor: Colors.orangeAccent,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('New Product Data'),
              content: SingleChildScrollView(
                child: Container(
                  height: 500,
                  width: 300,
                  child: Form(
                    key: _formState,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: imgUrl != null
                              ? () {
                                  // Handle button click when image is loaded
                                }
                              : null,
                          child: FutureBuilder<String>(
                            future: Product().getImage(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Show loading indicator while waiting for the image
                              } else if (snapshot.hasError) {
                                return Text(
                                    'Error loading image'); // Show an error message if image loading fails
                              } else {
                                imgUrl = snapshot.data;
                                isUploaded = imgUrl != null;
                                return Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  height: 130,
                                  width: 250,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage('${imgUrl}'))),
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          width: 300,
                          child: DropdownMenu(
                              controller: _categorie,
                              width: 280,
                              onSelected: (value) =>
                                  _categorie.text = value.toString(),
                              label: Text('Choose a Categorie'),
                              dropdownMenuEntries: List.generate(
                                  5,
                                  (index) => DropdownMenuEntry(
                                      value: '${_categories[index]}',
                                      label: '${_categories[index]}'))),
                        ),
                        TextFormField(
                          controller: _title,
                          validator: (value) {
                            if (value!.isEmpty) return 'Required';
                            if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value))
                              return 'Can\'t Contain Characters or Numbers';
                          },
                          decoration: InputDecoration(
                            hintText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _subtitle,
                          validator: (value) {
                            if (value!.isEmpty) return 'Required';
                            if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value))
                              return 'Can\'t Contain Characters or Numbers';
                          },
                          decoration: InputDecoration(
                            hintText: 'Subtitle',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _price,
                          validator: (value) {
                            if (value!.isEmpty) return 'Required';
                            if (!RegExp(r'^\d+$').hasMatch(value))
                              return 'Enter a Valid Number';
                          },
                          decoration: InputDecoration(
                            hintText: 'Price',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _description,
                          validator: (value) {
                            if (value!.isEmpty) return 'Required';
                          },
                          decoration: InputDecoration(
                            hintText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formState.currentState!.validate()) {
                      if (imgUrl != null) {
                        Navigator.of(context).pop();
                        Product().addProduct(
                          _title.text,
                          _subtitle.text,
                          _description.text,
                          int.parse(_price.text),
                          _categorie.text,
                          imgUrl!,
                        );
                        ScaffoldMessenger.of(widget.globalKey.currentContext!).showSnackBar(SnackBar(
                          content: Text('Product Added successfully'),
                          backgroundColor: Colors.green,
                        ));
                      }else {
                        ScaffoldMessenger.of(widget.globalKey.currentContext!).showSnackBar(SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text('Please Wait for the image to upload'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
    throw UnimplementedError();
  }
}
