import 'dart:convert';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messaging_app/api.dart';
import 'package:messaging_app/custom_components.dart';
import 'package:messaging_app/models/model_todo.dart';
import 'package:messaging_app/screens/dialog_insert.dart';
import 'package:messaging_app/screens/homepage.dart';
import 'package:messaging_app/screens/news.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../signin_helper.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  var currIndex = 0;
  var userID = '';

  var pageList = [
    HomeScreen(),
    NewsPage(),
  ];

  void getUserData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      userID = pref.getString(USER_ID) ?? '';
    });
  }

  void addTodo(ModelTodo todo) async {
    EasyLoading.show(status: 'Please wait');
    final rsp = await API().tambahTodo(todo);

    // if (rsp.statusCode == 201) {
    var parse = json.decode(rsp.body);
    if (parse['status'] == 201) {
      EasyLoading.showSuccess(parse['message']);
    } else {
      EasyLoading.showError(parse['message']);
    }
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[currIndex],
      backgroundColor: primaryColor.withOpacity(0.3),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalSheet(
              context,
              65.h,
              DialogInsert(
                isEdit: false,
                uid: userID,
              )).then((value) {
            addTodo(value);
          });
        },
        child: Icon(Icons.add),
        backgroundColor: accentColor,
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          animationDuration: Duration(milliseconds: 300),
          onTap: (value) {
            setState(() {
              currIndex = value;
            });
          },
          items: [
            CurvedNavigationBarItem(
                child: Icon(
                  Icons.format_list_bulleted,
                  color: currIndex == 0 ? primaryColorDark : blackColor,
                ),
                label: 'Activities'),
            CurvedNavigationBarItem(
                child: Icon(
                  Icons.newspaper_outlined,
                  color: currIndex == 1 ? primaryColorDark : blackColor,
                ),
                label: 'News')
          ]),
    );
  }
}
