import 'package:flutter/material.dart';

class Customtextfield extends StatelessWidget {
  const Customtextfield(
      {super.key,
        required this.label,
        required this.hint,
        required this.controller,
        this.isvisible,
        this.validator,
        this.prefiexicon,
        this.suffixicon});

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? prefiexicon;
  final Widget? suffixicon;
  final bool? isvisible;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: TextFormField(
          expands: false,
          obscureText: isvisible ?? false,
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
              enabled: true,
              floatingLabelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.orangeAccent)),
              suffixIcon: suffixicon ?? null,
              prefixIcon: prefiexicon ?? null,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              labelText: '$label',
              hintText: '$hint')),
    );
    throw UnimplementedError();
  }
}
