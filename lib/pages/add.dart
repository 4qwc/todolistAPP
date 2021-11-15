import 'package:flutter/material.dart';

// HTTP method package
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  // สำหรับเก็บข้อมูล user กรอกเข้ามา เหมือนกับ StringVar()
  TextEditingController todo_title = TextEditingController(); //ช่องเก็บจำนวน
  TextEditingController todo_detail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มรายการใหม่"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            // ช่องกรอกข้อมูล
            TextField(
                controller: todo_title, //ลิ้งค์กับ controller ด้านบน
                decoration: InputDecoration(
                    labelText: "หัวข้อ", border: OutlineInputBorder())),
            //
            SizedBox(
              height: 30,
            ),
            // ช่องกรอกข้อมูล
            TextField(
                minLines: 4, // กำหนด บรรทัด ที่กรอกรายละเอียด
                maxLines: 8,
                controller: todo_detail, //ลิ้งค์กับ controller ด้านบน
                decoration: InputDecoration(
                    labelText: "รายละเอียด", border: OutlineInputBorder())),
            SizedBox(
              height: 30,
            ),

            //
            // ปุมเพิ่มข้อมูล
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: ElevatedButton(
                onPressed: () {
                  // print('--------- Result ----------');
                  // print('title : $todo_title');
                  // print('Detail: $todo_detail');
                  final snackBar =
                      SnackBar(content: const Text('เพิ่มรายการเรียบร้อยแล้ว'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  postTodo();

                  setState(() {
                    todo_title.clear(); // เคลีย ช่องกรอก
                    todo_detail.clear();
                  });
                },
                child: Text("เพิ่ม"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(60, 10, 60, 10)),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 30))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  // ฟิวเจอร์ฟังก์ชั่น ส่ง data ไป server
  // ไปใช้ที่ onPressed: ()
  Future postTodo() async {
    var url = Uri.http(
        'uncleapi.com:8448', // // ใช้ server ลุง http ใช้สำหรับทดสอบใน local
        '/api/post-todolist'); //  url  api post นำมาจาก post เท่านั้น

    // สำหรับเทส nrok
    // var url = Uri.https(
    //     'b768-223-24-146-171.ngrok.io', // สำหรับเทส nrok
    //     '/api/post-todolist'); //  url  api post นำมาจาก post เท่านั้น

    Map<String, String> header = {"Content-type": "application/json"};
    // String jsondata =
    //     '{"title" : "เรียนเขียนแอพ flutter " , "detail":"เรียนผ่านเฟสบุ๊คทุกวันเสาร์"}';

    String jsondata =
        '{"title":"${todo_title.text}", "detail":"${todo_detail.text}"}';
    var response = await http.post(url, headers: header, body: jsondata);
    print("------ result ------");
    print(response.body); // ดูผลลัพธ์
  }
}
