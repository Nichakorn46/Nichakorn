import 'package:flutter/material.dart';
import 'package:onlineapp_nichakorn/ShowProductGrid.dart';
import 'package:onlineapp_nichakorn/ShowProductType.dart';
import 'package:onlineapp_nichakorn/addproduct.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:onlineapp_nichakorn/showproduct.dart';

//Method หลักทีRun
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAT4wD46RpLb_RpCLI0Fpfmn5jyEli5xdI",
            authDomain: "onlinefirebase-d0293.firebaseapp.com",
            databaseURL:
                "https://onlinefirebase-d0293-default-rtdb.firebaseio.com",
            projectId: "onlinefirebase-d0293",
            storageBucket: "onlinefirebase-d0293.firebasestorage.app",
            messagingSenderId: "235226851614",
            appId: "1:235226851614:web:ff979834a83bec0b8a810f",
            measurementId: "G-9X5FXFGCKT"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

//Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  static const TextStyle mainTextStyle =
      TextStyle(color: Color.fromRGBO(106, 102, 157, 1), fontSize: 18);
  static const TextStyle titleTextStyle = TextStyle(
    color: Color.fromRGBO(28, 20, 91, 1),
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle textTextStyle = TextStyle(
    color: Color.fromRGBO(154, 191, 128, 1),
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: home(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class home extends StatefulWidget {
  @override
  State<home> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<home> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 230),
            Image.asset('assets/logo.png', height: 100), 
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addproduct()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(205, 235, 184, 1), // สีพื้นหลัง
                foregroundColor: const Color.fromRGBO(106, 102, 157, 1), // สีข้อความ
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              ),
              child: Text(
                'บันทึกข้อมูลสินค้า',
                style: MyApp.mainTextStyle,
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowProductGrid()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(205, 235, 184, 1), // สีพื้นหลัง
                foregroundColor: const Color.fromRGBO(106, 102, 157, 1), // สีข้อความ
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              ),
              child: Text(
                'แสดงข้อมูลสินค้า',
                style: MyApp.mainTextStyle,
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowProductType()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(205, 235, 184, 1), // สีพื้นหลัง
                foregroundColor: const Color.fromRGBO(106, 102, 157, 1), // สีข้อความ
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 45),
              ),
              child: Text(
                'ประเภทสินค้า',
                style: MyApp.mainTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
