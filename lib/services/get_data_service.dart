import 'dart:convert';

import 'package:solar_cell_monitoring_app/models/sensor_value.dart';
import 'package:solar_cell_monitoring_app/utils/constant.dart';
import 'package:solar_cell_monitoring_app/utils/environment.dart';
import 'package:http/http.dart' as http;

class GetDataService {
  final _uri = Uri(
    scheme: baseSchema,
    host: baseHost,
    port: basePort,
  );
  final http.Client _httpClient = http.Client();
  static GetDataService? _instance;

  GetDataService._();

  static GetDataService instance() {
    return _instance ??= GetDataService._();
  }

  Future<List<SensorValue>> getByDate(
      String date, String month, String year) async {
    final queryParams = {
      'date': date,
      'month': month,
      'year': year,
    };
    final uri = _uri.replace(path: getByDatePath, queryParameters: queryParams);
    final result = await http.get(uri);
    print('status:${result.reasonPhrase}');
    print('body: ${result.body}');
    print('result.statusCode: ${result.statusCode}');
    if (result.statusCode == 503) {
      throw ServiceNotAvailable('เซิร์ฟเวอร์ไม่พร้อมใช้งาน');
    }
    return (jsonDecode(utf8.decode(result.bodyBytes)) as List)
        .map((e) => SensorValue.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<SensorValue>> getByMonth(String month, String year) async {
    final queryParams = {
      'month': month,
      'year': year,
    };
    final uri =
        _uri.replace(path: getByMonthPath, queryParameters: queryParams);
    final result = await http.get(uri);
    print('status:${result.reasonPhrase}');
    print('body: ${result.body}');
    print('result.statusCode: ${result.statusCode}');
    if (result.statusCode == 503) {
      throw ServiceNotAvailable('เซิร์ฟเวอร์ไม่พร้อมใช้งาน');
    }
    return (jsonDecode(utf8.decode(result.bodyBytes)) as List)
        .map((e) => SensorValue.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<bool> forceUpdate() async {
    final uri = _uri.replace(
      path: forceUpdatePath,
    );

    final result = await http.put(uri);
    print('status:${result.reasonPhrase}');
    print('body: ${result.body}');
    print('result.statusCode: ${result.statusCode}');
    if (result.statusCode == 503) {
      throw ServiceNotAvailable('เซิร์ฟเวอร์ไม่พร้อมใช้งาน');
    }
    return utf8.decode(result.bodyBytes) == 'true';
  }
}
