import 'package:flutter/material.dart';


class IndexPage extends StatelessWidget {
  final Map<String, dynamic> userInfo; // รับข้อมูลผู้ใช้จากหน้า login หรือ API response

  const IndexPage({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Index Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ส่วนแสดงข้อมูลผู้ใช้
            const Text(
              'Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Full Name: ${userInfo['fullname']}'),
            Text('Mobile: ${userInfo['mobile']}'),
            Text('Email: ${userInfo['email']}'),
             Text('User ID: ${userInfo['us_id']}'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชั่นสำหรับแสดง popup confirm logout
}
