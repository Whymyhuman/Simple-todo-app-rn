
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo_app_rn/models/todo.dart';
import 'package:simple_todo_app_rn/services/todo_service.dart';

void main() {
  group('TodoService Tests', () {
    late TodoService todoService;

    setUp(() {
      todoService = TodoService();
      SharedPreferences.setMockInitialValues({});
    });

    test('should add todo successfully', () async {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await todoService.saveTodos([todo]);

      final todos = await todoService.getTodos();
      expect(todos.length, 1);
      expect(todos.first.title, 'Test Todo');
    });

    test('should update todo successfully', () async {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await todoService.saveTodos([todo]);
      
      final updatedTodo = Todo(
        id: '1',
        title: 'Updated Todo',
        description: 'Updated Description',
        isCompleted: true,
        createdAt: todo.createdAt,
      );
      
      await todoService.saveTodos([updatedTodo]);

      final todos = await todoService.getTodos();
      expect(todos.first.title, 'Updated Todo');
      expect(todos.first.isCompleted, true);
    });

    test('should delete todo successfully', () async {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await todoService.saveTodos([todo]);
      expect((await todoService.getTodos()).length, 1);

      await todoService.saveTodos([]);

      final todos = await todoService.getTodos();
      expect(todos.length, 0);
    });
  });
}

