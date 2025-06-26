import 'package:flutter/material.dart';
import 'package:laundry_app/helper/shared_preference.dart';
import 'package:laundry_app/view/auth/halaman_login.dart';

class HalamanProfile extends StatefulWidget {
  const HalamanProfile({super.key});

  @override
  State<HalamanProfile> createState() => _HalamanProfileState();
}

class _HalamanProfileState extends State<HalamanProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Halaman Profile"),
                  Spacer(),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalamanLogin(),
                            ),
                            (route) => false,
                          );
                          PreferenceHandler.deleteToken();
                          print("Login dihapus");
                        },
                        icon: Icon(Icons.login),
                      ),
                      Text("Logout"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
