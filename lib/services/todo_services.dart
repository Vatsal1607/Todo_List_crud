import 'dart:convert';

import 'package:http/http.dart' as http;

// All todo api call will be here
class TodoServices{
  static Future<bool> deleteById(String id) async {
    final url = Uri.parse('http://api.nstack.in/v1/todos/$id');
    final response = await http.delete(url);
    return response.statusCode == 200;
  }

  static Future<List?> fetchTodo() async {
    final url = Uri.parse('http://api.nstack.in/v1/todos?page=1&limit=10');
    final response = await http.get(url);
    if(response.statusCode == 200){
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> updateData(String id, Map body) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri, body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json'
        }
    );
    return response.statusCode == 200;
  }

  static Future<bool> addTodo(Map body) async {
    final url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    // Error was occured when change forgot in http.put to post //
    final response = await http.post(uri, body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json'
        }
    );
    return response.statusCode == 201;
  }
}