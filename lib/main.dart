import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'index.dart';  // หน้า IndexPage

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
      home: const LoginPage(), // หน้าจอเริ่มต้น
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

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response Data: $responseData');

        if (responseData['result'] == true || responseData['result'] == 'true') {
          // Login Success
          _showSuccessPopup(responseData);
        } else {
          // Login Failed
          _showErrorPopup(responseData);
        }
      } else {
        // Server Error
        _showErrorPopup({
          'result': false,
          'status_code': response.statusCode,
          'status_message': 'Server Error',
        });
      }
    } catch (e) {
      print('ข้อผิดพลาด: $e');
      _showErrorPopup({
        'result': false,
        'status_code': 500,
        'status_message': 'ไม่สามารถเชื่อมต่อกับ API ได้',
      });
    }
  }

  // ฟังก์ชันแสดง Popup สำหรับการล็อกอินสำเร็จ
  void _showSuccessPopup(Map<String, dynamic> responseData) {
    final userInfo = responseData['userinfo'];
    // เปลี่ยนจากการแสดง Popup ไปยังหน้า index.dart
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => IndexPage(responseData: responseData), // ส่งข้อมูลไปที่หน้า IndexPage
      ),
    );
  }

 void _showErrorPopup(Map<String, dynamic> responseData) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('ผลลัพธ์การ LOGIN'),
      contentPadding: const EdgeInsets.all(16.0), // ลด padding ของ dialog
      content: Container(
        constraints: const BoxConstraints(maxWidth: 300), // กำหนดขนาดสูงสุด
        child: Column(
          mainAxisSize: MainAxisSize.min, // ทำให้ขนาด column พอดีกับเนื้อหา
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Result: ${responseData['result']}'),
            Text('Status Code: ${responseData['status_code']}'),
            Text('Status Message: ${responseData['status_message']}'),
          ],
        ),
      ),
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
        padding: const EdgeInsets.all(26.0),
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

