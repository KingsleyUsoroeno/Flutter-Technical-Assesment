import 'package:flutter/material.dart';
import 'package:flutter_crypto_wallet/ui/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPress;
  final String text;
  final Color? backgroundColor, textColor;
  final double width, height;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPress,
    this.backgroundColor = AppColors.appBlue,
    this.height = 44.0,
    this.width = double.infinity,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: backgroundColor),
        child: GestureDetector(
          onTap: onPress,
          child: Center(
              child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 14.0),
          )),
        ),
      ),
    );
  }
}
