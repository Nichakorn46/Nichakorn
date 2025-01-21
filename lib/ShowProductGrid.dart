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
      home: ShowProductGrid(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class ShowProductGrid extends StatefulWidget {
  @override
  State<ShowProductGrid> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ShowProductGrid> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป

// สร้าง referenceชื่อ dbRef ไปยังตารางชื่อ products
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
//load ข้อมูล Products มาเก็บไว้
  List<Map<String, dynamic>> products = [];
  Future<void> fetchProducts() async {
    try {
      //โค้ดแบบฝึก final query = dbRef.orderByChild('quantity').startAt(5);//
// ดึงข้อมูลจาก Realtime Database
      final snapshot = await dbRef.get();
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
// **เรียงลําดับข้อมูลตามราคา จากน้อยไปมาก**
        loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));
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

//ฟังก์ชันที่ใช้ลบ
  void deleteProduct(String key, BuildContext context) {
//คําสั่งลบโดยอ้างถึงตัวแปร dbRef ที่เชือมต่อตาราง product ไว้
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
      fetchProducts();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

//ฟังก์ชันถามยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิ ด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'ยืนยันการลบ',
            style: MyApp.titleTextStyle,
          ),
          content: Text(
            'คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?',
            style: MyApp.textTextStyle,
          ),
          actions: [
// ปุ่ มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ไม่ลบ'),
            ),
// ปุ่ มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
//ข้อความแจ้งว่าลบเรียบร้อย
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

//ฟังก์ชันแสดง AlertDialog หน้าจอเพื่อแก้ไขข้อมูล
  void showEditProductDialog(Map<String, dynamic> product) {
    //ตัวอย่างประกาศตัวแปรเพื่อเก็บค่าข้อมูลเดิมที่เก็บไว้ในฐานข้อมูล ดึงมาเก็บไว้ตัวแปรที่กําหนด
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    final TextEditingController quantityController =
        TextEditingController(text: product['price'].toString());
    final TextEditingController dateController = TextEditingController(text: product['date']);
    final categories = ['Electronics', 'Clothing', 'Food', 'Books'];
  String? selectedCategory;
  DateTime? productionDate;
  //สร้างฟังก์ชันให้เลือกวันที่
  Future<void> pickProductionDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: productionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != productionDate) {
      setState(() {
        productionDate = pickedDate;
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }
    //สร้าง dialog เพื่อแสดงข้อมูลเก่าและให้กรอกข้อมูลใหม่เพื่อแก้ไข
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController, //ดึงข้อมูลชื่อเก่ามาแสดงผลจาก
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller:
                      descriptionController, //ดึงข้อมูลรายละเอียดเก่ามาแสดงผล
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                SizedBox(height: 10,),
                DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                          labelText: 'ประเภทสินค้า',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      items: categories
                          .map((category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาเลือกประเภทสินค้า';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'วันที่ผลิตสินค้า',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => pickProductionDate(context),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาเลือกวันที่ผลิต';
                        }
                        return null;
                      },
                    ),
                TextField(
                  controller: priceController, //ดึงข้อมูลราคาเก่ามาแสดงผล
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: quantityController, //ดึงข้อมูลราคาเก่ามาแสดงผล
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
            // เตรียมข้อมูลที่แก้ไขแล้ว
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': int.parse(priceController.text),
                  'quantity': int.parse(quantityController.text),
                  'category': selectedCategory,
                  'productionDate': productionDate?.toIso8601String(),
                };
                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts(); // เรียกใช้ฟังก์ชันเพื่อโหลดข้อมูลใหม่เพื่อแสดงผลหลังการแก้ไขเช่น fetchProducts
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
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
        title: Text(
          'รายการสินค้า',
          style: MyApp.titleTextStyle,
        ),
        backgroundColor: Color.fromRGBO(205, 235, 184, 1),
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // จํานวนคอลัมน์
                crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
                mainAxisSpacing: 10, // ระยะห่างระหว่างแถว
              ),
              itemCount: products.length, // จํานวนรายการ
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    //รอใส่codeว่ากดแล้วเกิดอะไรขึ้น
                    //เมื่อกดที่แต่ละรายการจะเกิดอะไรขึ้น
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => productdetail(product: product),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5, // ความสูงของเงา (ช่วยเพิ่มมิติ)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // ขอบมน
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Text(product['name']),
                          Text('ราคา : ${product['price']} บาท'),
                          SizedBox(
                            height: 70,
                          ),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 80,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, // รูปทรงวงกลม
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        // กดปุ่มลบแล้วจะให้เกิดอะไรขึ้น
                                        showDeleteConfirmationDialog(
                                            product['key'], context);
                                      },
                                      icon: Icon(Icons.delete),
                                      color: const Color.fromRGBO(
                                          154, 191, 128, 1), // สีของไอคอน
                                      iconSize: 20,
                                      tooltip: 'ลบสินค้า',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle, // รูปทรงวงกลม
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      // กดปุ่มลบแล้วจะให้เกิดอะไรขึ้น
                                      showEditProductDialog(product);
                                    },
                                    icon: Icon(Icons.edit_rounded),
                                    color: const Color.fromRGBO(
                                        154, 191, 128, 1), // สีของไอคอน
                                    iconSize: 20,
                                    tooltip: 'แก้ไขสินค้า',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
