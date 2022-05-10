import 'package:another_flushbar/flushbar_helper.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:solar_cell_monitoring_app/utils/enum.dart';

import '../models/sensor_value.dart';

Future<bool> checkInternetConnection(BuildContext context) async {
  bool result = await InternetConnectionChecker().hasConnection;
  if (!result) {
    FlushbarHelper.createError(message: 'ไม่มีการเชื่อมต่ออินเทอร์เน็ต')
        .show(context);
  }
  return result;
}

double getSensorValueByValueType(
  SensorValue value,
  ValueType type,
) {
  switch (type) {
    case ValueType.light:
      return value.light;
    case ValueType.humid:
      return value.humid;
    case ValueType.temperature:
      return value.temperature;
    case ValueType.voltage:
      return value.voltage;
    case ValueType.current:
      return value.current;
  }
}
