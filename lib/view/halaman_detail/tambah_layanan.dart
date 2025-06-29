import 'package:flutter/material.dart';
import 'package:laundry_app/api/layanan_api.dart';
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
        CustomSnackBar.success(message: "Layanan Berhasil ditambahkan"),
      );
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: "Layanan Gagal ditambahkan"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Layanan")),

      body: Form(
        key: fromkey,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: layananController),
                ElevatedButton(
                  onPressed: () {
                    tambahLayanan();
                  },
                  child: Text("Tambah Layanan"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
