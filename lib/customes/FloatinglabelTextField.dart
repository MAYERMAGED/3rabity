import 'package:abatiy/pages/cartView.dart';
import 'package:flutter/material.dart';

class FloatingTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final String hinttext;
  EdgeInsets? padding;
  bool? enable;

  FloatingTextField(
      {required this.label,
      required this.controller,
      this.onTap,
      required this.hinttext,
      this.enable,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: onTap,
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding: padding ?? null,
                hintText: hinttext,
                enabled: enable ?? false,
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}