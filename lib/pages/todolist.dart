import 'package:flutter/material.dart';
import 'package:todolist/pages/add.dart';

// HTTP methob
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:todolist/pages/update_todolist.dart';

class Todolist extends StatefulWidget {
  const Todolist({Key? key}) : super(key: key);

  @override
  _TodolistState createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  // เพิ่มตัวแปร เพื่อไปใช้ใน itemeCount
  List todolistitems = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodolist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddPage()))
              .then((value) {
            // back กลับ จะรีเฟรสหน้าใหม่
            // setState การรีเฟรชหน้าใหม่
            setState(() {
              getTodolist();
            });
          });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              //print(" ลบรายการ ID: $_v1"); // ส่งไอดีไปแสดง
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ))
      ], title: Text("All Todolist")),
      body: todolistCreate(),
    );
  }

  Widget todolistCreate() {
    return ListView.builder(
        itemCount: todolistitems.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(" ${todolistitems[index]['title']}"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdatePage(
                            todolistitems[index]['id'],
                            todolistitems[index]['title'],
                            todolistitems[index]['detail']))).then((value) {
                  // setState การรีเฟรชหน้าใหม่
                  setState(() {
                    print(value);
                    // ฟังก์ชั่นตรวจสอบ การลบ
                    if (value == 'delete') {
                      final snackBar = SnackBar(
                        content: const Text('ลบรายการเรียบร้อยแล้ว'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    getTodolist();
                  });
                });
              },
            ),
          );
        });
  }

  Future<void> getTodolist() async {
    List alltodo = [];
    var url = Uri.http(
        'uncleapi.com:8448', // ใช้ server ลุง
        '/api/all-todolist'); //192.168.0.145:8000/ ip ของเครื่อง //ให้รัน python manage.py runserver 0.0.0.0:8000
    var response = await http.get(url);
    var result = utf8.decode(response.bodyBytes);
    print(result);

    setState(() {
      todolistitems = jsonDecode(result);
    });
  }

  // Future getData() async {
  //   //https://raw.githubusercontent.com/4qwc/BasicAPI/main/data.json
  //   // https://raw.githubusercontent.com/UncleEngineer/BasicAPI/main/data.json
  //   var url =
  //       Uri.https('raw.githubusercontent.com', '/4qwc/BasicAPI/main/data.json');
  //   var response = await http.get(url);
  //   var result = json.decode(response.body);
  //   return result;
  // }
}
