import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:solar_cell_monitoring_app/models/sensor_value.dart';
import 'package:solar_cell_monitoring_app/services/get_data_service.dart';
import 'package:solar_cell_monitoring_app/utils/constant.dart';
import 'package:solar_cell_monitoring_app/utils/enum.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:intl/intl.dart';

import '../utils/helper.dart';

class AllGraphPage extends HookWidget {
  const AllGraphPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewByChoices = <String>['รายวัน', 'รายเดือน'];
    final viewBySelected = useState<String?>(null);
    final selectedDate = useState<DateTime?>(null);
    final isLoading = useState(false);
    final sensorValues = useState(<SensorValue>[]);
    useEffect(() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
      return () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      };
    }, []);
    return LoadingOverlayPro(
      isLoading: isLoading.value,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11)),
                child: DropdownButton(
                  hint: const Text('เลือกดูข้อมูลรายวัน/เดือน'),
                  value: viewBySelected.value,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: viewByChoices.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    viewBySelected.value = newValue;
                    selectedDate.value = null;
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              if (viewBySelected.value != null)
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () async {
                    if (viewBySelected.value == 'รายวัน') {
                      final result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022, 3),
                          lastDate: DateTime.now());
                      if (result != null) {
                        selectedDate.value = result;
                      }
                    } else {
                      final result = await showMonthPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022, 3),
                        lastDate: DateTime.now(),
                      );
                      if (result != null) {
                        selectedDate.value = result;
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(selectedDate.value != null
                          ? DateFormat(
                              viewBySelected.value == 'รายวัน'
                                  ? 'dd/MM/yyy'
                                  : 'dd/MM',
                            ).format(selectedDate.value!)
                          : viewBySelected.value! == 'รายวัน'
                              ? 'เลือกวันที่'
                              : 'เลือกเดือน'),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(Icons.date_range)
                    ],
                  ),
                ),
              const SizedBox(
                width: 20,
              ),
              if (viewBySelected.value != null && selectedDate.value != null)
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () async {
                      final getDataService = GetDataService.instance();
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
                        if (viewBySelected.value == 'รายวัน') {
                          final results = await getDataService.getByDate(
                            selectedDate.value!.day.toString(),
                            selectedDate.value!.month.toString(),
                            selectedDate.value!.year.toString(),
                          );
                          sensorValues.value = results;
                        } else {
                          final results = await getDataService.getByMonth(
                            selectedDate.value!.month.toString(),
                            selectedDate.value!.year.toString(),
                          );
                          sensorValues.value = results;
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
                    child: const Text('เรียกดูข้อมูล')),
            ],
          ),
        ),
        body: Center(
          child: Column(children: [
            if (sensorValues.value.isEmpty)
              const Expanded(child: Center(child: Text('ไม่พบข้อมูล')))
            else
              Expanded(
                child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    title: ChartTitle(text: 'กราฟค่าข้อมูลทั้งหมด'),
                    legend: Legend(isVisible: true),
                    series: <ChartSeries>[
                      LineSeries<SensorValue, DateTime>(
                        color: ValueType.light.getColor(),
                        dataSource: sensorValues.value,
                        xValueMapper: (SensorValue value, _) =>
                            value.timeStamp.toLocal(),
                        yValueMapper: (SensorValue value, _) =>
                            getSensorValueByValueType(value, ValueType.light),
                        name: ValueType.light.toNameString(),
                      ),
                      LineSeries<SensorValue, DateTime>(
                        color: ValueType.humid.getColor(),
                        dataSource: sensorValues.value,
                        xValueMapper: (SensorValue value, _) =>
                            value.timeStamp.toLocal(),
                        yValueMapper: (SensorValue value, _) =>
                            getSensorValueByValueType(value, ValueType.humid),
                        name: ValueType.humid.toNameString(),
                      ),
                      LineSeries<SensorValue, DateTime>(
                        color: ValueType.temperature.getColor(),
                        dataSource: sensorValues.value,
                        xValueMapper: (SensorValue value, _) =>
                            value.timeStamp.toLocal(),
                        yValueMapper: (SensorValue value, _) =>
                            getSensorValueByValueType(
                                value, ValueType.temperature),
                        name: ValueType.temperature.toNameString(),
                      ),
                      LineSeries<SensorValue, DateTime>(
                        color: ValueType.voltage.getColor(),
                        dataSource: sensorValues.value,
                        xValueMapper: (SensorValue value, _) =>
                            value.timeStamp.toLocal(),
                        yValueMapper: (SensorValue value, _) =>
                            getSensorValueByValueType(value, ValueType.voltage),
                        name: ValueType.voltage.toNameString(),
                      ),
                      LineSeries<SensorValue, DateTime>(
                        color: ValueType.current.getColor(),
                        dataSource: sensorValues.value,
                        xValueMapper: (SensorValue value, _) =>
                            value.timeStamp.toLocal(),
                        yValueMapper: (SensorValue value, _) =>
                            getSensorValueByValueType(value, ValueType.current),
                        name: ValueType.current.toNameString(),
                      ),
                    ]),
              ),
          ]),
        ),
      ),
    );
  }
}
