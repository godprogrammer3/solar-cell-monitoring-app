class SensorValue {
  final double light;
  final double temperature;
  final double humid;
  final double voltage;
  final double current;
  final DateTime timeStamp;
  final int id;
  SensorValue({
    required this.light,
    required this.temperature,
    required this.humid,
    required this.voltage,
    required this.current,
    required this.timeStamp,
    required this.id,
  });

  factory SensorValue.fromJson(Map<String, dynamic> json) {
    return SensorValue(
      light: double.parse(json['light'].toString()),
      temperature: double.parse(json['temperature'].toString()),
      humid: double.parse(json['humid'].toString()),
      voltage: double.parse(json['voltage'].toString()),
      current: double.parse(json['current'].toString()),
      timeStamp: DateTime.parse(json['time_stamp']),
      id: json['id'] as int,
    );
  }
}
