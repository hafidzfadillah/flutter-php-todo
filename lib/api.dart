import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:messaging_app/models/model_news.dart';
import 'package:messaging_app/models/model_todo.dart';

import 'models/model_user.dart';

class API {
  final getTodo =
      "https://12b1-103-104-130-8.ngrok-free.app/todo/api/getTodo.php";
  final addTodo =
      "https://12b1-103-104-130-8.ngrok-free.app/todo/api/addTodo.php";
  final udtTodo =
      "https://12b1-103-104-130-8.ngrok-free.app/todo/api/udtTodo.php";
  final delTodo =
      "https://12b1-103-104-130-8.ngrok-free.app/todo/api/delTodo.php";

  final addUser =
      "https://12b1-103-104-130-8.ngrok-free.app/todo/api/addUser.php";

  final getNews = "https://newsapi.org/v2/top-headlines";

  static const NEWS_API_KEY = "405b0604b62c47fa8cb76f5ccd207287";

  Future<http.Response> tambahUser(ModelUser user) async {
    await Future.delayed(Duration(milliseconds: 100));

    var param =
        "?uid=${user.userUid}&email=${user.userEmail}&nama=${user.userNama}&img=${user.userImg}";
    var fullUrl = Uri.parse(addUser + param);

    var response = await http.get(fullUrl);

    return response;
  }

  Future<List<ModelTodo>> getTodoList(userID) async {
    await Future.delayed(Duration(milliseconds: 100));

    var param = "?uid=$userID";
    var fullUrl = Uri.parse(getTodo + param);

    var response = await http.get(fullUrl);
    print(response.body);

    if (response.statusCode == 200) {
      var parse = json.decode(response.body);
      List list = parse['data'];
      List<ModelTodo> finallist =
          list.map((e) => ModelTodo.fromJson(e)).toList();

      return finallist;
    }

    return [];
  }

  Future<http.Response> tambahTodo(ModelTodo todo) async {
    await Future.delayed(Duration(milliseconds: 100));

    var dl = DateFormat('yyyy-MM-dd HH:mm:ss').format(todo.todoDeadline);

    var param =
        "?title=${todo.todoTitle}&desc=${todo.todoDesc}&status=${todo.todoStatus}&deadline=$dl&uid=${todo.userId}";
    var fullUrl = Uri.parse(addTodo + param);
    print(fullUrl);

    var response = await http.get(fullUrl);
    print(response.body);

    return response;
  }

  Future<http.Response> updateTodo(ModelTodo todo) async {
    await Future.delayed(Duration(milliseconds: 100));

    var dl = DateFormat('yyyy-MM-dd HH:mm:ss').format(todo.todoDeadline);

    var param =
        "?title=${todo.todoTitle}&desc=${todo.todoDesc}&status=1&deadline=$dl&id=${todo.todoId}";
    var fullUrl = Uri.parse(udtTodo + param);

    var response = await http.get(fullUrl);

    return response;
  }

  Future<http.Response> deleteTodo(id) async {
    await Future.delayed(Duration(milliseconds: 100));

    var param = "?id=$id";
    var fullUrl = Uri.parse(delTodo + param);

    var response = await http.get(fullUrl);

    return response;
  }

  Future<List<Article>> getNewsHeadlines() async {
    await Future.delayed(Duration(milliseconds: 100));

    var param = "?country=id&category=technology&apiKey=$NEWS_API_KEY";
    var fullUrl = Uri.parse(getNews + param);

    var response = await http.get(fullUrl);
    print(response.body);

    if (response.statusCode == 200) {
      var parse = json.decode(response.body);
      ModelNews news = ModelNews.fromJson(parse);
      List<Article> finallist = news.articles;

      return finallist;
    }

    return [];
  }
}
