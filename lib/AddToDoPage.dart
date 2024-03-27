import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AddToDoPage extends StatefulWidget {
  final VoidCallback? onItemAdded;

  const AddToDoPage({Key? key, this.onItemAdded}) : super(key: key);

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  final TextEditingController newItemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New To Do Item"),
      ),
      body: ListView(
        children: [
          TextField(
              controller: newItemController,
              decoration: InputDecoration(hintText: "To Do List Item")),
          Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: ElevatedButton(
              onPressed: () => {addNewItem(newItemController.text)},
              child: Text("Add To List"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addNewItem(String newItemText) async {
    final requestBody = {
      "id": Uuid().toString(),
      "task": newItemText,
      "completed": false,
    };

    final url = Uri.parse("http://34.227.52.187/api/todos");

    final response = await http.post(
      url,
      body: jsonEncode(requestBody),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 201) {
      newItemController.text = '';
      widget.onItemAdded?.call();
      navBackToHome(context);
    }
  }

  void navBackToHome(BuildContext context) {
    Navigator.pop(context);
  }
}
