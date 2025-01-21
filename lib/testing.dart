import 'package:flutter/material.dart';
//Method หลักทีRun
void main() {
runApp(MyApp());
}
//Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
const MyApp({super.key});
// This widget is the root of your application.
@override
Widget build(BuildContext context) {
return MaterialApp(
theme: ThemeData(
colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
useMaterial3: true,
),
home: testing(),
);
}
}
//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class testing extends StatefulWidget {
@override
State<testing> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<testing> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
//ส่วนการออกแบบหน้าจอ
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text('………'),
),
body: SingleChildScrollView(
//ส่วนการออกแบบหน้าจอ
),
);
}
}