/// Entity class dell'ADS
class AdsDTO {
  /// Identificativo univoco dell'ADS
  late int? _id;

  /// username dell'ADS
  late String _username;

  /// password dell'ADS
  late String _password;

  /// contatti dell'ADS
  late String _email;
  late String _num_telefono;

  /// indirizzo dell'ADS
  late String _via;
  late String _citta;
  late String _provincia;

  /// Costruttore che permette di istanziare un nuovo ADS
  AdsDTO({
    required int? id,
    required String username,
    required String password,
    required String email,
    required String num_telefono,
    required String via,
    required String citta,
    required String provincia,
  })  : _id = id,
        _username = username,
        _password = password,
        _email = email,
        _num_telefono = num_telefono,
        _via = via,
        _citta = citta,
        _provincia = provincia;

  /// Getter e setter dei vari attributi
  int get id => _id ?? -1; // -1 valore di default che non può essere un id

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get num_telefono => _num_telefono;

  set num_telefono(String value) {
    _num_telefono = value;
  }

  String get via => _via;

  set via(String value) {
    _via = value;
  }

  String get citta => _citta;

  set citta(String value) {
    _citta = value;
  }

  String get provincia => _provincia;

  set provincia(String value) {
    _provincia = value;
  }

  /// Factory method per la creazione del DTO da una mappa (solitamente utilizzato quando si deserializzano dati da JSON).
  factory AdsDTO.fromJson(dynamic json) {
    return AdsDTO(
      id: json['id'],
      username:
          json['username'].toString().replaceAll('[', '').replaceAll(']', ''),
      password:
          json['password'].toString().replaceAll('[', '').replaceAll(']', ''),
      email: json['email'].toString().replaceAll('[', '').replaceAll(']', ''),
      num_telefono: json['num_telefono']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      citta: json['citta'].toString().replaceAll('[', '').replaceAll(']', ''),
      via: json['via'].toString().replaceAll('[', '').replaceAll(']', ''),
      provincia:
          json['provincia'].toString().replaceAll('[', '').replaceAll(']', ''),
    );
  }

  /// Metodo per convertire il DTO in una mappa (solitamente utilizzato quando si serializzano dati in JSON).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'num_telefono': num_telefono,
      'via': via,
      'citta': citta,
      'provincia': provincia
    };
  }

  /// Metodo che permette una stampa piu pulita dell'entity ads
  @override
  String toString() {
    return 'AdsDTO{id: $_id, username: $_username, password: $_password, email: $_email, num_telefono: $_num_telefono, via: $_via, citta: $_citta, provincia: $_provincia}';
  }
}
