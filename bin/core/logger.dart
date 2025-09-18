import 'dart:async';
import 'dart:io';

class Logger {
  static String filePath(DateTime date) =>
      "${Directory.current.path}/logs/${date.year}_${date.month.toString().padLeft(2, '0')}_${date.day.toString().padLeft(2, '0')}.log";

  static void startup() {
    Directory("logs").createSync(recursive: true);
    Timer.periodic(const Duration(days: 1), (timer) {
      deleteOldLogFiles();
    });
    deleteOldLogFiles();
  }

  static void deleteOldLogFiles() {
    var date = DateTime.now().add(Duration(days: -7));
    var file = File(filePath(date));
    print("Try to clean ${file.path}");
    if (file.existsSync()) {
      file.delete();
    }
  }

  static File getFile() {
    return File(filePath(DateTime.now()));
  }

  static void writeOnFile(String message) {
    print(message);
    getFile().writeAsStringSync("$message\n", mode: FileMode.append);
  }

  static void log(Object message, {void Function(String message)? logFunction}) {
    (logFunction ?? writeOnFile).call(LogType.debug.header + message.toString());
  }

  static void error(Object message, {void Function(String message)? logFunction}) {
    (logFunction ?? writeOnFile).call(LogType.error.header + message.toString());
  }

  static void info(Object message, {void Function(String message)? logFunction}) {
    (logFunction ?? writeOnFile).call(LogType.info.header + message.toString());
  }
}

enum LogType {
  debug,
  info,
  error;

  String get header => "${DateTime.now().toIso8601String()} [${name.toUpperCase()}]: ";
}
