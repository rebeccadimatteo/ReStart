import 'package:postgres/postgres.dart';

///classe che permette di connettersi al dataBase
class Connector {
  static final Connector _instance = Connector._singleton();

  Connection? _connection;

  Connector._singleton();

  factory Connector() {
    return _instance;
  }

  /// Metodo per aprire la connessione
  Future<Connection> openConnection() async {
    _connection = await Connection.open(
      Endpoint(
          host: 'localhost',
          database: 'ReStart',
          username: 'postgres',
          password: '0000'
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    return _connection!;
  }

  /// Metodo per chiudere la connessione
  Future<void> closeConnection() async {
    await _connection!.close();
  }
}