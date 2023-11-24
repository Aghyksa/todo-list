// ignore_for_file: use_build_context_synchronously, file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart'
as http;
import 'package:todo_app/utils/snakbar.dart';

class EditTaskScreen extends StatefulWidget {
  final Map task;

  const EditTaskScreen({
    Key ? key,
    required this.task
  }): super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State < EditTaskScreen > {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task['title']);
    descriptionController = TextEditingController(text: widget.task['description']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implement the update logic here
                  updateTask(widget.task['_id']);
                },
                child: const Text('Update Task'),
              ),
            ],
          ),
      ),
    );
  }

  Future < void > updateTask(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    // Assuming you have a Map containing updated task details
    final updatedTask = {
      'title': titleController.text,
      'description': descriptionController.text,
    };

    final response = await http.put(uri, body: updatedTask);

    if (response.statusCode == 200) {
      showSnackBar(context, "Task updated successfully");
      Navigator.pop(context, true);
    } else {
      showSnackBar(context, "Failed to update task. Please try again.");
      Navigator.pop(context, false);
    }
  }
}