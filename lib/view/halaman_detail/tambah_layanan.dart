import 'package:flutter/material.dart';
import 'package:laundry_app/api/layanan_api.dart';
import 'package:laundry_app/constant/app_color.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TambahLayanan extends StatefulWidget {
  const TambahLayanan({super.key});

  @override
  State<TambahLayanan> createState() => _TambahLayananState();
}

class _TambahLayananState extends State<TambahLayanan> {
  final fromkey = GlobalKey<FormState>();
  final TextEditingController layananController = TextEditingController();

  void tambahLayanan() async {
    try {
      final response = await LayananApi.addLayanan(
        name: layananController.text,
      );
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: "Layanan berhasil ditambahkan"),
      );
      Navigator.pop(context);
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: "Layanan gagal ditambahkan"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bluegrey,
      appBar: AppBar(
        title: Text(
          "Tambah Layanan",
          style: TextStyle(color: AppColor.lightblue1),
        ),
        backgroundColor: AppColor.bold,
        iconTheme: IconThemeData(color: AppColor.lightblue1),
      ),
      body: Form(
        key: fromkey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    controller: layananController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan nama layanan';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nama Layanan',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.lightgreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      if (fromkey.currentState!.validate()) {
                        tambahLayanan();
                      }
                    },
                    child: Text(
                      "Tambah Layanan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
