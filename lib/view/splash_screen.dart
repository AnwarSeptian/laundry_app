import 'package:flutter/material.dart';
import 'package:laundry_app/view/auth/halaman_login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void changePage() {
    Future.delayed(Duration(seconds: 3), () async {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HalamanLogin()),
        (route) => false,
      );
      // }
    });
  }

  @override
  void initState() {
    changePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),

            Image.asset("assets/images/logo.png"),
            SizedBox(height: 20),
            Text(
              "v 1.0.0",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
