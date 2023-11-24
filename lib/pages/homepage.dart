// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/pages/addTask.dart';
import 'package:todo_app/pages/editTask.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/utils/snakbar.dart';

class HomePage extends StatefulWidget {
    const HomePage({
        super.key
    });

    @override
    State < HomePage > createState() => _HomePageState();
}

class _HomePageState extends State < HomePage > {
    List items = [];
    @override
    void initState() {
        super.initState();
        fetchTodo();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Center(child: Text("Todo List")),
            ),
            floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const AddTaskScreen()));
                },
                label: const Text("Add Task")),
            body: RefreshIndicator(
                onRefresh: fetchTodo,
                child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                        final item = items[index] as Map;
                        final id = item['_id'] as String;
                        return Card(
                            child: Container(
                                margin: const EdgeInsets.all(12),
                                child: ListTile(
                                    leading: CircleAvatar(child: Text("${index + 1}")),
                                    title: Text(item['title']),
                                    subtitle: Text(item['description']),
                                    trailing: PopupMenuButton(onSelected: (value) async {
                                        if (value == 'Edit') 
                                        {
                                            final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                builder: (context) => EditTaskScreen(task: item),
                                                ),
                                            );
                                            if (result == true) {
                                                // Jika pembaruan berhasil, muat ulang daftar
                                                await fetchTodo();
                                            }
                                        } 
                                        else if (value == 'Delete') 
                                        {
                                            deleteById(id);
                                        }
                                    }, itemBuilder: (context) {
                                        return [
                                            const PopupMenuItem(
                                                value: 'Edit',
                                                child: Text('Edit'),
                                            ),
                                            const PopupMenuItem(
                                                value: 'Delete',
                                                child: Text(
                                                    'Delete',
                                                ),
                                            )
                                        ];
                                    }),
                                ),
                            ),
                        );
                    }),
            ),
        );
    }

    Future < void > fetchTodo() async {
        const url = 'https://api.nstack.in/v1/todos';
        final uri = Uri.parse(url);
        final response = await http.get(uri);
        if (response.statusCode == 200) {
            final json = jsonDecode(response.body);
            final result = json['items'] as List;
            setState(() {
                items = result;
            });
        } else {}
    }

    Future < void > deleteById(String id) async {
        final url = 'https://api.nstack.in/v1/todos/$id';
        final uri = Uri.parse(url);
        final response = await http.delete(uri);
        if (response.statusCode == 200) {
            showSnackBar(context, "Deleted Successfully");
            fetchTodo();
        } else {
            showSnackBar(context, "Something went wrong! Please try again");
        }
    }
    
}