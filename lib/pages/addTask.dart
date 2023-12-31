// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/pages/homepage.dart';
import 'package:todo_app/utils/snakbar.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: "Title"),
        ),
        TextField(
          controller: descController,
          decoration: const InputDecoration(hintText: "Description"),
          minLines: 5,
          maxLines: 8,
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: () {
              submitData();
            },
            child: const Text("Submit"))
      ]),
    );
  }

  Future<void> submitData() async {
    final body = {
      "title": titleController.text,
      "description": descController.text,
      "is_completed": false
    };

    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      showSnackBar(context, "Saved Successfully");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } else {
      showSnackBar(context, "Something went wrong! Please try again");
    }
  }
}
