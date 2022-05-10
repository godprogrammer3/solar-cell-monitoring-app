import 'package:another_flushbar/flushbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:solar_cell_monitoring_app/pages/forgot_password_page.dart';
import 'package:solar_cell_monitoring_app/pages/home_page.dart';
import 'package:solar_cell_monitoring_app/pages/register_page.dart';

import '../utils/helper.dart';

class SignInPage extends HookWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final screenSize = MediaQuery.of(context).size;
    final isHidePassword = useState(true);
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
                        'กรอกรหัสเข้าสู่ระบบ',
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
                      SizedBox(
                        width: screenSize.width * 0.7,
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    isHidePassword.value =
                                        !isHidePassword.value;
                                  },
                                  icon: Icon(isHidePassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off))),
                          obscureText: isHidePassword.value,
                          validator: (input) => (input ?? '').length >= 6
                              ? null
                              : 'Password ต้องมีความยาว 6 ตัวอักษรขึ้นไป',
                        ),
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
                                await firebaseAuth.signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              } on FirebaseAuthException catch (error) {
                                late String message;
                                if (error.code == 'invalid-email') {
                                  message = 'อีเมลไม่ถูกต้อง';
                                } else if (error.code == 'user-disabled') {
                                  message = 'ผู้ใช้ถูกระงับการใช้งาน';
                                } else if (error.code == 'user-not-found' ||
                                    error.code == 'wrong-password') {
                                  message = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง';
                                } else {
                                  message =
                                      'ระบบเกิดข้อผิดพลาด โปรดลองอีกครั้ง';
                                }
                                FlushbarHelper.createError(message: message)
                                    .show(context);
                              } catch (error) {
                                FlushbarHelper.createError(
                                        message:
                                            'ระบบเกิดข้อผิดพลาด โปรดลองอีกครั้ง')
                                    .show(context);
                              } finally {
                                isLoading.value = false;
                              }
                            }
                          },
                          child: const Text('เข้าสู่ระบบ')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                          },
                          child: const Text('สมัครสมาชิก')),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()));
                          },
                          child: const Text(
                            'ลืมรหัสผ่านสมาชิก',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.grey),
                          ))
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
