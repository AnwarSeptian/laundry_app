import 'package:flutter/material.dart';
import 'package:laundry_app/api/user_api.dart';
import 'package:laundry_app/constant/app_color.dart';
import 'package:laundry_app/utils/shared_preference.dart';
import 'package:laundry_app/view/auth/halaman_register.dart';
import 'package:laundry_app/view/halaman_utama/button_navbar.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});
  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  bool isLoading = false;
  bool isVisibility = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService userService = UserService();

  final _formKey = GlobalKey<FormState>();

  void login() async {
    setState(() {
      isLoading = true;
    });
    final res = await userService.login(
      email: emailController.text,
      password: passwordController.text,
    );
    if (res["data"] != null) {
      PreferenceHandler.saveToken(res["data"]["token"]);
      print("Token: ${res["data"]["token"]}");
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: "Login Berhasil"),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ButtonNavbar()),
        (route) => false,
      );
    } else {
      String pesanError = "";

      if (res["errors"] != null) {
        pesanError = res["errors"].entries
            .map((e) => e.value.join(', '))
            .join('\n');
      } else if (res["message"] != null) {
        pesanError = res["message"];
      } else {
        pesanError = "Terjadi kesalahan yang tidak diketahui.";
      }

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: "$pesanError"),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OverlayLoaderWithAppIcon(
        isLoading: isLoading,
        appIcon: Image.asset("assets/images/logo.png"),
        circularProgressColor: AppColor.bold,
        overlayOpacity: 1,
        borderRadius: 16,
        appIconSize: 100,
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: Stack(children: [buildBackground(), buildLayer()]),
          ),
        ),
      ),
    );
  }

  Padding buildLayer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Center(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Image.asset("assets/images/logo.png"),
                        ),
                        height(26),
                        buildTitle("Silahkan masuk ke akun anda"),
                        height(56),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: buildTextField(
                            hintText: "Masukkan Email",
                            controller: emailController,
                          ),
                        ),
                        height(28),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: buildTextField(
                            hintText: "Kata Sandi",
                            isPassword: true,
                            controller: passwordController,
                          ),
                        ),
                        height(36),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              login();
                              print('Email : ${emailController.text}');
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white38,
                                radius: 26,
                                child: Icon(
                                  Icons.navigate_next_sharp,
                                  color: Colors.black54,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                        height(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Belum punya akun?",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white54,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HalamanRegister(),
                                  ),
                                );
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildTextField({
    String? hintText,
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lengkapi data';
        }
        return null;
      },
      obscureText: isPassword ? isVisibility : false,

      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black54),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white38, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white38),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white38, width: 0),
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      isVisibility = !isVisibility;
                    });
                  },
                  icon: Icon(
                    isVisibility ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black54,
                  ),
                )
                : null,
      ),
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  Widget buildTitle(String text) {
    return Center(
      child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white54)),
    );
  }
}
