import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:messaging_app/api.dart';
import 'package:messaging_app/custom_components.dart';
import 'package:messaging_app/models/model_todo.dart';
import 'package:messaging_app/screens/onboarding.dart';
import 'package:messaging_app/signin_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userImg =
      'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';
  String? userID;
  List<ModelTodo> todolist = [];

  void getUserData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      userImg = pref.getString(USER_IMG)!;
      userID = pref.getString(USER_ID);
    });
    getTodo();
  }

  void getTodo() async {
    List<ModelTodo> list = await API().getTodoList(userID);

    list.sort((a, b) => a.todoDeadline.compareTo(b.todoDeadline));

    setState(() {
      todolist = list;
    });
  }

  void updateTodo(ModelTodo todo) async {
    EasyLoading.show(status: 'Please wait');
    final rsp = await API().updateTodo(todo);

    var parse = json.decode(rsp.body);
    if (parse['status'] == 201) {
      EasyLoading.showSuccess(parse['message']);
    } else {
      EasyLoading.showError(parse['message']);
    }
  }

  void deleteTodo(String id) async {
    EasyLoading.show(status: 'Please wait');
    final rsp = await API().deleteTodo(id);

    var parse = json.decode(rsp.body);
    if (parse['status'] == 201) {
      EasyLoading.showSuccess(parse['message']);
    } else {
      EasyLoading.showError(parse['message']);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Topbar(
          title: 'My Activities',
          action: InkWell(
            onTap: () {
              showConfirmationDialog(
                      context, 'Sign out', 'Are you sure you want to sign out?')
                  .then((value) async {
                if (value) {
                  await GoogleSignInHelper().signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => OnboardingScreen()),
                      (route) => false);
                }
              });
            },
            child: CircleAvatar(
              radius: 3.h,
              backgroundColor: blackColor,
              backgroundImage: NetworkImage(userImg),
            ),
          ),
        ),
        Expanded(
            child: todolist.isNotEmpty
                ? ListView.separated(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(2.h),
                    itemCount: todolist.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 2.h,
                    ),
                    itemBuilder: (context, index) => CardTodo(
                      data: todolist[index],
                      onDone: (context) {
                        print('DONE');
                        updateTodo(todolist[index]);
                      },
                      onDelete: (context) {
                        print('DELETE');
                        deleteTodo(todolist[index].todoId);
                      },
                    ),
                  )
                : Center(
                    child: OutlinedButton(
                        onPressed: () {
                          getTodo();
                        },
                        child: MyText('Refresh')),
                  ))
      ],
    );
  }
}

class CardTodo extends StatefulWidget {
  const CardTodo(
      {super.key,
      required this.data,
      required this.onDone,
      required this.onDelete});
  final ModelTodo data;
  final Function(BuildContext context) onDone;
  final Function(BuildContext context) onDelete;

  @override
  State<CardTodo> createState() => _CardTodoState();
}

class _CardTodoState extends State<CardTodo> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: widget.data.todoStatus == '1'
          ? null
          : ActionPane(motion: BehindMotion(), children: [
              SlidableAction(
                onPressed: widget.onDone,
                icon: Icons.done,
                label: 'Done',
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              )
            ]),
      endActionPane: ActionPane(motion: BehindMotion(), children: [
        SlidableAction(
          onPressed: widget.onDelete,
          icon: Icons.delete,
          label: 'Delete',
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        )
      ]),
      child: MyCard(
          child: ExpansionTile(
        childrenPadding: EdgeInsets.fromLTRB(4.h, 2.h, 2.h, 2.h),
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        leading: widget.data.todoStatus == '1'
            ? Image.asset(
                'assets/images/done.png',
                width: 3.h,
                height: 3.h,
              )
            : null,
        title: MyText(
          widget.data.todoTitle,
          maxLines: 2,
          weight: FontWeight.w600,
          size: 16,
        ),
        children: [
          MyText(
            widget.data.todoDesc,
            maxLines: 5,
          ),
          SizedBox(
            height: 1.h,
          ),
          MyText(
            'Due date: ${DateFormat('dd MMM yyyy').format(widget.data.todoDeadline)}',
            maxLines: 2,
            isItalic: true,
            color: Colors.grey,
          ),
        ],
      )),
    );
  }
}
