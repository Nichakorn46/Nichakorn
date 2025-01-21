import 'package:flutter/material.dart';

// รับข้อมูลสินค้าที่ส่งมา
class productdetail extends StatelessWidget {
  final Map<String, dynamic> product;

  productdetail({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10), // เว้นระยะระหว่างไอคอนกับข้อความ
            Text(
              product['name'], // ใช้ชื่อสินค้าแทน "MENU MAIN"
              style: TextStyle(
                color: const Color.fromRGBO(28, 20, 91, 1), // เปลี่ยนสีข้อความเป็นสีขาว
                fontWeight: FontWeight.bold, // เพิ่มน้ำหนักตัวอักษร
                letterSpacing: 1.5, // เพิ่มระยะห่างระหว่างตัวอักษร
              ),
            ),
          ],
        ),
        centerTitle: true, // จัดตำแหน่งข้อความตรงกลาง
        backgroundColor: Color.fromRGBO(154, 191, 128, 1), // กำหนดสีพื้นหลัง
        elevation: 5, // เพิ่มเงาให้ AppBar
        toolbarHeight: 70, // กำหนดความสูงของ AppBar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50), // ปรับมุมล่างให้โค้งมน
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // เปลี่ยนสีไอคอน
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ชื่อสินค้า
            Text(
              'ชื่อสินค้า: ${product['name']}',
              style: TextStyle(
                fontSize: 22, // ขนาดตัวอักษรใหญ่ขึ้น
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0), // สีข้อความเข้ม
              ),
            ),
            const SizedBox(height: 12), // ช่องว่างระหว่างชื่อสินค้า

            // รายละเอียดสินค้า
            Text(
              'รายละเอียด: ${product['description']}',
              style: TextStyle(
                fontSize: 16, // ขนาดตัวอักษรกำลังดี
                color: const Color.fromRGBO(106, 102, 157, 1), 
              ),
            ),
            const SizedBox(height: 12), // ช่องว่างระหว่างรายละเอียด

            // ราคา
            Text(
              'ราคา: ${product['price']} บาท',
              style: TextStyle(
                fontSize: 18, // ขนาดตัวอักษรใหญ่ขึ้นเล็กน้อย
                fontWeight: FontWeight.bold, // ทำให้ราคาดูเด่น
                color: Colors.green[700], 
              ),
            ),
            const SizedBox(height: 12), // ช่องว่างระหว่างราคา

            // จำนวนสินค้า
            Text(
              'จำนวน: ${product['quantity']} ชิ้น',
              style: TextStyle(
                fontSize: 16, // ขนาดตัวอักษรปกติ
                color: const Color.fromARGB(255, 128, 151, 112), // สีข้อความไม่เด่นมาก
              ),
            ),
          ],
        ),
      ),
    );
  }
}
