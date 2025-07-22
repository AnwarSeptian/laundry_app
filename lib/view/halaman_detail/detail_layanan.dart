import 'package:flutter/material.dart';
import 'package:laundry_app/api/layanan_api.dart';
import 'package:laundry_app/constant/app_color.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DetailLayanan extends StatefulWidget {
  final int id;
  final String? layanan;
  const DetailLayanan({super.key, required this.id, this.layanan});

  @override
  State<DetailLayanan> createState() => _DetailLayananState();
}

class _DetailLayananState extends State<DetailLayanan> {
  Future<void> hapusLayanan() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Yakin ingin menghapus layanan ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Hapus"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        final hapusResponse = await LayananApi().deleteLayanan(widget.id);
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(message: "${hapusResponse.message}"),
        );
        Navigator.pop(context, true);
      } catch (e) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(message: "Gagal menghapus layanan: $e"),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Layanan")),
      backgroundColor: AppColor.lightblue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset("assets/images/detail_laundry.jpg"),
              SizedBox(height: 50),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.lightblue1,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${widget.layanan}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            "assets/images/centang1.png",
                            width: 40,
                            height: 40,
                          ),
                        ],
                      ),
                      Text("Tersedia setiap hari"),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.lightgreen,
                            ),
                            onPressed: hapusLayanan,
                            child: Text("Hapus Layanan"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
