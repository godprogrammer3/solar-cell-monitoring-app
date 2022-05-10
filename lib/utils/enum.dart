import 'package:flutter/material.dart';

enum ValueType { light, humid, temperature, voltage, current }

extension ValueTypeExtension on ValueType {
  String toNameString() {
    switch (this) {
      case ValueType.light:
        return 'ค่าความเข้มแสง';
      case ValueType.humid:
        return 'ค่าความชื้น';
      case ValueType.temperature:
        return 'ค่าอุณหภูมิ';
      case ValueType.voltage:
        return 'ค่าความต่างศักย์ไฟฟ้า';
      case ValueType.current:
        return 'ค่ากระแสไฟฟ้า';
    }
  }

  Color getColor() {
    switch (this) {
      case ValueType.light:
        return Colors.brown;
      case ValueType.humid:
        return Colors.green;
      case ValueType.temperature:
        return Colors.orange;
      case ValueType.voltage:
        return Colors.red;
      case ValueType.current:
        return Colors.purple;
    }
  }

  String getUnitString() {
    switch (this) {
      case ValueType.light:
        return 'ลักซ์';
      case ValueType.humid:
        return 'เปอร์เซ็น';
      case ValueType.temperature:
        return 'เซลเซียส';
      case ValueType.voltage:
        return 'โวลต์';
      case ValueType.current:
        return 'แอมป์';
    }
  }
}
