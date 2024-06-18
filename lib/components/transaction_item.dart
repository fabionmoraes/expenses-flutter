import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    super.key,
    required this.tr,
    required this.onRemove,
  });

  final Transaction tr;
  final void Function(String p1) onRemove;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  static const colors = [
    Colors.amber,
    Colors.blue,
    Colors.orange,
    Colors.red,
    Colors.purple,
  ];

  Color _backgroundColor = Colors.amber;

  @override
  void initState() {
    super.initState();

    int getColor = Random().nextInt(5);

    _backgroundColor = colors[getColor];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _backgroundColor,
          foregroundColor: Colors.white,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('R\$ ${widget.tr.value}'),
            ),
          ),
        ),
        title: Text(
          widget.tr.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          DateFormat('d MMM y').format(widget.tr.date),
        ),
        trailing: MediaQuery.of(context).size.width > 480
            ? TextButton.icon(
                onPressed: () => widget.onRemove(widget.tr.id),
                label: const Text('Excluir'),
                icon: const Icon(Icons.delete),
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(Colors.red),
                ),
              )
            : IconButton(
                onPressed: () => widget.onRemove(widget.tr.id),
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ),
      ),
    );
  }
}
