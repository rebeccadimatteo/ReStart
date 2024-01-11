/// Entity class dell'utente

class UtenteDTO {
  /// Identificativo univoco dell'utente
  int? _id;

  /// Nome dell'utente
  late String _nome;

  /// Cognome dell'utente
  late String _cognome;

  /// Codice fiscale dell'utente
  late String _cod_fiscale;

  /// Data di nascita
  late DateTime _data_nascita;

  /// Luogo di nascita dell'utente
  late String _luogo_nascita;

  /// Genere dell'utente
  late String _genere;

  /// Username dell'utente
  late String _username;

  /// Password dell'utente
  late String _password;

  /// Lavoro adatto dell'utente, generato dal modulo di IA
  late String? _lavoro_adatto;

  /// Email dell'utente
  late String _email;

  /// Numero di telefono dell'utente
  late String _num_telefono;

  /// Imamagine profilo dell'utente
  late String _immagine;

  /// Indirizzo dell'utente
  late String _via;
  late String _citta;
  late String _provincia;

  /// Costruttore che permette di istanziare un nuovo utente
  UtenteDTO({
    int? id,
    required String nome,
    required String cognome,
    required String cod_fiscale,
    required DateTime data_nascita,
    required String luogo_nascita,
    required String genere,
    required String username,
    required String password,
    String? lavoro_adatto,
    required String email,
    required String num_telefono,
    required String immagine,
    required String via,
    required String citta,
    required String provincia,
  })  : _id = id ?? null,
        _nome = nome,
        _cognome = cognome,
        _cod_fiscale = cod_fiscale,
        _data_nascita = data_nascita,
        _luogo_nascita = luogo_nascita,
        _genere = genere,
        _username = username,
        _password = password,
        _lavoro_adatto = lavoro_adatto,
        _email = email,
        _num_telefono = num_telefono,
        _immagine = immagine,
        _via = via,
        _citta = citta,
        _provincia = provincia;

  /// Getter e setter dei vari attributi
  int? get id => _id;

  String get nome => _nome;

  set nome(String value) => _nome = value;

  String get cognome => _cognome;

  set cognome(String value) => _cognome = value;

  String get cod_fiscale => _cod_fiscale;

  set cod_fiscale(String value) => _cod_fiscale = value;

  DateTime get data_nascita => _data_nascita;

  set data_nascita(DateTime value) => _data_nascita = value;

  String get luogo_nascita => _luogo_nascita;

  set luogo_nascita(String value) => _luogo_nascita = value;

  String get genere => _genere;

  set genere(String value) => _genere = value;

  String get username => _username;

  set username(String value) => _username = value;

  String get password => _password;

  set password(String value) => _password = value;

  String? get lavoro_adatto => _lavoro_adatto;

  set lavoro_adatto(String? value) => _lavoro_adatto = value;

  String get email => _email;

  set email(String value) => _email = value;

  String get num_telefono => _num_telefono;

  set num_telefono(String value) => _num_telefono = value;

  String get immagine => _immagine;

  set immagine(String value) => _immagine = value;

  String get via => _via;

  set via(String value) => _via = value;

  String get citta => _citta;

  set citta(String value) => _citta = value;

  String get provincia => _provincia;

  set provincia(String value) => _provincia = value;

  /// Mapping dell'UtenteDTO in un oggetto json
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'nome': _nome,
      'cognome': _cognome,
      'cod_fiscale': _cod_fiscale,
      'data_nascita': _data_nascita.toIso8601String(),
      'luogo_nascita': _luogo_nascita,
      'genere': _genere,
      'username': _username,
      'password': _password,
      'lavoro_adatto': _lavoro_adatto,
      'email': _email,
      'num_telefono': _num_telefono,
      'immagine': _immagine,
      'via': _via,
      'citta': _citta,
      'provincia': _provincia,
    };
  }

  /// Mapping dell'oggetto json in un UtenteDTO
  factory UtenteDTO.fromJson(Map<String, dynamic> json) {
    var rawData = json['data_nascita'];
    DateTime parsedDate;

    if (rawData is DateTime) {
      parsedDate = rawData;
    } else if (rawData is String) {
      parsedDate = DateTime.parse(rawData);
    } else {
      // Puoi gestire altri tipi o scenari a tua discrezione
      parsedDate = DateTime.now();
    }
    return UtenteDTO(
      id: json['id'],
      nome: json['nome'].toString().replaceAll('[', '').replaceAll(']', ''),
      cognome:
          json['cognome'].toString().replaceAll('[', '').replaceAll(']', ''),
      cod_fiscale: json['cod_fiscale']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      data_nascita: parsedDate,
      luogo_nascita: json['luogo_nascita']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      genere: json['genere'].toString().replaceAll('[', '').replaceAll(']', ''),
      username:
          json['username'].toString().replaceAll('[', '').replaceAll(']', ''),
      password: json['password']
              ?.toString()
              .replaceAll('[', '')
              .replaceAll(']', '') ??
          '',
      lavoro_adatto: json['lavoro_adatto']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      email: json['email'].toString().replaceAll('[', '').replaceAll(']', ''),
      num_telefono: json['num_telefono']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      immagine:
          json['immagine'].toString().replaceAll('[', '').replaceAll(']', ''),
      via: json['via'].toString().replaceAll('[', '').replaceAll(']', ''),
      citta: json['citta'].toString().replaceAll('[', '').replaceAll(']', ''),
      provincia:
          json['provincia'].toString().replaceAll('[', '').replaceAll(']', ''),
    );
  }

  /// Metodo che permette una stampa piu pulita dell'entity utente
  @override
  String toString() {
    return 'UtenteDTO{id: $_id, nome: $_nome, cognome: $_cognome, cod_fiscale: $_cod_fiscale, data_nascita: $_data_nascita, luogo_nascita: $_luogo_nascita, genere: $_genere, username: $_username, password: $_password, lavoro_adatto: $_lavoro_adatto, email: $_email, num_telefono: $_num_telefono, immagine: $_immagine, via: $_via, citta: $_citta, provincia: $_provincia}';
  }
}
