import 'package:flutter/material.dart';
import 'package:laundry_app/api/user_api.dart';
import 'package:laundry_app/constant/app_color.dart';
import 'package:laundry_app/model/user_respons.dart';
import 'package:laundry_app/utils/shared_preference.dart';
import 'package:laundry_app/view/auth/halaman_login.dart';
import 'package:laundry_app/view/halaman_utama/halaman_pesanan.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

class HalamanProfile extends StatefulWidget {
  const HalamanProfile({super.key});

  @override
  State<HalamanProfile> createState() => _HalamanProfileState();
}

class _HalamanProfileState extends State<HalamanProfile> {
  final TextEditingController nameController = TextEditingController();
  Data? profileUser;
  bool isLoading = true;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    try {
      final profilRes = await UserService().getProfile();

      setState(() {
        profileUser = profilRes.data;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void tampilkanDaftarPengguna() async {
    try {
      final response = await UserService().listUser();
      final users = response.data;

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Daftar Pengguna"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: users.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: Icon(Icons.person),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Tutup"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Gagal memuat daftar pengguna: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightblue,
      body: OverlayLoaderWithAppIcon(
        isLoading: isLoading,
        appIcon: Image.asset("assets/images/logo.png"),
        circularProgressColor: AppColor.bold,
        overlayOpacity: 1,
        borderRadius: 16,
        appIconSize: 100,

        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 44),
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    radius: 95,
                    child: CircleAvatar(
                      backgroundColor: AppColor.bluegrey,
                      radius: 90,
                      backgroundImage: AssetImage("assets/images/profile.png"),
                    ),
                  ),
                  Text(
                    profileUser?.name ?? "",
                    style: TextStyle(
                      color: AppColor.bold,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    profileUser?.email ?? "",
                    style: TextStyle(
                      color: AppColor.bold,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColor.lightblue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColor.bold3,
                                radius: 20,

                                child: Icon(Icons.edit, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),

                          trailing: IconButton(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: TextFormField(
                                        controller: nameController,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: Text("Batal"),
                                        ),
                                        ElevatedButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: Text("Ubah"),
                                        ),
                                      ],
                                    ),
                              );
                              if (confirm == true) {
                                try {
                                  final editProfile = await UserService()
                                      .updateProfile(name: nameController.text);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("✅ ${editProfile.message}"),
                                    ),
                                  );

                                  // Refresh UI atau hapus dari list layanan lokal
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("❌ Gagal hapus: $e"),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: Icon(
                              Icons.navigate_next_sharp,
                              color: AppColor.bold3,
                              size: 30,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColor.bold3,
                                radius: 20,

                                child: Icon(
                                  Icons.receipt_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Riwayat Pesanan",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HalamanPesanan(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.navigate_next_sharp,
                              color: AppColor.bold3,
                              size: 30,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColor.bold3,
                                radius: 20,

                                child: Icon(
                                  Icons.person_search_sharp,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Daftar Pengguna",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              tampilkanDaftarPengguna();
                            },
                            icon: Icon(
                              Icons.navigate_next_sharp,
                              color: AppColor.bold3,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.bold,
                            fixedSize: Size(280, 50),
                          ),
                          onPressed: () {
                            PreferenceHandler.deleteToken();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HalamanLogin(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Sign Out",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
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
    );
  }
}
