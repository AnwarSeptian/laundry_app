import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:laundry_app/api/user_api.dart';
import 'package:laundry_app/constant/app_color.dart';
import 'package:laundry_app/model/register_response.dart';
import 'package:laundry_app/view/halaman/halaman_profile.dart';

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
  List<User> _layananList = [];
  final bool _isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  void loadData() async {
    final data = await UserService.getLayanan();
    setState(() {
      _layananList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bluegrey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColor.lightblue,
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Selamat Datang,",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "Samantha Martin",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalamanProfile(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.person_3_sharp,
                          size: 32,
                          color: AppColor.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    child: CarouselSlider(
                      options: CarouselOptions(height: 170, autoPlay: true),
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
                    child: FutureBuilder(
                      future: UserService.getProfile(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          final list = snapshot.data?["data"];
                          print(list);
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.abc_outlined, size: 40),
                                      SizedBox(height: 10),
                                      Text(
                                        "Judul",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return Text("Error : $snapshot");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
