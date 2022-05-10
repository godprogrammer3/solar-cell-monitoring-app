import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:solar_cell_monitoring_app/pages/single_graph_page.dart';
import 'package:solar_cell_monitoring_app/services/get_data_service.dart';
import 'package:solar_cell_monitoring_app/utils/constant.dart';
import 'package:solar_cell_monitoring_app/utils/enum.dart';
import 'package:solar_cell_monitoring_app/widgets/display_value_widget.dart';

import '../utils/helper.dart';

class SingleValuePage extends HookWidget {
  final ValueType type;
  const SingleValuePage({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final value = useState<double?>(null);
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
            value.value =
                getSensorValueByValueType(results[results.length - 1], type);
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
          title: const Text('ค่าข้อมูล'),
        ),
        body: Center(
            child: Column(
          children: [
            SizedBox(
              width: screenSize.width * 0.5,
              child: DisplayValueWidget(
                  type: type,
                  value: value.value != null ? value.value!.toString() : 'N/A'),
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
                      value.value = getSensorValueByValueType(
                          results[results.length - 1], type);
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
                        builder: (context) => SingleGraphPage(
                              type: type,
                            )));
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
