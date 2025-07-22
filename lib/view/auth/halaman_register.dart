import 'package:flutter/material.dart';
import 'package:laundry_app/api/user_api.dart';
import 'package:laundry_app/view/auth/halaman_login.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HalamanRegister extends StatefulWidget {
  const HalamanRegister({super.key});
  static const String id = "/login_screen";
  @override
  State<HalamanRegister> createState() => _HalamanRegisterState();
}

class _HalamanRegisterState extends State<HalamanRegister> {
  final UserService userService = UserService();
  bool isLoading = false;
  bool isVisibility = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void register() async {
    setState(() {
      isLoading = true;
    });
    final res = await userService.registerUser(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
    if (res["data"] != null) {
      print("Token: ${res["data"]["token"]}");
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(message: "Registrasi Berhasil"),
      );
      Navigator.pop(context);
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
        CustomSnackBar.error(message: pesanError),
      );
    }
    setState(() {
      isLoading = false;
    });

    // } else {
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(children: [buildBackground(), buildLayer()]),
      ),
    );
  }

  SafeArea buildLayer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            // ini dia kuncinya
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register",
                    style: TextStyle(fontSize: 32, color: Colors.white70),
                  ),
                  height(32),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: buildTextField(
                      hintText: "Masukkan nama anda",
                      controller: nameController,
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
                      hintText: "Masukkan email anda",
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
                    onTap:
                        isLoading
                            ? null
                            : () {
                              if (_formKey.currentState!.validate()) {
                                register();
                                print('Email : ${emailController.text}');
                              }
                            },
                    child:
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Row(
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
                        "Sudah memiliki akun?",
                        style: TextStyle(fontSize: 16, color: Colors.white54),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HalamanLogin(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
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
          return 'Lengkapi data anda';
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
