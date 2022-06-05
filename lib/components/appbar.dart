import 'package:flutter/material.dart';
import 'package:todo_list/constants.dart';

Widget appBar(BuildContext context) {
  return PreferredSize(
    preferredSize: Size.fromHeight(210.0),
    child: AppBar(
      leading: const Text('Hello User'),
      title: const Text('To Do'),
      actions: const [
        CircleAvatar(
          backgroundColor: kPrimaryColor,
        )
      ],
      flexibleSpace: Container(
        width: 200,
        height: 100,
        color: kPrimaryColor,
      ),
    ),
  );
}
