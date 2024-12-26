
import 'package:myapp/main.dart';
import 'package:location/location.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart'; // เพิ่มการ import นี้เพื่อให้โค้ดทำงานได้

class IndexPage extends StatefulWidget {
  final Map<String, dynamic> responseData;  // แก้ไขเป็น Map<String, dynamic>

  const IndexPage({Key? key, required this.responseData}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  String locationInfo = 'กำลังโหลด...';
  String networkType = 'กำลังตรวจสอบ...';

  @override
  void initState() {
    super.initState();
    _getLocation();
    _getNetworkType();
  }

  // ฟังก์ชันดึงข้อมูลสถานที่
  void _getLocation() async {
    var location = Location();
    var currentLocation = await location.getLocation();
    setState(() {
      locationInfo = 'Lat: ${currentLocation.latitude}, Long: ${currentLocation.longitude}';
    });
  }

  // ฟังก์ชันตรวจสอบสถานะการเชื่อมต่อเครือข่าย
  void _getNetworkType() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      if (connectivityResult == ConnectivityResult.mobile) {
        networkType = 'Mobile Network';
      } else if (connectivityResult == ConnectivityResult.wifi) {
        networkType = 'WiFi';
      } else {
        networkType = 'No Network';
      }
    });
  }

  // ฟังก์ชันในการแสดง dialog เมื่อผู้ใช้ต้องการออกจากระบบ
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
    final userInfo = widget.responseData['userinfo'];

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
                Text('Result: ${widget.responseData['result']}'),
                Text('Status Code: ${widget.responseData['status_code']}'),
                Text('Status Message: ${widget.responseData['status_message']}'),
                const SizedBox(height: 20),
                Text('Location: $locationInfo'),
                Text('Network: $networkType'),
                const SizedBox(height: 20),
                if (userInfo != null) ...[
                  const Text(
                    'USER INFO',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ExpansionTile(
                    title: const Text('ข้อมูลส่วนตัว', textAlign: TextAlign.center),
                    children: [
                      Text('US ID: ${widget.responseData['userID']}'),
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
                    title: const Text('ข้อมูลเพิ่มเติม', textAlign: TextAlign.center),
                    children: [
                      Text('Full Name: ${widget.responseData['fullname']}'),
                      Text('User ID: ${widget.responseData['userID']}'),
                      Text('Token: ${widget.responseData['token']}'),
                      Text('New Token: ${widget.responseData['new_token']}'),
                      Text('Redirect: ${widget.responseData['redirect']}'),
                      Text('Model Series: ${widget.responseData['model_series']}'),
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
