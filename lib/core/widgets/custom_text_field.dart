import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
   const CustomTextFormField(
      {super.key,
      required this.labelText,
      this.controller,
      this.onFieldSubmitted,
      this.suffixIcon,
      this.obscureText,
      this.validator,
      required this.keyboardType,
      this.inputFormatters});

  final String labelText;

  final Function(String)? onFieldSubmitted;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8, top: 24),
      child: TextFormField(
        inputFormatters: inputFormatters,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        validator: validator,
        keyboardType: keyboardType,

        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          suffixIconColor: AppColors.darkJungleGreen,
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
          border: getBorderStyle(),
          enabledBorder: getBorderStyle(),
          focusedBorder: getBorderStyle(),
        ),
      ),
    );
  }
}

OutlineInputBorder getBorderStyle() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: Colors.blue,
    ),
  );
}
