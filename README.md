TODO: This db_generator package helps to generate database tables functionality in .g.dart files.
It Usually contains the functionality like Create, Update, Delete, Select and drop tables etc.

## Features

TODO: This package can generates files for the database tables for optimizing the code rewriting for
 the every tables created by user.


## Getting started

TODO: Some Points need to follows while using this package in your project as belows.
- Import package in your pubspec.yaml file as belows with path_provider and sqflite package.

    sqflite:
    path_provider:
    db_generator:
      path: .database/db_generator

- Create build.yaml file in your flutter project.
- After creating build.yaml file then add the following code below in build.yaml file.

    targets:
      $default:
        builders:
          db_generator|databaseTableBuilder:
            enabled: True

- Then For creating tables dynamically run this command in terminal before running the project.
- Then After Add Function for creating database in flutter and then pass this database object for
calling the functions.

      Future openLocalDatabase() async {
        var path = await getApplicationDocumentsDirectory();
        databasePath = join(path.path, dbName);
        database = await openDatabase(databasePath, version: 1);
        return database;
      }


## How To Use this package in your project

TODO: Please Go through the example below.

- Create below class/functionality in your project.

          Future openLocalDatabase() async {
            var path = await getApplicationDocumentsDirectory();
            databasePath = join(path.path, dbName);
            database = await openDatabase(databasePath, version: 1);
            return database;
          }

- For using the generated tables function as follows

         Future getDB() async {
           db = await Helper().openLocalDatabase();
           if (File(db.path).existsSync()) {
             data = await ModelDBDAO.insertData(db, values);
           } else {
             ModelDBDAO.createTable(db);
             demoDAO.createTable(db);
             data = await ModelDBDAO.insertData(db, values);
           }
         }

