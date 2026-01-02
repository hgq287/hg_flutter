# hg_flutter

Template for Desktop & Mobile apps, inspired by Flutter & Dart.

## Getting Started

- [The Flutter command-line tool](https://docs.flutter.dev/reference/flutter-cli)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

## Commands

- Create platforms
  `flutter create --platforms macos .`
  `flutter create --platforms ios .`
  `flutter create --platforms web .`
  `flutter create --platforms android .`

## Generate New Project from Template

You can use this template to start a new project instantly. Instead of manually renaming files, use the included command to create a fresh copy with your own project name.

### What this does:

- Clones the template into a new folder named /out.

- Renames everything (folders, files, and code) to your new name.

- Sets up Flutter so you can start coding immediately.

#### Generate your project
To create a new project named `my_new_app` inside the `out/` folder:
```bash
make generate name=my_new_app
```

### Verify the name change:
```bash
make check name=my_app
```

### Clean up: To delete all generated projects in the /out folder:
```bash
make clean
```