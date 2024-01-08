class CaDTO {
  /// identificativo univoco del CA
  int? _id;

  /// nome del CA
  late String _nome;

  /// username del CA
  late String _username;

  /// password del CA
  late String _password;

  ///Contatti del CA
  late String _email;
  late String _num_telefono;
  late String _sito_web;

  ///Indirizzo del CA
  late String _via;
  late String _citta;
  late String _provincia;
  late String _immagine;

  /// Costruttore che permette di istanziare un nuovo CA
  CaDTO(
      {int? id,
      required String nome,
      required String username,
      required String password,
      required String email,
      required String num_telefono,
      required String sito_web,
      required String via,
      required String citta,
      required String provincia,
      required String immagine})
      : _id = id,
        _nome = nome,
        _username = username,
        _password = password,
        _email = email,
        _num_telefono = num_telefono,
        _sito_web = sito_web,
        _via = via,
        _citta = citta,
        _provincia = provincia,
        _immagine = immagine;

  /// Getter e setter dei vari attributi
  int? get id => _id ?? null;

  String get username => _username;

  String get immagine => _immagine;

  String get sito_web => _sito_web;

  get nome => _nome;

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
  factory CaDTO.fromJson(dynamic json) {
    return CaDTO(
      id: json['id'],
      nome: json['nome'].toString().replaceAll('[', '').replaceAll(']', ''),
      username:
          json['username'].toString().replaceAll('[', '').replaceAll(']', ''),
      password:
          json['password'].toString().replaceAll('[', '').replaceAll(']', ''),
      num_telefono: json['num_telefono']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      email: json['email'].toString().replaceAll('[', '').replaceAll(']', ''),
      sito_web: json['sito'].toString().replaceAll('[', '').replaceAll(']', ''),
      immagine:
          json['immagine'].toString().replaceAll('[', '').replaceAll(']', ''),
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
      'nome': nome,
      'username': username,
      'password': password,
      'num_telefono': num_telefono,
      'email': email,
      'sito': sito_web,
      'immagine': immagine,
      'citta': citta,
      'via': via,
      'provincia': provincia,
    };
  }

  /// Metodo che permette una stampa piu pulita dell'entity CA
  @override
  String toString() {
    return 'CaDTO{id: $_id, nome: $_nome, username: $_username, password: $_password, email: $_email, num_telefono: $_num_telefono, sito_web: $_sito_web, via: $_via, citta: $_citta, provincia: $_provincia, immagine: $_immagine}';
  }
}
