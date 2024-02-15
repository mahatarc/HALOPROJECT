import 'package:flutter/material.dart';

class Formcontainerwidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String? hinttext;
  final String? labeltext;
  final String? helpertext;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;
  final double borderRadius; // Added parameter

  const Formcontainerwidget({
    this.controller,
    this.isPasswordField,
    this.fieldKey,
    this.hinttext,
    this.labeltext,
    this.helpertext,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.inputType,
    required this.borderRadius, // Required parameter
  });

  @override
  _FormcontainerwidgetState createState() => _FormcontainerwidgetState();
}

class _FormcontainerwidgetState extends State<Formcontainerwidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.grey,
        borderRadius:
            BorderRadius.circular(widget.borderRadius), // Use borderRadius here
      ),
      child: TextFormField(
        style: const TextStyle(color: Colors.black45),
        controller: widget.controller,
        keyboardType: widget.inputType,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField == true ? _obscureText : false,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          hintText: widget.hinttext,
          hintStyle: const TextStyle(color: Colors.black),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: widget.isPasswordField == true
                ? Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: _obscureText == false ? Colors.black : Colors.black,
                  )
                : const Text(""),
          ),
        ),
      ),
    );
  }
}
