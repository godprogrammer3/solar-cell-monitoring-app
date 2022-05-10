import 'package:another_flushbar/flushbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import '../utils/helper.dart';

class ForgotPasswordPage extends HookWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final screenSize = MediaQuery.of(context).size;
    final isLoading = useState(false);
    return LoadingOverlayPro(
      isLoading: isLoading.value,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/logo.png',
                  width: screenSize.width * 0.8,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'กรอกอีเมลเพื่อกู้คืนรหัสผ่าน',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: screenSize.width * 0.7,
                        child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (input) =>
                              RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(input ?? '')
                                  ? null
                                  : 'กรุณากรอกค่าให้ถูกต้อง',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              isLoading.value = true;
                              if (!await checkInternetConnection(context)) {
                                isLoading.value = false;
                                return;
                              }
                              try {
                                final firebaseAuth = FirebaseAuth.instance;
                                final result =
                                    await firebaseAuth.sendPasswordResetEmail(
                                        email: emailController.text);
                                FlushbarHelper.createSuccess(
                                        message:
                                            'ส่งลิงค์เรียบร้อย กรุณาดำเนินการต่อในระบบอีเมล')
                                    .show(context);
                              } on FirebaseAuthException catch (error) {
                                print('error.code: ${error.code}');
                                late String message;
                                if (error.code == 'invalid-email') {
                                  message = 'อีเมลไม่ถูกต้อง';
                                } else if (error.code == 'user-not-found') {
                                  message = 'ไม่พบอีเมลนี้ในระบบ';
                                } else {
                                  message =
                                      'ระบบเกิดข้อผิดพลาด โปรดลองอีกครั้ง';
                                }
                                FlushbarHelper.createError(message: message)
                                    .show(context);
                              } catch (error) {
                                print('type: ${error.runtimeType}');
                                FlushbarHelper.createError(
                                        message:
                                            'ระบบเกิดข้อผิดพลาด โปรดลองอีกครั้ง')
                                    .show(context);
                              } finally {
                                isLoading.value = false;
                              }
                            }
                          },
                          child: const Text('ส่งลิงค์กู้คืนรหัสผ่าน')),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('เข้าสู่ระบบ')),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                )
              ]),
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
