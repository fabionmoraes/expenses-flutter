import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdaptiveDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChaged;

  const AdaptiveDatePicker({
    required this.selectedDate,
    required this.onDateChaged,
    super.key,
  });

  _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      onDateChaged(pickedDate);
    });
  }

  Widget get resultDateSelected {
    if (selectedDate == null) {
      return Text('Nenhuma data selecionada');
    }

    return Text(
      'Data selecionada: ${DateFormat('dd/MM/yy').format(selectedDate)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Container(
            height: 180,
            child: CupertinoDatePicker(
              onDateTimeChanged: onDateChaged,
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              minimumDate: DateTime(2019),
              maximumDate: DateTime.now(),
            ),
          )
        : Container(
            height: 70,
            child: Row(
              children: [
                Expanded(child: resultDateSelected),
                TextButton(
                  onPressed: () => _showDatePicker(context),
                  child: Text('Selecionar data'),
                  style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(
                        Theme.of(context).primaryColor,
                      ),
                      textStyle: WidgetStateProperty.all(
                        TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                )
              ],
            ),
          );
  }
}
