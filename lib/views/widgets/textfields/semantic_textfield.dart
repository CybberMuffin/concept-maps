import 'package:concept_maps/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SemanticTextField extends StatelessWidget {
  final String label;
  final void Function(String) onChanged;
  final String Function(String) validator;
  final String initialValue;
  final TextInputType keyboardType;
  final bool requiredToFill;
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatter;
  final bool obscureText;

  const SemanticTextField({
    Key key,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.label,
    this.keyboardType,
    this.requiredToFill = false,
    this.controller,
    this.inputFormatter,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: TextFormField(
        style: TextStyle(
          color: kText,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label + (requiredToFill ? "*" : ""),
          labelStyle: TextStyle(
            color: kBreezeColor,
          ),
          border: UnderlineInputBorder(borderSide: BorderSide(color: kBreezeColor)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kBreezeColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kBreezeColor),
          ),
          contentPadding: EdgeInsets.all(5),
        ),
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: this.inputFormatter,
        initialValue: initialValue,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
      ),
    );
  }
}
