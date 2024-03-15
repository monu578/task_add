import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_aap3/addtodolist/add_todo_model.dart';

class TodoForm extends StatefulWidget {
  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final TextEditingController _titleController = TextEditingController();
  final List<AddTodoModel> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? savedTodos = prefs.getStringList('todos');
    if (savedTodos != null) {
      setState(() {
        _todos.addAll(savedTodos.map((title) => AddTodoModel(title: title, isCompleted: false)).toList());
      });
    }
  }

  Future<void> _saveTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> todoTitles = _todos.map((todo) => todo.title).toList();
    await prefs.setStringList('todos', todoTitles);
  }

  void _addTodo() {
    final String title = _titleController.text.trim();
    if (title.isNotEmpty) {
      setState(() {
        _todos.add(AddTodoModel(title: title, isCompleted: false));
        _titleController.clear();
      });
      _saveTodos();
    }
  }

  void _toggleTodoComplete(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
    _saveTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'TODO Title',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addTodo,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  return Card(
                    child: ListTile(
                      title: Text(todo.title),
                      onTap: () {
                        _toggleTodoComplete(index);
                      },
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) {
                          _toggleTodoComplete(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
