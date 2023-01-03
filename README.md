# flutter_todo_list

Flutter todo list project

## Getting Started
---
- app_module.dart -> Called directly by main.dart. Has a multiprovider that initiates necessary application providers. Multiprovider has a child called app_widget.dart that has our MaterialApp and calls SplashPage() as home. Starts and disposes the sqlite_adm_connection.dart observer.


- core/database -> All things related to database management:
    - sqlite_connection_factory.dart -> SqliteConnectionFactory singleton. Initiates database connection if _db is null or returns open connection. Calls openDatabase and runs onConfigure, onCreate, onUpgrade and onDowngrade as needed.
    - sqlite_adm_connection.dart -> Observer that monitors application execution and closes database connection if state = inactive, paused or detached.

