import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:db_generator/annotations/databaseTables.dart';
import 'package:source_gen/source_gen.dart';

class DatabaseTableGenerator extends GeneratorForAnnotation<DatabaseTables> {
  static const String contextInitializedCheck = '''if (context.database.database == null) { throw Exception('Database not initialized.'); }''';

  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    // TODO: implement generateForAnnotatedElement
    final classElement = element as ClassElement;
    final className = classElement.displayName;
    final String tableName = className;

    final data = classElement.allSupertypes.map((e) => e.element).toList();
    data.expand((element) => element.fields).where((element) => TypeChecker.fromRuntime(element.runtimeType).hasAnnotationOfExact(element)).map((e) {
      if (e.type.isDartCoreString) return "TEXT";
    });

    final imports = 'import \'package:sqflite/sqflite.dart\';';

    getType(String type, String value) {
      if (value == "id") {
        return 'INTEGER PRIMARY KEY';
      } else {
        if (type == "String") {
          return 'TEXT';
        } else if (type == "int") {
          return 'INTEGER';
        }
      }
    }

    final sqlColumns = '[${classElement.fields.map((e) => '\'${e.displayName}\'').join(", ")}]';

    final columns = '${classElement.fields.map((e) => '\'${e.displayName}\' ${getType('${e.declaration.type}', '${e.displayName}')}').join(", ")}';

    final createCommand = 'CREATE TABLE\${isExists?\' IF NOT EXISTS\' :\' \'}\${tableName} (${columns})';

    final deleteCommand = 'DELETE TABLE\${isExists?\' IF NOT EXISTS\' :\' \'}\${tableName}';

    deleteTable() {
      return 'Future deleteTable(Database db,{bool isExists=false}) async{\n'
          'return await db.execute(\'${deleteCommand}\');'
          '\n}';
    }

    createTable() {
      return '\n static Future createTable(Database db,{bool isExists=false}) async{ \n'
          'return await db.execute(\'\'\'${createCommand}\'\'\');'
          ' \n}';
    }

    insertData() {
      return 'static Future insertData(Database db,Map<String,dynamic> values,{bool isExists=false}) async{ \n'
          'return await db.insert(\'$tableName\',values);'
          '\n}';
    }

    updateTableValues() {
      return 'static Future updateValues(Database db,Map<String,dynamic> values,{bool isExists=false,String? where,List? whereArgs}) async{ \n'
          'return await db.update(\'$tableName\',values, where:where,whereArgs:whereArgs);'
          '\n}';
    }

    deleteRowValues() {
      return 'static Future deleteValues(Database db,{bool isExists=false,String? where,List? whereArgs}) async{ \n'
          'return await db.delete(\'$tableName\', where:where,whereArgs:whereArgs);'
          '\n}';
    }

    selectAllData() {
      return 'static Future selectQuery(Database db,{bool isExists=false,bool? distinct,List<String>? columns,String? where,List? whereArgs,String? groupBy,String? having,String? orderBy,int? limit,int? offset}) async{ \n'
          'return await db.query(\'$tableName\',distinct:distinct,columns:columns,where:where,whereArgs:whereArgs,groupBy:groupBy,having:having,orderBy:orderBy,limit:limit,offset:offset);'
          '\n}';
    }

    final dropCommand = 'DROP table $tableName';

    dropTable() {
      return 'static Future dropTable(Database db,{bool isExists=false}) async{\n'
          'return await db.execute(\'\'\'$dropCommand\'\'\');\n'
          '}';
    }

    return '\n\n\n class ${className}DAO{\n static const sqlColumn= $sqlColumns;\n'
        'static const tableName= "${tableName}";\n'
        '${createTable()}'
        '\n \n'
        '${deleteTable()}'
        '\n \n'
        '${insertData()}'
        '\n \n'
        '${updateTableValues()}'
        '\n \n'
        '${selectAllData()}'
        '\n \n'
        '${deleteRowValues()}'
        '\n \n'
        '${dropTable()}'
        '\n}';
  }
}
