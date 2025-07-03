
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    _todos = await _todoService.getTodos();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveTodos() async {
    await _todoService.saveTodos(_todos);
  }

  void _addTodo(Todo todo) {
    setState(() {
      _todos.add(todo);
    });
    _saveTodos();
  }

  void _updateTodo(Todo updatedTodo) {
    setState(() {
      _todos = _todos.map((todo) {
        return todo.id == updatedTodo.id ? updatedTodo : todo;
      }).toList();
    });
    _saveTodos();
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.removeWhere((item) => item.id == todo.id);
    });
    _saveTodos();
  }

  void _toggleComplete(Todo todo) {
    _updateTodo(Todo(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: !todo.isCompleted,
      createdAt: todo.createdAt,
    ));
  }

  Future<void> _showTodoForm({Todo? todo}) async {
    final result = await showModalBottomSheet<Todo>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddTodoScreen(todo: todo),
        );
      },
    );

    if (result != null) {
      if (todo == null) {
        _addTodo(result);
      } else {
        _updateTodo(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Todo App'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _todos.isEmpty
              ? const Center(child: Text('No todos yet! Add one below.'))
              : ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (context, index) {
                    final todo = _todos[index];
                    return TodoItem(
                      todo: todo,
                      onToggleComplete: _toggleComplete,
                      onEdit: (t) => _showTodoForm(todo: t),
                      onDelete: _deleteTodo,
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTodoScreen extends StatefulWidget {
  final Todo? todo;

  const AddTodoScreen({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  var uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController = TextEditingController(text: widget.todo?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      final newTodo = Todo(
        id: widget.todo?.id ?? uuid.v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: widget.todo?.isCompleted ?? false,
        createdAt: widget.todo?.createdAt ?? DateTime.now(),
      );
      Navigator.of(context).pop(newTodo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.todo == null ? 'Add New Todo' : 'Edit Todo',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTodo,
                child: Text(widget.todo == null ? 'Add Todo' : 'Update Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

