import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String _userToDo;
  List<String> todoList = [];

  void saveList(List<String> todoList) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('todo', todoList);
  }

  Future<void> getList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String> todo = prefs.getStringList('todo') ?? [];
      todoList = todo;
    });
  }

  void removeTask(int index) {
    setState(() {
      todoList.removeAt(index);
      saveList(todoList);
    });
  }

  @override
  Widget build(BuildContext context) {
    getList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Список дел'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(todoList[index]),
            child: Card(
              color: Colors.lightBlueAccent,
              child: ListTile(
                title: Text(
                  todoList[index],
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_sweep,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    removeTask(index);
                  },
                ),
              ),
            ),
            onDismissed: (direction) {
              removeTask(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text('Добавить задачу'),
                content: TextField(
                  onChanged: (String value) {
                    _userToDo = value;
                  },
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        todoList.add(_userToDo);
                        saveList(todoList);
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Добавить',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add, size: 30.0, color: Colors.white),
      ),
    );
  }
}
