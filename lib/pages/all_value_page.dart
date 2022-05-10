import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:solar_cell_monitoring_app/models/sensor_value.dart';
import 'package:solar_cell_monitoring_app/pages/all_graph_page.dart';
import 'package:solar_cell_monitoring_app/pages/single_graph_page.dart';
import 'package:solar_cell_monitoring_app/services/get_data_service.dart';
import 'package:solar_cell_monitoring_app/utils/constant.dart';
import 'package:solar_cell_monitoring_app/utils/enum.dart';
import 'package:solar_cell_monitoring_app/widgets/display_value_widget.dart';

import '../utils/helper.dart';

class AllValuePage extends HookWidget {
  const AllValuePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final sensorValue = useState<SensorValue?>(null);
    final isLoading = useState(false);
    final getDataService = GetDataService.instance();
    useEffect(() {
      Future<void>.microtask(() async {
        isLoading.value = true;
        if (!await checkInternetConnection(context)) {
          isLoading.value = false;
          return;
        }
        try {
          await getDataService.forceUpdate();
        } on ServiceNotAvailable catch (error) {
          FlushbarHelper.createError(
                  message: 'ระบบเกิดข้อผิดพลาดในการอัพเดตค่า ' + error.message)
              .show(context);
        } catch (error) {
          FlushbarHelper.createError(
                  message: 'ระบบเกิดข้อผิดพลาดในการอัพเดตค่า โปรดลองอีกครั้ง')
              .show(context);
        }
        try {
          final getCurrentDate = DateTime.now();
          final results = await getDataService.getByDate(
              getCurrentDate.day.toString(),
              getCurrentDate.month.toString(),
              getCurrentDate.year.toString());
          results.sort((a, b) => a.id.compareTo(b.id));
          print('results: $results');
          if (results.isNotEmpty) {
            sensorValue.value = results[results.length - 1];
          }
        } on ServiceNotAvailable catch (error) {
          FlushbarHelper.createError(message: error.message).show(context);
        } catch (error) {
          print('error: $error');
          FlushbarHelper.createError(
                  message: 'ระบบเกิดข้อผิดพลาด โปรดลองอีกครั้ง')
              .show(context);
        } finally {
          isLoading.value = false;
        }
      });

      return null;
    }, []);
    return LoadingOverlayPro(
      isLoading: isLoading.value,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ค่าข้อมูลทั้งหมด'),
        ),
        body: Center(
            child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: DisplayValueWidget(
                        type: ValueType.light,
                        value: sensorValue.value != null
                            ? sensorValue.value!.light.toString()
                            : 'N/A'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: DisplayValueWidget(
                        type: ValueType.humid,
                        value: sensorValue.value != null
                            ? sensorValue.value!.humid.toString()
                            : 'N/A'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: DisplayValueWidget(
                        type: ValueType.temperature,
                        value: sensorValue.value != null
                            ? sensorValue.value!.temperature.toString()
                            : 'N/A'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: DisplayValueWidget(
                        type: ValueType.current,
                        value: sensorValue.value != null
                            ? sensorValue.value!.current.toString()
                            : 'N/A'),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: screenSize.width * 0.7,
              child: DisplayValueWidget(
                  type: ValueType.voltage,
                  value: sensorValue.value != null
                      ? sensorValue.value!.voltage.toString()
                      : 'N/A'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  isLoading.value = true;
                  if (!await checkInternetConnection(context)) {
                    isLoading.value = false;
                    return;
                  }
                  try {
                    await getDataService.forceUpdate();
                  } on ServiceNotAvailable catch (error) {
                    FlushbarHelper.createError(
                            message: 'ระบบเกิดข้อผิดพลาดในการอัพเดตค่า ' +
                                error.message)
                        .show(context);
                  } catch (error) {
                    FlushbarHelper.createError(
                            message:
                                'ระบบเกิดข้อผิดพลาดในการอัพเดตค่า โปรดลองอีกครั้ง')
                        .show(context);
                  }
                  try {
                    final getCurrentDate = DateTime.now();
                    final results = await getDataService.getByDate(
                        getCurrentDate.day.toString(),
                        getCurrentDate.month.toString(),
                        getCurrentDate.year.toString());
                    results.sort((a, b) => a.id.compareTo(b.id));
                    print('results: $results');
                    if (results.isNotEmpty) {
                      sensorValue.value = results[results.length - 1];
                    }
                  } on ServiceNotAvailable catch (error) {
                    FlushbarHelper.createError(message: error.message)
                        .show(context);
                  } catch (error) {
                    print('error: $error');
                    FlushbarHelper.createError(
                            message: 'ระบบเกิดข้อผิดพลาด โปรดลองอีกครั้ง')
                        .show(context);
                  } finally {
                    isLoading.value = false;
                  }
                },
                child: const Text('อัพเดต')),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllGraphPage()));
              },
              child: const Text('กราฟแสดงผลในรูปแบบเรียลไทม์'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
            ),
          ],
        )),
      ),
    );
  }
}
