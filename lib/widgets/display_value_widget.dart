import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solar_cell_monitoring_app/utils/enum.dart';

class DisplayValueWidget extends HookWidget {
  final ValueType type;
  final String value;
  const DisplayValueWidget({
    Key? key,
    required this.type,
    required this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          type.toNameString(),
          style: const TextStyle(fontSize: 20),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: type.getColor(), borderRadius: BorderRadius.circular(8.0)),
          child: Column(children: [
            Text(
              value,
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
            Text(
              type.getUnitString(),
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
          ]),
        )
      ],
    );
  }
}
