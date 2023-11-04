import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtherProfilePage extends StatefulWidget {
  final String accessToken;

  OtherProfilePage({required this.accessToken});

  @override
  _OtherProfilePage createState() => _OtherProfilePage();
}

class _OtherProfilePage extends State<OtherProfilePage> {
  Map<String, dynamic>? userData;

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/other/profile'),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userData = data;
        });
      } else if (response.statusCode == 403) {
        // Обработка ошибок аутентификации
      } else {
        // Обработка других ошибок
      }
    } catch (error) {
      // Обработка ошибок
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль пользователя'),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          userData!['photo'] != null
              ? Image.network(
            userData!['photo'],
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              }
            },
          )
              : Placeholder(), // Вывод изображения (если оно есть)
          Text('Имя: ${userData!['firstname']}'),
          Text('Фамилия: ${userData!['lastname']}'),
          Text('Email: ${userData!['email']}'),
          Text('Телеграм: ${userData!['telegram']}'),
          Text('Пол: ${userData!['gender']}'),
          Text('Возраст: ${userData!['age']}'),
        ],
      ),
    );
  }
}
