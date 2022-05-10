import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solar_cell_monitoring_app/pages/home_page.dart';
import 'package:solar_cell_monitoring_app/pages/sign_in_page.dart';

class SplashPage extends HookWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    useEffect(() {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        });
      } else {
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SignInPage()));
        });
      }
      return null;
    }, []);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
