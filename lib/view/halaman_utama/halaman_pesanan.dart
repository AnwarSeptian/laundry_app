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

  String selectedStatusFilter = 'Semua';
  final List<String> statusFilters = [
    'Semua',
    'Baru',
    'Proses',
    'Selesai',
    'Dibatalkan',
  ];

  @override
  void initState() {
    _loadOrders();

    super.initState();
  }

  Future<void> _loadOrders() async {
    setState(() {
      errorMessage = null;
    });
    try {
      final dataOrder = await OrderApi().getOrder();
      setState(() {
        orders = dataOrder;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Gagal memuat data: $e";
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
      if (!mounted) return;
      final order = orderDetail.data;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Detail Pesanan",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow("ID", "#${order.id}"),
                    _buildDetailRow("Jenis Layanan", order.serviceType.name),

                    _buildDetailRow("Pengantaran ", order.layanan),
                    _buildDetailRow("Status", order.status),
                    _buildDetailRow(
                      "Dibuat",
                      DateFormat('dd/MM/yyyy ').format(order.createdAt),
                    ),
                    _buildDetailRow(
                      "Diubah",
                      DateFormat('dd/MM/yyyy ').format(order.updatedAt),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          icon: Icon(Icons.cancel, color: Colors.red),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                          ),
                          onPressed: () async {
                            try {
                              await OrderApi().deleteOrder(order.id);
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Pesanan berhasil dibatalkan"),
                                ),
                              );
                              _loadOrders();
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Gagal membatalkan pesanan: $e",
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          label: Text("Batalkan"),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.edit),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.lightblue,
                            iconSize: 12,
                          ),
                          onPressed: () async {
                            String? selectedStatus;
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: Text("Ubah Status Pesanan"),
                                      content: DropdownButtonFormField<String>(
                                        value: selectedStatus,
                                        hint: Text("Pilih status baru"),
                                        items:
                                            ['Proses', 'Selesai'].map((status) {
                                              return DropdownMenuItem(
                                                value: status,
                                                child: Text(status),
                                              );
                                            }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedStatus = value;
                                          });
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: Text("Batal"),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () async {
                                            if (selectedStatus == null) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Pilih status terlebih dahulu",
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            try {
                                              await OrderApi().ubahStatus(
                                                id: order.id,
                                                status: selectedStatus!,
                                              );
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Status berhasil diubah",
                                                  ),
                                                ),
                                              );
                                              _loadOrders();
                                            } catch (e) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Gagal mengubah status: $e",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Text("Ubah"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          label: Text("Ubah Status"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Tutup"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat detail pesanan: $e')),
        );
      }
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders =
        selectedStatusFilter == 'Semua'
            ? orders
            : orders
                .where(
                  (order) =>
                      order.status.toLowerCase() ==
                      selectedStatusFilter.toLowerCase(),
                )
                .toList();

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
        actions: [
          IconButton(
            onPressed: () {
              _loadOrders();
            },
            icon: Icon(Icons.refresh, color: AppColor.lightgreen),
          ),
        ],
      ),

      backgroundColor: AppColor.bluegrey,
      body: OverlayLoaderWithAppIcon(
        isLoading: isLoading,
        appIcon: Image.asset("assets/images/logo.png"),
        overlayOpacity: 0.4,
        borderRadius: 16,
        appIconSize: 100,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      statusFilters.map((status) {
                        final isSelected = selectedStatusFilter == status;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(status),
                            selected: isSelected,
                            selectedColor: Colors.lightGreen.shade100,
                            onSelected: (_) {
                              setState(() {
                                selectedStatusFilter = status;
                              });
                            },
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    filteredOrders.isEmpty
                        ? Center(child: Text("Tidak ada pesanan"))
                        : ListView.builder(
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];
                            return GestureDetector(
                              onTap:
                                  () =>
                                      showOrderDetailDialog(context, order.id),
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                _getStatusIcon(order.status),
                                                color: _getStatusColor(
                                                  order.status,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                order.serviceType.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "(${order.status})",
                                                style: TextStyle(
                                                  color: _getStatusColor(
                                                    order.status,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text("#ID ${order.id}"),
                                        ],
                                      ),
                                      SizedBox(height: 8),

                                      Text("Layanan : ${order.layanan}"),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                DateFormat(
                                                  'dd MMM yyyy',
                                                ).format(order.createdAt),
                                              ),
                                            ],
                                          ),
                                        ],
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
      ),
    );
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
}

IconData _getStatusIcon(String status) {
  switch (status.toLowerCase()) {
    case 'baru':
      return Icons.fiber_new;
    case 'proses':
      return Icons.hourglass_top;
    case 'selesai':
      return Icons.check_circle;
    case 'dibatalkan':
      return Icons.cancel;
    default:
      return Icons.info;
  }
}
