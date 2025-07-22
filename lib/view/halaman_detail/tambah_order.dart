import 'package:flutter/material.dart';
import 'package:laundry_app/api/layanan_api.dart';
import 'package:laundry_app/api/order_api.dart';
import 'package:laundry_app/constant/app_color.dart';
import 'package:laundry_app/model/layanan_response.dart';

class TambahOrder extends StatefulWidget {
  const TambahOrder({super.key});

  @override
  State<TambahOrder> createState() => _TambahOrderState();
}

class _TambahOrderState extends State<TambahOrder> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  List<DataLayanan> _layananList = [];
  List<String> _pengantaranList = [];

  DataLayanan? _selectedLayanan;
  String? _selectedPengantaran;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final layananResponse = await LayananApi.getLayanan();
      final orders = await OrderApi().getOrder();

      final uniquePengantaran = orders.map((e) => e.layanan).toSet().toList();

      setState(() {
        _layananList = layananResponse.data;
        _pengantaranList = uniquePengantaran;
      });
    } catch (e) {
      print('Error saat mengambil data: $e');
    }
  }

  Future<void> submitOrder() async {
    print("submitOrderjalan");
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await OrderApi().addOrder(
        layanan: _selectedPengantaran!,
        serviceTypeId: _selectedLayanan!.id,
      );
      print('Pesanan berhasil: ${response.message}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Berhasil: ${response.message}")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(" Gagal: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightblue,
      appBar: AppBar(title: const Text("Order SiCuci")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Masukkan Data Pesanan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColor.bold,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Dropdown Jenis Layanan
                    DropdownButtonFormField<DataLayanan>(
                      value: _selectedLayanan,
                      hint: const Text("Pilih Jenis Layanan"),
                      decoration: InputDecoration(
                        labelText: "Jenis Layanan",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items:
                          _layananList.map((layanan) {
                            return DropdownMenuItem<DataLayanan>(
                              value: layanan,
                              child: Text(layanan.name),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLayanan = value;
                        });
                      },
                      validator:
                          (value) =>
                              value == null ? "Wajib pilih layanan" : null,
                    ),

                    const SizedBox(height: 24),

                    // Dropdown Pengantaran
                    DropdownButtonFormField<String>(
                      value: _selectedPengantaran,
                      hint: const Text("Pilih Pengantaran"),
                      decoration: InputDecoration(
                        labelText: "Pengantaran",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items:
                          _pengantaranList.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPengantaran = value;
                        });
                      },
                      validator:
                          (value) =>
                              value == null ? "Wajib pilih pengantaran" : null,
                    ),

                    const SizedBox(height: 32),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.bold,
                        fixedSize: Size(280, 50),
                      ),
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                if (_selectedLayanan != null &&
                                    _selectedPengantaran != null) {
                                  submitOrder(); // ✅ Kirim jika data lengkap
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Semua field wajib dipilih",
                                      ),
                                    ),
                                  );
                                }
                              },

                      child:
                          _isLoading
                              ? null
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    "Kirim Pesanan",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
