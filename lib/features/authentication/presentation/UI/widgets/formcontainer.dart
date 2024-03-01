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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        // border: Border.all(color: Color.fromARGB(255, 20, 19, 19)),
        border: Border.all(
            color: Color.fromARGB(255, 188, 187, 187)
                .withOpacity(0.5)), // Border color with adjusted opacity
        color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
        // Border color
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
          hintText: widget.hinttext,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 101, 100, 100),
            fontSize: 15,
          ),
          labelText: widget.labeltext, // Add labelText for better UX
          labelStyle: TextStyle(color: Colors.black), // Customize label color
          contentPadding: EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 12), // Adjust vertical position of hint text
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
