
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo_app_rn/models/todo.dart';

void main() {
  group('Todo Model Tests', () {
    test('should create todo with required fields', () {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      expect(todo.title, 'Test Todo');
      expect(todo.description, 'Test Description');
      expect(todo.isCompleted, false);
      expect(todo.id, isNotEmpty);
    });

    test('should convert todo to JSON', () {
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      final json = todo.toJson();

      expect(json['title'], 'Test Todo');
      expect(json['description'], 'Test Description');
      expect(json['isCompleted'], false);
    });

    test('should create todo from JSON', () {
      final json = {
        'id': '123',
        'title': 'Test Todo',
        'description': 'Test Description',
        'isCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      };

      final todo = Todo.fromJson(json);

      expect(todo.id, '123');
      expect(todo.title, 'Test Todo');
      expect(todo.description, 'Test Description');
      expect(todo.isCompleted, false);
    });
  });
}

