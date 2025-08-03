import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundry_app/api/order_api.dart';
import 'package:laundry_app/constant/app_color.dart';
import 'package:laundry_app/model/order_response.dart';
import 'package:laundry_app/view/halaman_detail/tambah_order.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HalamanPesanan extends StatefulWidget {
  const HalamanPesanan({super.key});

  @override
  State<HalamanPesanan> createState() => _HalamanPesananState();
}

class _HalamanPesananState extends State<HalamanPesanan> {
  List<DataOrder> orders = [];
  List<DataOrder> filteredOrders = [];
  bool isLoading = true;
  String? errorMessage;
  String selectedStatus = 'semua';

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

      setState(() {
        orders = dataOrder;
        _filterOrders();
      });
    } catch (e) {
      setState(() {
        errorMessage = "Gagal memuat data $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterOrders() {
    if (selectedStatus == 'semua') {
      filteredOrders = List.from(orders);
    } else {
      filteredOrders =
          orders
              .where((o) => o.status.toLowerCase() == selectedStatus)
              .toList();
    }
  }

  void _setStatusFilter(String status) {
    setState(() {
      selectedStatus = status;
      _filterOrders();
    });
  }

  void _showStatusChangeDialog(
    BuildContext context,
    String currentStatus,
    int id,
  ) {
    // Normalisasi status supaya aman dibandingkan
    final status = currentStatus.toLowerCase().trim();

    // Tentukan status selanjutnya: Baru -> Proses -> Selesai
    // Backend hanya menerima "Proses" dan "Selesai" (case-sensitive)
    String? nextStatus;
    if (status == 'baru') {
      nextStatus = 'Proses';
    } else if (status == 'proses' || status == 'Proses'.toLowerCase()) {
      nextStatus = 'Selesai';
    } else if (status == 'selesai') {
      // Sudah pada status akhir
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          message: "Status '$currentStatus' sudah status akhir.",
        ),
      );
      return;
    } else {
      // Jika sudah "selesai" atau status lain yang tidak bisa diubah
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          message: "Status '$currentStatus' tidak bisa diubah.",
        ),
      );
      return;
    }

    // Tampilkan dialog konfirmasi
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Konfirmasi Perubahan Status"),
          content: Text(
            "Apakah Anda yakin ingin mengubah status pesanan menjadi $nextStatus?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Tutup dialog konfirmasi
                try {
                  await OrderApi().ubahStatus(status: nextStatus!, id: id);

                  if (context.mounted) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.success(
                        message:
                            "Status pesanan berhasil diperbarui menjadi $nextStatus.",
                      ),
                    );
                    _loadOrders(); // 🔄 Refresh daftar pesanan
                  }
                } catch (e) {
                  if (context.mounted) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.error(
                        message:
                            "Tidak dapat memperbarui status pesanan saat ini. Silakan coba lagi.",
                      ),
                    );
                  }
                }
              },
              child: const Text("Perbarui"),
            ),
          ],
        );
      },
    );
  }

  Future<void> showOrderDetailDialog(BuildContext context, int orderId) async {
    try {
      final orderDetail = await OrderApi().detailOrder(orderId);
      if (!mounted) return;
      final order = orderDetail.data;

      // TUNGGU hasil dari dialog pertama
      final result = await showDialog<String>(
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
              if (order.status.toLowerCase() != 'selesai' &&
                  order.status.toLowerCase() != 'dibatalkan')
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      'ubahStatus',
                    ); // ✅ KIRIM SIGNAL balik
                  },
                  child: Text("Ubah Status"),
                ),

              if (order.status.toLowerCase() != 'selesai' &&
                  order.status.toLowerCase() != 'dibatalkan')
                TextButton(
                  onPressed: () async {
                    try {
                      await OrderApi().deleteOrder(order.id);
                      if (!mounted) return;
                      Navigator.pop(context, 'hapus');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Pesanan berhasil dibatalkan")),
                      );
                      _loadOrders();
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

      // JIKA tombol "Ubah Status" ditekan, dialog pertama return 'ubahStatus'
      if (result == 'ubahStatus') {
        Future.delayed(Duration.zero, () {
          _showStatusChangeDialog(context, order.status, order.id);
        });
      }
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'baru':
        return Icons.fiber_new;
      case 'proses':
        return Icons.hourglass_empty;
      case 'selesai':
        return Icons.check_circle;
      case 'dibatalkan':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Widget _buildStatusFilterButtons() {
    final List<String> statuses = [
      'semua',
      'baru',
      'proses',
      'selesai',
      'dibatalkan',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children:
            statuses.map((status) {
              final bool isSelected = selectedStatus == status;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () => _setStatusFilter(status),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? AppColor.lightblue1 : AppColor.bold,
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
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
        iconTheme: IconThemeData(color: AppColor.bluegrey),
      ),
      backgroundColor: AppColor.bluegrey,
      body: OverlayLoaderWithAppIcon(
        isLoading: isLoading,
        appIcon: Image.asset("assets/images/logo.png"),
        overlayOpacity: 0.4,
        borderRadius: 16,
        appIconSize: 100,
        child: Column(
          children: [
            _buildStatusFilterButtons(),
            Expanded(
              child:
                  filteredOrders.isEmpty
                      ? Center(child: Text("Tidak ada pesanan"))
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
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
                                leading: CircleAvatar(
                                  backgroundColor: _getStatusColor(
                                    order.status,
                                  ),
                                  child: Icon(
                                    _getStatusIcon(order.status),
                                    color: Colors.white,
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Pesanan #${order.id}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(
                                              order.status,
                                            ).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            order.status,
                                            style: TextStyle(
                                              color: _getStatusColor(
                                                order.status,
                                              ),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text("Layanan: ${order.layanan}"),
                                    Text("Tipe: ${order.serviceType.name}"),
                                    Text(
                                      "Dibuat: ${DateFormat('dd/MM/yyyy').format(order.createdAt)}",
                                      style: TextStyle(
                                        color: AppColor.bluegrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
