# Simple Todo App

A simple todo application built with Flutter, demonstrating basic CRUD operations and persistent storage using `shared_preferences`.

## Features

*   Add new todo items
*   Edit existing todo items
*   Delete todo items
*   Toggle todo completion status
*   Filter todos (All, Active, Completed)
*   Persistent storage using `shared_preferences`
*   GitHub Actions for CI/CD (build APK and iOS)

## Getting Started

### Prerequisites

*   [Flutter SDK](https://flutter.dev/docs/get-started/install)
*   [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/Whymyhuman/Simple-todo-app-rn.git
    cd Simple-todo-app-rn
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run the application:**

    ```bash
    flutter run
    ```

    This will launch the app on your connected device or emulator. If you don't have one running, Flutter will prompt you to start one.

### Building for Release

To build a release APK for Android:

```bash
flutter build apk --release
```

The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

To build for iOS (requires macOS and Xcode):

```bash
flutter build ios --release --no-codesign
```

## Project Structure

```
lib/
├── main.dart
├── models/
│   └── todo.dart
├── screens/
│   ├── home_screen.dart
│   └── add_todo_screen.dart
├── widgets/
│   └── todo_item.dart
└── services/
    └── todo_service.dart
```

## Testing

To run all tests:

```bash
flutter test
```

## GitHub Actions

This project includes a GitHub Actions workflow (`.github/workflows/flutter-ci.yml`) that automatically builds and tests the application on every push and pull request to the `main` or `master` branches. It generates release APK and iOS artifacts.

## Contributing

Feel free to fork this repository, make changes, and submit pull requests. Any contributions are welcome!

## License

This project is licensed under the MIT License - see the LICENSE file for details. (Note: LICENSE file is not included in this example, but typically would be.)


