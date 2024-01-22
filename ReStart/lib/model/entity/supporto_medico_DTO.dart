class SupportoMedicoDTO {
  int? _id;
  late String _immagine;
  late String _nomeMedico;
  late String _cognomeMedico;
  late String _descrizione;
  late String _tipo;
  late String _email;
  late String _numTelefono;
  late String _via;
  late String _citta;
  late String _provincia;

  /// Costruttore di [SupportoMedicoDTO].
  ///
  /// Inizializza un'istanza di [SupportoMedicoDTO] con valori per tutte le proprietà richieste.
  SupportoMedicoDTO({
    int? id,
    required String nomeMedico,
    required String cognomeMedico,
    required String descrizione,
    required String tipo,
    required String immagine,
    required String email,
    required String numTelefono,
    required String via,
    required String citta,
    required String provincia,
  })  : _id = id,
        _nomeMedico = nomeMedico,
        _cognomeMedico = cognomeMedico,
        _descrizione = descrizione,
        _tipo = tipo,
        _immagine = immagine,
        _email = email,
        _numTelefono = numTelefono,
        _via = via,
        _citta = citta,
        _provincia = provincia;

  int? get id => _id;

  String get immagine => _immagine;

  set immagine(String value) {
    _immagine = value;
  }

  String get nomeMedico => _nomeMedico;

  set nomeMedico(String value) {
    _nomeMedico = value;
  }

  String get cognomeMedico => _cognomeMedico;

  set cognomeMedico(String value) {
    _cognomeMedico = value;
  }

  String get descrizione => _descrizione;

  set descrizione(String value) {
    _descrizione = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get numTelefono => _numTelefono;

  set numTelefono(String value) {
    _numTelefono = value;
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

  /// Factory method per creare un'istanza di [SupportoMedicoDTO] da una mappa JSON.
  ///
  /// Il metodo prende in input una mappa (json) e restituisce un'istanza di [SupportoMedicoDTO].
  factory SupportoMedicoDTO.fromJson(Map<String, dynamic> json) {
    return SupportoMedicoDTO(
      id: json['id'],
      nomeMedico:
          json['nome'].toString().replaceAll('[', '').replaceAll(']', ''),
      cognomeMedico:
          json['cognome'].toString().replaceAll('[', '').replaceAll(']', ''),
      descrizione: json['descrizione']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      tipo: json['tipo'].toString().replaceAll('[', ''.replaceAll(']', '')),
      immagine:
          json['immagine'].toString().replaceAll('[', '').replaceAll(']', ''),
      email: json['email'].toString().replaceAll('[', '').replaceAll(']', ''),
      numTelefono: json['num_telefono']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      via: json['via'].toString().replaceAll('[', '').replaceAll(']', ''),
      citta: json['citta'].toString().replaceAll('[', '').replaceAll(']', ''),
      provincia:
          json['provincia'].toString().replaceAll('[', '').replaceAll(']', ''),
    );
  }

  /// Metodo per convertire il DTO in una mappa JSON.
  ///
  /// Restituisce una mappa JSON rappresentante l'istanza corrente.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nomeMedico,
      'cognome': cognomeMedico,
      'descrizione': descrizione,
      'tipo': tipo,
      'immagine': immagine,
      'email': email,
      'num_telefono': numTelefono,
      'via': via,
      'citta': citta,
      'provincia': provincia
    };
  }

  /// Metodo per convertire il DTO in una mappa.
  ///
  /// Restituisce una mappa rappresentante l'istanza corrente.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nomeMedico,
      'cognome': cognomeMedico,
      'descrizione': descrizione,
      'tipo': tipo,
      'immagine': immagine,
      'email': email,
      'num_telefono': numTelefono,
      'via': via,
      'citta': citta,
      'provincia': provincia
    };
  }

  /// Factory method per creare un'istanza di [SupportoMedicoDTO] da una mappa.
  ///
  /// Prende in input una mappa e restituisce un'istanza di [SupportoMedicoDTO].
  factory SupportoMedicoDTO.fromMap(Map<String, dynamic> map) {
    return SupportoMedicoDTO(
      id: map['id'] as int,
      nomeMedico: map['nomeMedico'] as String,
      cognomeMedico: map['cognomeMedico'] as String,
      descrizione: map['descrizione'] as String,
      tipo: map['tipo'] as String,
      immagine: map['immagine'] as String,
      email: map['email'] as String,
      numTelefono: map['num_telefono'] as String,
      via: map['via'] as String,
      citta: map['citta'] as String,
      provincia: map['provincia'] as String,
    );
  }

  /// Metodo per rappresentare l'istanza come stringa.
  ///
  /// Restituisce una stringa che rappresenta l'istanza corrente.
  @override
  String toString() {
    return 'SupportoMedicoDTO{_id: $_id, _immagine: $_immagine, _nomeMedico: $_nomeMedico, _cognomeMedico: $_cognomeMedico, _descrizione: $_descrizione, _tipo: $_tipo, _email: $_email, _numTelefono: $_numTelefono, _via: $_via, _citta: $_citta, _provincia: $_provincia}';
  }
}
