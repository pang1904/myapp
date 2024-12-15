import 'package:flutter/material.dart';
import 'package:myapp/main.dart';


class IndexPage extends StatelessWidget {
  final Map<String, dynamic> responseData;

  const IndexPage({super.key, required this.responseData});

  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการล็อกเอ้า'),
          content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
             );
            },
              child: const Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = responseData['userinfo'];  

    return Scaffold(
      appBar: AppBar(
        title: const Text('Index Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _showLogoutDialog(context), 
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( 
          child: Center(  
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  
              crossAxisAlignment: CrossAxisAlignment.center,  
              children: [
                const Text(
                  'Login สำเร็จ!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text('Result: ${responseData['result']}'),
                Text('Status Code: ${responseData['status_code']}'),
                Text('Status Message: ${responseData['status_message']}'),
                const SizedBox(height: 20),

                if (userInfo != null) ...[
                  const Text(
                    'USER INFO',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ExpansionTile(
                    title: const Text('ข้อมูลส่วนตัว',textAlign: TextAlign.center),
                    children: [
                      Text('US ID: ${responseData['userID']}'),
                      Text('First Name: ${userInfo['firstname']}'),
                      Text('Last Name: ${userInfo['lastname']}'),
                      Text('Nickname: ${userInfo['nickname']}'),
                      Text('Mobile: ${userInfo['mobile']}'),
                      Text('Email: ${userInfo['email']}'),
                      Text('Card ID: ${userInfo['card_ID']}'),
                      Text('Status: ${userInfo['status']}'),
                      Text('Created Time: ${userInfo['created_time']}'),
                      Text('Updated Time: ${userInfo['updated_time']}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ExpansionTile(
                    title: const Text('ข้อมูลเพิ่มเติม',textAlign: TextAlign.center),
                    children: [
                      Text('Full Name: ${responseData['fullname']}'),
                      Text('User ID: ${responseData['userID']}'),
                      Text('Token: ${responseData['token']}'),
                      Text('New Token: ${responseData['new_token']}'),
                      Text('Redirect: ${responseData['redirect']}'),
                      Text('Model Series: ${responseData['model_series']}'),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
