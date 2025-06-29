import 'package:flutter/material.dart';
import 'package:laundry_app/api/order_api.dart';
import 'package:laundry_app/constant/app_color.dart';
import 'package:laundry_app/model/order_response.dart';
import 'package:laundry_app/view/halaman_detail/tambah_order.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:intl/intl.dart';

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
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text('Pesanan ke - ${index + 1}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Layanan: ${order.layanan}"),
                            Text("Status : ${order.status}"),
                            Text("Tipe Layanan : ${order.serviceType.name}"),

                            Text(
                              "Dibuat : ${DateFormat('dd/MM/yyyy').format(order.createdAt)}",
                              style: TextStyle(color: AppColor.bluegrey),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            //batalkan pesanan
                          },
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
