import 'package:flutter/material.dart';
import 'package:laundry_app/constant/app_color.dart';

class HalamanPesanan extends StatefulWidget {
  const HalamanPesanan({super.key});

  @override
  State<HalamanPesanan> createState() => _HalamanPesananState();
}

class _HalamanPesananState extends State<HalamanPesanan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Pesanan")),
      backgroundColor: AppColor.bluegrey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColor.lightgreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "",
                  style: TextStyle(color: AppColor.bold, fontSize: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
