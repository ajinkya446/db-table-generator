TODO: This db_generator package helps to generate database tables functionality in .g.dart files.
It Usually contains the functionality like Create, Update, Delete, Select and drop tables etc.

## Features

TODO: This package can generates files for the database tables for optimizing the code rewriting for
 the every tables created by user.


## Getting started

TODO: Some Points need to follows while using this package in your project as belows.
- Import package in your pubspec.yaml file as belows with path_provider and sqflite package.

 ![image](https://user-images.githubusercontent.com/49361315/159474659-94ba3616-03f4-49a0-b71c-e30e8467ee57.png)

- Create build.yaml file in your flutter project.
- After creating build.yaml file then add the following code below in build.yaml file.

![image](https://user-images.githubusercontent.com/49361315/159474712-3255280f-6c8b-43d6-9f0f-a0af8a2f52d1.png)


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

