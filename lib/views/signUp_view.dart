import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../views/login_view.dart';
import '../constants.dart';
import '../controller/simple_ui_controller.dart';

class SignUpView extends StatefulWidget {

  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  Future<void> handleSubmit() async {
    final String firstname = firstnameController.text;
    final String lastname = lastnameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    final response = await http.post(
      Uri.parse('http://localhost:8080/api/v1/auth/register'),
      headers: <String, String>{
        'Content-Type' : 'application/json',
      },
      body: jsonEncode(
        {
          'firstname' : firstname,
          'lastname' : lastname,
          'email' : email,
          'password' : password,
        },
      ),
    );

    if (response.statusCode == 200) {
      // Reg successful
      print('Registration successful');

      //redirect to the login page
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      if (response.statusCode == 403) {
        setState(() {
          errorMessage = 'Account not find';
        });
      } else {
        setState(() {
          errorMessage = 'Error in reg';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return _buildLargeScreen(size, simpleUIController, theme);
              } else {
                return _buildSmallScreen(size, simpleUIController, theme);
              }
            },
          )),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Lottie.asset(
              'assets/coin.json',
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
            ? Container()
            : Lottie.asset(
                'assets/wave.json',
                height: size.height * 0.2,
                width: size.width,
                fit: BoxFit.fill,
              ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'GalFinder',
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Создать учетную запись',
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// name
                TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: firstnameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Имя',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust the vertical padding as needed
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    } else if (value.length < 2) {
                      return 'at least enter 2 characters';
                    } else if (value.length > 15) {
                      return 'maximum character is 15';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),

                /// lastname
                TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: lastnameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Фамилия',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust the vertical padding as needed
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    } else if (value.length < 2) {
                      return 'at least enter 2 characters';
                    } else if (value.length > 24) {
                      return 'maximum character is 24';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),

                /// Email
                TextFormField(
                  style: kTextFormFieldStyle(),
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_rounded),
                    hintText: 'Почта',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust the vertical padding as needed
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Укажите почту';
                    } else if (!value.endsWith('@gmail.com') && !value.endsWith('@mail.ru')) {
                      return 'Укажите корректную почту';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// password
                Obx(
                  () => TextFormField(
                    style: kTextFormFieldStyle(),
                    controller: passwordController,
                    obscureText: simpleUIController.isObscure.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Пароль',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust the vertical padding as needed
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите пароль';
                      } else if (value.length < 8) {
                        return 'Не меньше 8 символов';
                      } else if (value.length > 80) {
                        return 'Не больше 80 символов';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'Регистрируясь, вы соглашаетесь с нашими\nУсловиями обслуживания и нашей\nПолитикой конфиденциальности.',
                  style: kLoginTermsAndPrivacyStyle(size),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// SignUp Button
                signUpButton(theme),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (ctx) => const LoginView()));
                    firstnameController.clear();
                    lastnameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    _formKey.currentState?.reset();

                    simpleUIController.isObscure.value = true;
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'У вас есть аккаунт?',
                      style: kHaveAnAccountStyle(size),
                      children: [
                        TextSpan(
                            text: " Войти",
                            style: kLoginOrSignUpTextStyle(size)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // SignUp Button
  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            handleSubmit();
          }
        },
        child: const Text('Зарегистрироваться'),
      ),
    );
  }
}
