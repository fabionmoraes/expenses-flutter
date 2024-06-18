import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final void Function() onSubmitted;
  final String label;

  const AdaptiveTextField({
    this.keyboardType,
    required this.controller,
    required this.onSubmitted,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: EdgeInsets.only(
              bottom: 10,
            ),
            child: CupertinoTextField(
              controller: controller,
              keyboardType: keyboardType,
              onSubmitted: (_) => onSubmitted(),
              placeholder: label,
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
            ),
          )
        : TextField(
            keyboardType: keyboardType,
            onSubmitted: (_) => onSubmitted(),
            controller: controller,
            decoration: InputDecoration(labelText: label),
          );
  }
}
