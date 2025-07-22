import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:laundry_app/api/layanan_api.dart';
import 'package:laundry_app/api/user_api.dart';
import 'package:laundry_app/constant/app_color.dart';
import 'package:laundry_app/model/layanan_response.dart';
import 'package:laundry_app/model/user_respons.dart';
import 'package:laundry_app/view/halaman_detail/detail_layanan.dart';
import 'package:laundry_app/view/halaman_detail/tambah_layanan.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

class HalamanHome extends StatefulWidget {
  const HalamanHome({super.key});

  @override
  State<HalamanHome> createState() => _HalamanHomeState();
}

class _HalamanHomeState extends State<HalamanHome> {
  final List<String> _banner = [
    'assets/images/banner.webp',
    'assets/images/banner2.png',
    'assets/images/banner4.png',
    'assets/images/banner5.png',
  ];
  Data? profileUser;
  List<DataLayanan> layananList = [];
  bool isLoading = true;

  void loadData() async {
    try {
      final profilRes = await UserService().getProfile();
      final layananRes = await LayananApi.getLayanan();

      setState(() {
        profileUser = profilRes.data;
        layananList = layananRes.data;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bluegrey,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahLayanan()),
          );
          if (result == true) {
            loadData();
          }
        },
        backgroundColor: AppColor.lightgreen,
        child: Icon(Icons.add),
      ),

      body: OverlayLoaderWithAppIcon(
        isLoading: isLoading,
        appIcon: Image.asset("assets/images/logo.png"),
        circularProgressColor: AppColor.bold,
        overlayOpacity: 0.4,
        borderRadius: 16,
        appIconSize: 100,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                Text("Selamat Datang,", style: TextStyle(color: AppColor.bold)),
                Text(
                  profileUser?.name ?? "",
                  style: TextStyle(
                    color: AppColor.bold,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                SizedBox(height: 16),
                SizedBox(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 170,
                      autoPlay: true,
                      viewportFraction: 1.0,
                      autoPlayAnimationDuration: Duration(seconds: 1),
                      autoPlayInterval: Duration(seconds: 10),
                    ),
                    items:
                        _banner.map((e) {
                          return SizedBox(
                            width: double.infinity,
                            child: ClipRRect(
                              child: Image.asset(
                                e,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Daftar Layanan",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: AppColor.bold,
                  ),
                ),

                Expanded(
                  child:
                      layananList.isEmpty
                          ? Center(child: Text("Tidak ada layanan tersedia"))
                          : GridView.builder(
                            itemCount: layananList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              final layanan = layananList[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                child: GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DetailLayanan(
                                              layanan: layanan.name,
                                              id: layanan.id,
                                            ),
                                      ),
                                    );
                                    if (result == true) {
                                      loadData();
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        "assets/images/logomesin.jpg",
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: AppColor.lightblue,
                                        ),
                                        child: Center(
                                          child: Text(
                                            layanan.name,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: AppColor.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
      ),
    );
  }
}
