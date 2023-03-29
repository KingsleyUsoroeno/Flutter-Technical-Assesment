import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/ui/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? errorText;
  final Widget? suffixIcon;
  final String? label;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    this.errorText,
    this.suffixIcon,
    this.label,
    this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.isNotEmpty) Text(label!),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            errorStyle: const TextStyle(fontSize: 0.01, height: 0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: errorText == null ? AppColors.white400 : Colors.red,
                  width: errorText == null ? 1 : 2),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: errorText == null ? AppColors.white400 : Colors.red,
                  width: errorText == null ? 1 : 2),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: errorText == null ? AppColors.white400 : Colors.red,
                  width: errorText == null ? 1 : 2),
              borderRadius: BorderRadius.circular(8),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: errorText == null ? AppColors.white400 : Colors.red,
                  width: errorText == null ? 1 : 2),
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
