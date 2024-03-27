import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddToDoPage.dart';
import 'TaskItem.dart';

class ToDo extends StatefulWidget {
  const ToDo({Key? key}) : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  List<TaskItem> toDoItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllToDos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To Do App")),
      body: RefreshIndicator(
        onRefresh: getAllToDos,
        child: showToDoItems(),
      ),
      floatingActionButton: buildButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget showToDoItems() {
    toDoItems.sort((a, b) {
      if (a.completed && !b.completed) {
        return 1;
      } else if (!a.completed && b.completed) {
        return -1;
      } else {
        return 0;
      }
    });

    return ListView.builder(
      itemCount: toDoItems.length,
      itemBuilder: (context, index) {
        final item = toDoItems[index];
        return ListTile(
          leading: Checkbox(
            value: item.completed,
            onChanged: (bool? value) {
              updateItem(item);
            },
          ),
          title: Text(item.task),
          trailing: PopupMenuButton(
            onSelected: (value) {
              deleteItem(item.id);
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  child: Text("Delete"),
                  value: "delete",
                )
              ];
            },
          ),
        );
      },
    );
  }

  Widget buildButton() {
    const BUTTON_RADIUS = 75.0;

    return FloatingActionButton.extended(
      onPressed: navToNewItemPage,
      label: const Text(
        "+",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BUTTON_RADIUS),
      ),
    );
  }

  void updateItem(TaskItem item) async {
    final id = item.id;
    final requestBody = {
      "completed": !item.completed,
    };
    final url = Uri.parse('http://34.227.52.187/api/todos/$id');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      getAllToDos();
    }
  }

  Future<void> deleteItem(int id) async {
    final url = Uri.parse('http://34.227.52.187/api/todos/$id');
    final response = await http.delete(url); // await the response
    if (response.statusCode == 200) {
      // check the status code
      final listAfterDelete =
          toDoItems.where((element) => element.id != id).toList();
      setState(() {
        toDoItems = listAfterDelete;
      });
    }
  }

  void navToNewItemPage() {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(
        onItemAdded: getAllToDos,
      ),
    );
    Navigator.push(context, route);
  }

  Future<void> getAllToDos() async {
    final url = Uri.parse('http://34.227.52.187/api/todos');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        toDoItems = (jsonDecode(response.body) as List)
            .map((data) => TaskItem.fromJson(data))
            .toList();
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
