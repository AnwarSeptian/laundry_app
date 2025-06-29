import 'package:flutter/material.dart';
import 'package:laundry_app/view/halaman_utama/halaman_home.dart';
import 'package:laundry_app/view/halaman_utama/halaman_pesanan.dart';
import 'package:laundry_app/view/halaman_utama/halaman_profile.dart';

class ButtonNavbar extends StatefulWidget {
  const ButtonNavbar({super.key});

  @override
  State<ButtonNavbar> createState() => _ButtonNavbarState();
}

class _ButtonNavbarState extends State<ButtonNavbar> {
  static const List<Widget> _screen = [
    HalamanHome(),
    HalamanPesanan(),
    HalamanProfile(),
  ];
  int _buttonSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _buttonSelected = value;
          });
          print("Halaman saat ini : $_buttonSelected");
        },

        currentIndex: _buttonSelected,
        selectedItemColor: Color(0XFF3B3B1A),
        unselectedItemColor: Color(0XFFAEC8A4),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Pesanan",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_3), label: "Profile"),
        ],
      ),
      body: _screen[_buttonSelected],
    );
  }
}
