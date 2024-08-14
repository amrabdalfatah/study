import 'package:flutter/material.dart';
import 'package:study_academy/core/utils/colors.dart';
import 'package:study_academy/core/utils/dimensions.dart';
import 'package:study_academy/core/widgets/big_text.dart';
import 'package:study_academy/core/widgets/main_button.dart';
import 'package:study_academy/core/widgets/small_text.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool passwordShown = true;

  void _changePassword() {
    setState(() {
      passwordShown = !passwordShown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.height15),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Dimensions.height50,
                  ),
                  BigText(
                    text: 'Sign In',
                    color: Colors.black,
                    size: Dimensions.font32,
                  ),
                  SmallText(
                    text: 'Enter your info to login to your account',
                    color: Colors.grey,
                    size: Dimensions.font16,
                  ),
                  SizedBox(
                    height: Dimensions.height80,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallText(
                        text: 'Email',
                        color: Colors.black,
                        size: Dimensions.font16,
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.height15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallText(
                        text: 'Password',
                        color: Colors.black,
                        size: Dimensions.font16,
                      ),
                      SizedBox(
                        height: Dimensions.height10,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: passwordShown,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordShown
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: _changePassword,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.height30,
                  ),
                  MainButton(
                    text: 'Login',
                    onTap: () {},
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
