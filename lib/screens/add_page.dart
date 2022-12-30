import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list_crud/services/todo_services.dart';
import 'package:todo_list_crud/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if(widget.todo != null){
      isEdit = true;
      final title = todo!['title'];
      final description = todo!['description'];
      titleController.text = title;
      descController.text = description;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Title'
            ),
          ),
          const SizedBox(height: 20,),
          TextFormField(
            controller: descController,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
            decoration: const InputDecoration(
                hintText: 'Description'
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(isEdit ? 'Update' : 'Submit'),
              ) 
              ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    // Get the data from form
    final todo = widget.todo;
    if(todo == null){
      print('You can not call updated without todo data');
      return;
    }
    final id = todo['_id'];

    // submit updated data to the server
    final isSuccess = await TodoServices.updateData(id, body);
    // show success or fail message based on status
    if(isSuccess){
      showSuccessMessage(context, message: 'Updation Success');
    } else {
      showErrorMessage(context, message: 'Updation failed');
    }
  }

  Future<void> submitData() async {
    // Submit data to the server
      // final response = await http.post(Uri.parse('http://api.nstack.in/v1/todos'));
    final url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final isSuccess = await TodoServices.addTodo(body);
    // show success or fail message based on status
    if(isSuccess){
      titleController.text = '';
      descController.text = '';
      showSuccessMessage(context, message: 'Creation Success');
    } else {
      showErrorMessage(context, message: 'Error');
    }
  }
  Map get body {
    // get the data from form
    final title = titleController.text;
    final description = descController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
