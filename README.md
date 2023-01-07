# flutter_todo_list

Flutter todo list project da Academia do Flutter

# Documentação da arquitetura

### App roda uma arquitetura baseada em módulos para gerenciar o carregamento e dispose das telas e módulos.
  - `AppModule` carrega módulos necessários durante toda a execução do app como conexão com banco de dados. Ex: `Provider<SqliteConnectionFactory>`.
  - `Auth/Login` carrega módulos necessários para execução de login e registro. Ex: `ChangeNotifierProvider<LoginController>`.
  - `TodoListPage` recebe rotas e bindings e encapsula em um `MultiProvider` através de `todo_list_page.dart`

## AppModule
  - `app/app_module.dart` -> Chamado diretamente por  `main.dart`. Possui um `MultiProvider` que inicializa os `Providers`  do app. `MultiProvider` tem um child que chama a página `AppWidger()`.
  - `app/app_widget.dart` -> `fu-stf` que retorna `MaterialApp` e chama `SplashPage()` como home. Usado para inicializar  o `Observer` de `sqlite_adm_connection.dart` em `initState()` e finalizar em `dispose()`. Possui rota `...AuthModule().routes` configurada através do `TodoListModule`.

## Database
  - `/app/core/database/sqlite_connection_factory.dart` -> `SqliteConnectionFactory` singleton para garantir que somente haja uma referência para o banco de dados. Inicia nova conexão se _db for null ou retorna conexão _db existente. `openDatabase` abre conexão e chama `_onConfigure`, `_onCreate`, `_onUpgrade` e `_onDowngrade` conforme necessidade. É chamado pelo `MultiProvider` `app_module.dart` para estar disponível durante toda a execução do app.
  - `/app/core/database/sqlite_migration_factory.dart` -> Classe `SqliteMigrationFactory`  com métodos `getCreateMigration` e `getUpdateMigration` que retornam uma lista com funcoes `MigrationVX()` que deverão ser executadas por `SqlConnectionFactory.openConnection()` e parametros _onCreate e _onConfigure para criar ou atualizar migration.
  - `/app/core/database/migrations/migration.dart` -> Interface (abstract class `Migration`). Expõe os métodos que as classes filhas terão que implementar (`create` e `update`). 
  - `/app/core/database/migrations/migration_v1.dart` -> Classe `MigrationVX` implements `Migration`. Métodos `create` e `update` sofrem @override e são definidos conforme versão.
  - `sqlite_adm_connection.dart` -> Observer that monitors application execution and closes database connection if state = inactive, paused or detached.

## TodoListModule (genérico para encapsulamento de módulos)
- `app/core/modules/todo_list_module.dart` -> Abstract class TodoListModule. Recebe parâmetros path da rota nomeada (String) e bindings (Lista de single child Widger WidgetBuilder), customiza o route usando `TodoListPage` e retorna um `MultiProvider` com os módulos. Possui getter que retorna o Map.
- `app/core/modules/todo_list_page.dart` -> `Stl-page`. Recebe os `bindings` e `page` de `todo_list_modules.dart` e encapsula em um `MultiProvider` (bindings em providers e page em um child: Builder. Se bindings for null, retorna um provider genérico para evitar erros) e retorna para `todo_list_modules.dart`.

## Módulo auth/login
- `app/modules/auth/login_controller.dart` -> class extends `ChangeNotifier`. Controller para login e register.
- `app/modules/auth/login_page.dart` -> `Stl-page`. Página de login.
- `app/modules/auth_module.dart` -> class extends `TodoListModule`. Possui bindings e rotas necessários para os módulos.
- `app/core/modules/todo_list_modules.dart` -> Abstract class TodoListModule. Recebe parâmetros de rotas e bindings. Customiza o route usando `TodoListPage` que retorna um `MultiProvider`.
- `app/core/modules/todo_list_page.dart` -> `Stl-page`. Recebe os `bindings` e `page` de `todo_list_modules.dart` e encapsula em um `MultiProvider` (bindings em providers e page em um child: Builder. Se bindings for null, retorna um provider genérico para evitar erros) e retorna para `todo_list_modules.dart`.
- `/app/app_widget.dart` -> `Stf-page`. Importa as rotas `...AuthModule().routes`
