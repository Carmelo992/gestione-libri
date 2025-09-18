import 'package:sqlite3/sqlite3.dart';

import 'pagination_dao_model.dart';

class CrudDao {
  static List<Row> getAll(
    Database db,
    String tableName, {
    List<String>? keys,
    List<dynamic>? values,
    PaginationDaoModel? pagination,
    List<String>? orderByField,
    bool isDesc = false,
  }) {
    assert(tableName.isNotEmpty);
    assert((keys == null && values == null) || (keys!.length == values!.length));
    String whereString = "";
    if (keys != null && values != null) {
      whereString = "WHERE ${_getCond(keys, "AND")}";
    }
    String orderByString = "";
    if (orderByField != null && orderByField.isNotEmpty) {
      String order = orderByField.join(", ");
      orderByString = "ORDER BY $order ${isDesc ? "DESC" : ""}";
    }

    if (pagination == null) {
      return db.select('''SELECT * FROM $tableName $whereString $orderByString''', [...?values]);
    }

    return db.select(
      '''SELECT * FROM $tableName $whereString $orderByString LIMIT (?) OFFSET (?)''',
      [...?values, pagination.limit, pagination.offset],
    );
  }

  static Row insert(Database db, String tableName, List<String> keys, List<dynamic> fields) {
    assert(keys.length == fields.length);
    return db
        .select(
          'INSERT INTO $tableName (${keys.join(", ")}) VALUES (${keys.map((e) => "?").join(", ")}) RETURNING *',
          fields,
        )
        .first;
  }

  static Map<String, dynamic>? getBy(Database db, String tableName, List<String> keys, List<dynamic> values) {
    assert(tableName.isNotEmpty);
    assert(keys.isNotEmpty);
    assert(keys.length == values.length);
    String whereString = "";
    whereString = "WHERE ${_getCond(keys, "AND")}";
    return db.select('''SELECT * FROM $tableName $whereString''', values).firstOrNull;
  }

  static Map<String, dynamic>? getById(Database db, String tableName, String id) {
    assert(tableName.isNotEmpty);
    assert(id.isNotEmpty);
    return db.select('''SELECT * FROM $tableName WHERE id = (?)''', [id]).firstOrNull;
  }

  static Row? update(
    Database db,
    String tableName,
    String id,
    List<String> keys,
    List<dynamic> fields, {
    List<String> whereKeys = const [],
    List<dynamic> whereFields = const [],
  }) {
    assert(keys.length == fields.length);
    assert(whereKeys.length == whereFields.length);
    assert(id.isNotEmpty);
    String setClause = "SET updatedAt = (STRFTIME('%Y-%m-%dT%H:%M:%f000Z', 'NOW')), ";
    for (int i = 0; i < keys.length; i++) {
      setClause += "${keys.elementAt(i)} = (?)";
      if (i < keys.length - 1) {
        setClause += ", ";
      }
    }
    String whereCond = "";
    if (whereKeys.isNotEmpty) {
      whereCond += "AND ${_getCond(whereKeys, "AND")}";
    }
    return db.select('UPDATE $tableName $setClause WHERE id = (?) $whereCond RETURNING *', [
      ...fields,
      id,
      ...whereFields,
    ]).firstOrNull;
  }

  static bool delete(
    Database db,
    String tableName,
    String id, {
    List<String> whereKeys = const [],
    List<dynamic> whereFields = const [],
  }) {
    assert(id.isNotEmpty);
    assert(whereKeys.length == whereFields.length);
    String whereCond = "";
    if (whereKeys.isNotEmpty) {
      whereCond += "AND ${_getCond(whereKeys, "AND")}";
    }

    db.select('DELETE FROM $tableName WHERE id = (?) $whereCond', [id, ...whereFields]);
    return db.updatedRows == 1;
  }

  static String _getCond(List<String> keys, String op) {
    String cond = "";
    for (int i = 0; i < keys.length; i++) {
      cond += "${keys.elementAt(i)} = (?) ";
      if (i < keys.length - 1) {
        cond += "$op ";
      }
    }
    return cond;
  }
}
