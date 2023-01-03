import 'package:flutter/material.dart';
import 'package:flutter_todo_list/app/core/database/sqlite_adm_connection.dart';
import 'package:flutter_todo_list/app/modules/auth/auth_module.dart';
import 'package:flutter_todo_list/app/modules/auth/login/login_controller.dart';
import 'package:flutter_todo_list/app/modules/auth/login/login_page.dart';
import 'package:flutter_todo_list/app/modules/splash/splash_page.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final sqliteAdm = SqliteAdmConnection();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(sqliteAdm);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(sqliteAdm);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List Provider',
      home: SplashPage(),
      routes: {
        ...AuthModule().routes,
      },
    );
  }
}
