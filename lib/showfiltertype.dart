import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onlineapp_nichakorn/productdetail.dart';

//Method หลักทีRun
void main() {
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
      home: showfiltertype(category: ' '),
    );
  }
}
 
//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class showfiltertype extends StatefulWidget {
  final String category;

  // Constructor รับค่า category
  showfiltertype({required this.category});

  @override
  State<showfiltertype> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showfiltertype> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป

// สร้าง referenceชื่อ dbRef ไปยังตารางชื่อ products
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
//load ข้อมูล Products มาเก็บไว้
  List<Map<String, dynamic>> products = [];
  Future<void> fetchProducts() async {
    try {
      //โค้ดแบบฝึก final query = dbRef.orderByChild('quantity').startAt(5);//
// ดึงข้อมูลจาก Realtime Database
      final snapshot = await dbRef
          .orderByChild('category')
          .equalTo(widget.category) // กรองตาม category
          .get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
// วนลูปเพื่อแปลงข้อมูลเป็น Map
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สําหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        });
// **เรียงลําดับข้อมูลตามราคา จากมากไปน้อย**
        loadedProducts.sort((a, b) => b['quantity'].compareTo(a['quantity']));
// อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });
        print(
            "จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ"); // Debugging
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล"); // กรณีไม่มีข้อมูล
      }
    } catch (e) {
      print("Error loading products: $e"); // แสดงข้อผิดพลาดทาง Console
// แสดง Snackbar เพื่อแจ้งเตือนผู้ใช้
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

//ฟังก์ชันตั้งวันที่
  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yy').format(parsedDate);
  }

//เรียกฟังก์ชั่นให้ใช้เลยตอนเปิดแอป
  @override
  void initState() {
    super.initState();
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หมวดหมู่: ${widget.category}',style: MyApp.titleTextStyle,),
        backgroundColor: Color.fromRGBO(205, 235, 184, 1),
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(product['name']),
                    subtitle: Column(children: [
                      Text('รายละเอียดสินค้า: ${product['description']}'),
                      Text(
                          'วันที่ผลิตสินค้า: ${formatDate(product['productionDate'])}'),
                    ]),
                    trailing: Text('ราคา : ${product['price']} บาท'),
                    onTap: () {
                      //เมื่อกดที่แต่ละรายการจะเกิดอะไรขึ้น
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => productdetail(product:product),
                      ),
                    );
                    },
                  ),
                );
              },
            ),
    );
  }
}
