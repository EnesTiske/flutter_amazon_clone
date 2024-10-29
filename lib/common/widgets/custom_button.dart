import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: color == null ? GlobalVariables.secondaryColor : color,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color == null ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
