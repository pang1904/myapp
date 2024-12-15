import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://srp-m2-ci4-trial.stgdevlab.com/ajx_login_srpos'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      // ตรวจสอบสถานะ HTTP ก่อน
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response Data: $responseData');

        // ตรวจสอบว่า 'result' มีค่าเป็น true หรือ false
        if (responseData['result'] == true) {
          // เมื่อกรอกข้อมูลถูกต้อง
          _showSuccessPopup(responseData);
        } else {
          // เมื่อกรอกข้อมูลผิด
          _showErrorPopup(responseData['status_message']);
        }
      } else {
        // ถ้าสถานะไม่ใช่ 200, แสดงข้อความผิดพลาด
        _showErrorPopup('Server Error\nResponse: ${response.body}');
      }
    } catch (e) {
      print('ข้อผิดพลาด: $e');
      _showErrorPopup('ไม่สามารถเชื่อมต่อกับ API ได้');
    }
  }

  // ฟังก์ชันแสดง Popup สำหรับการล็อกอินสำเร็จ
  void _showSuccessPopup(Map<String, dynamic> responseData) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('ผลลัพธ์การ LOGIN'),
      content: Text(
        'Login สำเร็จ'
        ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(); // ปิด Popup
            // ไปที่หน้า IndexPage พร้อมข้อมูล userInfo
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IndexPage(
                  userInfo: {
                    'fullname': '${responseData['userinfo']['firstname']} ${responseData['userinfo']['lastname']}',
                    'mobile': responseData['userinfo']['mobile'],
                    'User ID: ${responseData['userinfo']['us_id']}'
                    'email': responseData['userinfo']['email'],
                  },
                ),
              ),
            );
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
  // ฟังก์ชันแสดง Popup สำหรับกรณีข้อมูลผิด
  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ผลลัพธ์การ LOGIN'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
