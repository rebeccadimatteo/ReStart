import 'package:postgres/postgres.dart';

/// Classe per la gestione della connessione al database PostgreSQL.
///
/// Implementa un pattern Singleton per garantire che venga utilizzata una sola istanza di connessione
/// in tutta l'applicazione.
class Connector {
  /// Istanza privata statica della classe, parte del pattern Singleton.
  static final Connector _instance = Connector._singleton();

  /// Connessione al database.
  Connection? _connection;

  /// Costruttore privato per il Singleton.
  Connector._singleton();

  /// Factory constructor per accedere all'istanza singleton della classe.
  factory Connector() {
    return _instance;
  }

  /// Apre una connessione al database PostgreSQL.
  ///
  /// Crea e restituisce una connessione al database utilizzando le credenziali fornite.
  /// In caso di successo, restituisce l'oggetto [Connection].
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

  /// Chiude la connessione al database.
  ///
  /// Assicura che la connessione al database sia chiusa in modo pulito quando non è più necessaria.
  Future<void> closeConnection() async {
    await _connection!.close();
  }
}