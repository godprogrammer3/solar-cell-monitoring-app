import 'package:another_flushbar/flushbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:solar_cell_monitoring_app/pages/all_value_page.dart';
import 'package:solar_cell_monitoring_app/pages/sign_in_page.dart';
import 'package:solar_cell_monitoring_app/pages/single_value_page.dart';
import 'package:solar_cell_monitoring_app/pages/splash_page.dart';
import 'package:solar_cell_monitoring_app/utils/enum.dart';

class HomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final screenSize = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;

    return LoadingOverlayPro(
      isLoading: isLoading.value,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/logo.png',
                  width: screenSize.width * 0.8,
                ),
                const Text(
                  'ยินดีต้อนรับเข้าสู่ระบบ',
                  style: TextStyle(fontSize: 25),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'คุณ: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      user != null ? user.email!.split('@')[0] : '',
                      style: const TextStyle(fontSize: 20),
                    ),
                    TextButton(
                        onPressed: () async {
                          isLoading.value = true;
                          try {
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ));
                          } catch (error) {
                            FlushbarHelper.createError(
                                    message:
                                        'ระบบเกิดข้อผิดพลาด โปรดลองอีกครั้ง')
                                .show(context);
                          } finally {
                            isLoading.value = false;
                          }
                        },
                        child: const Text(
                          'ออกจากระบบ',
                          style: TextStyle(color: Colors.redAccent),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'หน้าเมนู',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SingleValuePage(
                              type: ValueType.light,
                            )));
                  },
                  child: const Text('ค่าความเข้มแสง'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.brown),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SingleValuePage(
                              type: ValueType.humid,
                            )));
                  },
                  child: const Text('ค่าความชื้น'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SingleValuePage(
                              type: ValueType.temperature,
                            )));
                  },
                  child: const Text('ค่าอุณหภูมิ'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SingleValuePage(
                              type: ValueType.voltage,
                            )));
                  },
                  child: const Text('ค่าความต่างศักย์ไฟฟ้า'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SingleValuePage(
                              type: ValueType.current,
                            )));
                  },
                  child: const Text('ค่ากระแสไฟฟ้า'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.purple),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AllValuePage()));
                  },
                  child: const Text('แสดงค่าข้อมูลทั้งหมด'),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
