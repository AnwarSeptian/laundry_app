import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = "/login_screen";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isVisibility = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // void login() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final res = await UserService.loginUser(
  //     email: emailController.text,
  //     password: passwordController.text,
  //   );
  //   if (res["data"] != null) {
  //     PreferenceHandler.saveToken(res['data']['token']);
  //     print('Token: ${res['data']['token']}');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Login berhasil"),
  //         backgroundColor: AppColor.hijau3,
  //       ),
  //     );
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomeApi()),
  //       (route) => false,
  //     );
  //   } else if (res["errors"] != null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           "Maaf, login gagal ${res["message"]}  ",
  //           style: TextStyle(color: AppColor.black22),
  //         ),
  //         backgroundColor: AppColor.cream2,
  //       ),
  //     );
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

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
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildTitle("Login to access your account"),
                height(52),
                buildTextField(
                  hintText: "Enter your email",
                  controller: emailController,
                ),
                height(28),
                buildTextField(
                  hintText: "Enter your password",
                  isPassword: true,
                  controller: passwordController,
                ),
                height(36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // fuction navigator
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white70,
                        radius: 26,
                        child: Icon(
                          Icons.navigate_next_sharp,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                height(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16, color: Colors.white54),
                    ),
                    TextButton(
                      onPressed: () {
                        //navigator sign up
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.blueGrey,

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
          return 'Please enter some text';
        }
        return null;
      },
      obscureText: isPassword ? isVisibility : false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white38),

        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(32),
        //   // borderSide: BorderSide(color: Colors.black, width: 1.0),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(32),
        //   // borderSide: BorderSide(color: Colors.black, width: 1.0),
        // ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(32),
        //   // borderSide: BorderSide(color: Colors.black, width: 1.0),
        // ),
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
                    color: Colors.white38,
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
