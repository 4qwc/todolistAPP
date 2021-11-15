import 'package:flutter/material.dart';

// HTTP method package
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class UpdatePage extends StatefulWidget {
  final v1, v2, v3;
  const UpdatePage(this.v1, this.v2, this.v3);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  var _v1, _v2, _v3;
  // สำหรับเก็บข้อมูล user กรอกเข้ามา เหมือนกับ StringVar()
  TextEditingController todo_title = TextEditingController(); //ช่องเก็บจำนวน
  TextEditingController todo_detail = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _v1 = widget.v1;
    _v2 = widget.v2;
    _v3 = widget.v3;

    // นำไปกรอก
    todo_title.text = _v2;
    todo_detail.text = _v3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไข"),
        actions: [
          IconButton(
              onPressed: () {
                print(" ลบรายการ ID: $_v1"); // ส่งไอดีไปแสดง
                deleteTodo();
                Navigator.pop(context, 'delete'); // ส่งค่า 'delete' ไป snacBar
                // เหมือนการกด back <
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
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
                  print('--------- Result ----------');
                  print('title : $todo_title');
                  print('Detail: $todo_detail');
                  updateTodo();
                  final snackBar = SnackBar(
                      content: const Text('อัพเดทรายการเรียบร้อยแล้ว'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text("แก้ไขรายการ"),
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
  Future updateTodo() async {
    var url = Uri.http(
        'uncleapi.com:8448', // http ใช้สำหรับทดสอบใน local
        '/api/update-todolist/$_v1'); //  url  api post นำมาจาก post เท่านั้น

    // สำหรับเทส nrok
    // var url = Uri.https(
    //     'b768-223-24-146-171.ngrok.io', // สำหรับเทส nrok
    //     '/api/post-todolist'); //  url  api post นำมาจาก post เท่านั้น

    Map<String, String> header = {"Content-type": "application/json"};
    // String jsondata =
    //     '{"title" : "เรียนเขียนแอพ flutter " , "detail":"เรียนผ่านเฟสบุ๊คทุกวันเสาร์"}';

    String jsondata =
        '{"title":"${todo_title.text}", "detail":"${todo_detail.text}"}';
    var response = await http.put(url, headers: header, body: jsondata);
    print("------ result ------");
    print(response.body); // ดูผลลัพธ์
  }

  Future deleteTodo() async {
    var url = Uri.http(
        '206.189.88.9:8585', // http ใช้สำหรับทดสอบใน local
        '/api/delete-todolist/$_v1');
    Map<String, String> header = {"Content-type": "application/json"};
    var response = await http.delete(url, headers: header);
    print("------ result ------");
    print(response.body); // ดูผลลัพธ์
  }
}
