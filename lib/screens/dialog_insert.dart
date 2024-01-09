import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:messaging_app/custom_components.dart';
import 'package:messaging_app/models/model_todo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DialogInsert extends StatefulWidget {
  const DialogInsert({super.key, required this.isEdit, required this.uid});
  final bool isEdit;
  final String uid;

  @override
  State<DialogInsert> createState() => _DialogInsertState();
}

class _DialogInsertState extends State<DialogInsert> {
  var titleController = TextEditingController();
  var descController = TextEditingController();
  DateTime? deadline;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: MyText(
            widget.isEdit ? 'Update Activity' : 'New Activity',
            weight: FontWeight.w600,
            size: 18,
          ),
        ),
        Divider(),
        const MyText(
          'Title',
          weight: FontWeight.w600,
        ),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
              filled: false,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2.h)),
              hintText: 'Enter title'),
        ),
        SizedBox(
          height: 2.h,
        ),
        const MyText(
          'Description',
          weight: FontWeight.w600,
        ),
        TextField(
          controller: descController,
          minLines: 3,
          maxLines: 3,
          decoration: InputDecoration(
              filled: false,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(2.h)),
              hintText: 'Enter description'),
        ),
        SizedBox(
          height: 2.h,
        ),
        const MyText(
          'Due date',
          weight: FontWeight.w600,
        ),
        InkWell(
          onTap: () async {
            showDatePicker(
                    context: context,
                    initialDate: deadline ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100, 12, 12))
                .then((value) {
              if (value != null) {
                setState(() {
                  deadline = value;
                });
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(2.h)),
            padding: EdgeInsets.all(2.h),
            child: Row(children: [
              Expanded(
                child: MyText(deadline != null
                    ? DateFormat('EEEE, dd MMMM yyyy').format(deadline!)
                    : 'Pick due date'),
              ),
              const Icon(
                Icons.calendar_month_outlined,
                color: Colors.grey,
              )
            ]),
          ),
        ),
        Spacer(),
        FillButton(
          onClick: () {
            if (titleController.text.isEmpty) {
              Fluttertoast.showToast(msg: 'Please fill the title');
              return;
            }
            if (descController.text.isEmpty) {
              Fluttertoast.showToast(msg: 'Please fill the description');
              return;
            }
            if (deadline == null) {
              Fluttertoast.showToast(msg: 'Pick a due date');
              return;
            }

            var data = ModelTodo(
                todoId: '-',
                todoTitle: titleController.text,
                todoDesc: descController.text,
                todoDeadline: deadline ?? DateTime.now(),
                todoStatus: '0',
                userId: widget.uid,
                timestamp: DateTime.now());
            Navigator.pop(context, data);
          },
          label: widget.isEdit ? 'Update activity' : 'Add new activity',
          background: accentColor,
        )
      ],
    );
  }
}
