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
  final formKey = GlobalKey<FormState>();
  final TextEditingController layananController = TextEditingController();

  void tambahLayanan() async {
    if (!formKey.currentState!.validate()) return;

    try {
      await LayananApi.addLayanan(name: layananController.text);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: "Layanan berhasil ditambahkan"),
      );
      layananController.clear();

      // ⬅️ Setelah berhasil tambah layanan, langsung tutup dan kirim sinyal refresh
      Navigator.pop(context, true);
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
      appBar: AppBar(title: const Text("Tambah Layanan")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nama Layanan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: layananController,
                  decoration: InputDecoration(
                    hintText: "Contoh: Cuci Kering Lipat",
                    filled: true,
                    fillColor: Colors.blueGrey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama layanan tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: tambahLayanan,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      "Tambah Layanan",
                      style: TextStyle(fontSize: 16, color: Colors.white),
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
