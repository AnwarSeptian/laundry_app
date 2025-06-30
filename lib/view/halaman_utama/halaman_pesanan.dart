import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundry_app/api/order_api.dart';
import 'package:laundry_app/constant/app_color.dart';
import 'package:laundry_app/model/order_response.dart';
import 'package:laundry_app/view/halaman_detail/tambah_order.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

class HalamanPesanan extends StatefulWidget {
  const HalamanPesanan({super.key});

  @override
  State<HalamanPesanan> createState() => _HalamanPesananState();
}

class _HalamanPesananState extends State<HalamanPesanan> {
  List<DataOrder> orders = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      errorMessage = null;
    });
    try {
      final dataOrder = await OrderApi().getOrder();
      print('Data dari API: ${dataOrder.length} item');

      if (dataOrder.isNotEmpty) {
        print('Contoh data pertama: ${dataOrder[0].toJson()}');
      }

      setState(() {
        orders = dataOrder;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        errorMessage = "Gagal memuat data  $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> showOrderDetailDialog(BuildContext context, int orderId) async {
    try {
      final orderDetail = await OrderApi().detailOrder(orderId);
      if (!mounted)
        return; //untuk mengakses context widget yang sudah tidak aktif lagi
      final order = orderDetail.data;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Detail Pesanan"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID : ${order.id}"),
                Text("Layanan : ${order.layanan}"),
                Text("Status : ${order.status}"),
                Text("Jenis : ${order.serviceType.name}"),
                Text(
                  "Tanggal dibuat : ${DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt)}",
                ),
                Text(
                  "Terakhir diubah : ${DateFormat('dd/MM/yyyy HH:mm').format(order.updatedAt)}",
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () {}, child: Text("Ubah Status")),

              TextButton(
                onPressed: () async {
                  try {
                    await OrderApi().deleteOrder(order.id);

                    if (!mounted) return;

                    Navigator.pop(context); // tutup dialog

                    // Tampilkan feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Pesanan berhasil dibatalkan")),
                    );

                    _loadOrders(); // refresh list
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Gagal membatalkan pesanan: $e"),
                        ),
                      );
                    }
                  }
                },
                child: Text("Batalkan"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Tutup"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (mounted) {
        Future.microtask(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat detail pesanan: $e')),
          );
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper to get color based on status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'baru':
        return Colors.blue;
      case 'proses':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahOrder()),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          "Riwayat Pesanan",
          style: TextStyle(color: AppColor.lightblue1),
        ),
        backgroundColor: AppColor.bold,
      ),
      backgroundColor: AppColor.bluegrey,
      body: OverlayLoaderWithAppIcon(
        isLoading: isLoading,
        appIcon: Image.asset("assets/images/logo.png"),
        overlayOpacity: 0.4,
        borderRadius: 16,
        appIconSize: 100,
        child:
            isLoading
                ? Center(child: Text("Tidak ada pesanan"))
                : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return GestureDetector(
                      onTap: () async {
                        await showOrderDetailDialog(context, order.id);
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        order.status,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(order.status),
                                  ),
                                ],
                              ),
                              Text("Jenis Layanan: ${order.layanan}"),
                              Text("Tipe Layanan : ${order.serviceType.name}"),

                              Text(
                                "Dibuat : ${DateFormat('dd/MM/yyyy').format(order.createdAt)}",
                                style: TextStyle(color: AppColor.bluegrey),
                              ),
                            ],
                          ),

                          // trailing: IconButton(
                          //   icon: Icon(Icons.navigate_next),
                          //   onPressed: () async {
                          //     await showOrderDetailDialog(context, order.id);
                          //   },
                          // ),
                          leading: CircleAvatar(child: Text("${index + 1}")),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
