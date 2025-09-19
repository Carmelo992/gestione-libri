abstract class BaseDaoModel {
  static const idKey = "id";
  static const createdAtKey = "createdAt";
  static const updatedAtKey = "updatedAt";

  static const List<String> tableColumns = [
    "$idKey INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "$createdAtKey TIMESTAMP DATETIME NOT NULL DEFAULT (STRFTIME('%Y-%m-%dT%H:%M:%f000Z', 'NOW'))",
    "$updatedAtKey TIMESTAMP DATETIME NOT NULL DEFAULT (STRFTIME('%Y-%m-%dT%H:%M:%f000Z', 'NOW'))",
  ];
}
