import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:location/location.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class IndexPage extends StatefulWidget {
  final Map<String, dynamic> responseData;

  const IndexPage({super.key, required this.responseData});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  String locationInfo = "กำลังตรวจสอบพิกัด...";
  String networkType = "กำลังตรวจสอบเครือข่าย...";

  @override
  void initState() {
    super.initState();
    _getLocation();
    _getNetworkType();
  }

  // ฟังก์ชันในการตรวจสอบพิกัด
  Future<void> _getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          locationInfo = "ไม่สามารถเปิดบริการตำแหน่งได้";
        });
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          locationInfo = "ไม่มีการอนุญาตให้เข้าถึงตำแหน่ง";
        });
        return;
      }
    }

    LocationData locationData = await location.getLocation();
    setState(() {
      locationInfo =
          "Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}";
    });
  }

  // ฟังก์ชันในการตรวจสอบประเภทของเครือข่าย
  Future<void> _getNetworkType() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    String type = isConnected ? "เชื่อมต่ออินเทอร์เน็ต" : "ไม่ได้เชื่อมต่ออินเทอร์เน็ต";

    setState(() {
      networkType = type;
    });
  }

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
