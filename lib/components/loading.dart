import 'package:chatify/constants/colors.dart';
import 'package:flutter/material.dart';

class MyLoading extends StatelessWidget {
  const MyLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: MyColors.primaryColor,
          strokeWidth: 4,
        ));
  }
}
