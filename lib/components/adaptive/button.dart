import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const AdaptiveButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(label),
            onPressed: onPressed,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            child: Text(label),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.white),
              backgroundColor: WidgetStateProperty.all(Colors.purple),
            ));
  }
}
