import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_login_ui/views/login_view.dart';
import 'package:responsive_login_ui/views/signUp_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Ваши другие настройки...
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => SignUpView(),
        ),
        GetPage(
          name: '/login',
          page: () => LoginView(),
        ),
      ],
    );
  }
}
