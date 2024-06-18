import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String weekDay;
  final double value;
  final double percentage;

  const ChartBar({
    required this.weekDay,
    required this.value,
    required this.percentage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constrains) {
      return Column(
        children: [
          Container(
            height: constrains.maxHeight * 0.15,
            child: FittedBox(
              child: Text('${value.toStringAsFixed(2)}'),
            ),
          ),
          SizedBox(
            height: constrains.maxHeight * 0.05,
          ),
          Container(
            width: 12,
            height: constrains.maxHeight * 0.6,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constrains.maxHeight * 0.05,
          ),
          Container(
            height: constrains.maxHeight * 0.15,
            child: FittedBox(
              child: Text(weekDay),
            ),
          ),
        ],
      );
    });
  }
}
