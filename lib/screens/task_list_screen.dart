import 'package:flutter/material.dart';
import 'package:todo_list/screens/home_screen.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _descriptionFieldController =
      TextEditingController();
  final List<Todo> _todos = <Todo>[];
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  final TimeOfDayFormat timeFormat = TimeOfDayFormat.HH_colon_mm;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text('To Do'),
          // actions: const [
          //   Padding(
          //     padding: EdgeInsets.all(8.0),
          //     child: CircleAvatar(
          //       backgroundColor: kPrimaryLightColor,
          //     ),
          //   )
          // ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text(
                            'Today Reminder',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Meeting with client',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            '13.00 PM',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.9,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 80),
                        child: const Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 18.0,
                        ),
                      ),
                    ])),
          )),
      body: _todos.isNotEmpty
          ? ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: _todos.map((Todo todo) {
                return TodoItem(
                  todo: todo,
                  onTodoChanged: _handleTodoChange,
                );
              }).toList())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/noTask.png'),
                  const SizedBox(height: 25),
                  const Text('No Tasks')
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayDialog();
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColor,
        elevation: 10,
        focusColor: kPrimaryLightColor,
      ),
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a new todo item'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameFieldController,
                  decoration:
                      const InputDecoration(hintText: 'Type your new todo'),
                ),
                TextField(
                  controller: _descriptionFieldController,
                  decoration:
                      const InputDecoration(hintText: 'Add description'),
                ),
                ElevatedButton(
                  onPressed: (() async {
                    selectedDate = await _selectDateTime(context);
                    if (selectedDate == null) return;
                    print(selectedDate);
                  }),
                  child: const Text('Date'),
                ),
                ElevatedButton(
                  onPressed: (() async {
                    selectedTime = await _selectTime(context);
                    if (selectedTime == null) return;
                  }),
                  child: const Text('time'),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    if (_nameFieldController.text.isNotEmpty) {
                      _addTodoItem(
                          _nameFieldController.text,
                          _descriptionFieldController.text,
                          dateFormat.format(selectedDate!),
                          selectedTime!.format(context));
                    }

                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Add'))
            ],
          );
        });
  }

  void _addTodoItem(String name, String description, String date, String time) {
    setState(() {
      _todos.add(Todo(
          name: name,
          description: description,
          date: date,
          time: time,
          checked: false));
    });
    _nameFieldController.clear();
    _descriptionFieldController.clear();
  }
}

Future<DateTime?> _selectDateTime(BuildContext context) => showDatePicker(
    context: context,
    initialDate: DateTime.now().add(Duration(seconds: 1)),
    firstDate: DateTime.now(),
    lastDate: DateTime(2050));

Future<TimeOfDay?> _selectTime(BuildContext context) async {
  final now = DateTime.now();
  return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute));
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;

  // ignore: prefer_typing_uninitialized_variables
  final onTodoChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: kPrimaryLightColor,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: ListTile(
            onTap: () {
              onTodoChanged(todo);
            },
            leading: Checkbox(
              activeColor: kPrimaryLightColor,
              onChanged: (bool? value) {},
              value: todo.checked,
            ),
            trailing: Column(
              children: [
                const SizedBox(height: 10),
                Text(todo.date),
                Text(todo.time),
              ],
            ),
            title: Text(todo.name, style: _getTextStyle(todo.checked)),
            subtitle: Text(todo.description),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 228, 228, 228),
              blurRadius: 10.0,
              spreadRadius: 5.0, 
         
            )
          ],
        ),
      ),
    );
  }
}

