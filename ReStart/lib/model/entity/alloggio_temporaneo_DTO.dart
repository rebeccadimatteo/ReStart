class AlloggioTemporaneoDTO{
  late int? _id;
  late String _nome;
  late String _descrizione;
  late String _tipo;
  late String _citta;
  late String _provincia;
  late String _via;
  late String _email;
  late String _sito;
  late String _immagine;

  AlloggioTemporaneoDTO({
    required int? id,
    required String nome,
    required String descrizione,
    required String tipo,
    required String citta,
    required String provincia,
    required String via,
    required String email,
    required String sito,
    required String immagine,
  }) : _id = id,
       _nome = nome,
       _descrizione = descrizione,
       _tipo = tipo,
       _citta = citta,
       _provincia = provincia,
       _via = via,
       _email = email,
       _sito = sito,
       _immagine = immagine;

  String get immagine => _immagine;

  set immagine(String value) {
    _immagine = value;
  }

  String get sito => _sito;

  set sito(String value) {
    _sito = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get via => _via;

  set via(String value) {
    _via = value;
  }

  String get provincia => _provincia;

  set provincia(String value) {
    _provincia = value;
  }

  String get citta => _citta;

  set citta(String value) {
    _citta = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get descrizione => _descrizione;

  set descrizione(String value) {
    _descrizione = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  int get id => _id ?? -1;

  // Metodo factory per creare un'istanza del DTO da un JSON
  factory AlloggioTemporaneoDTO.fromJson(Map<String, dynamic> json) {
    return AlloggioTemporaneoDTO(
      id : json['id'],
      nome : json['nome'].toString().replaceAll('[', '').replaceAll(']', ''),
      descrizione : json['descrizione'].toString().replaceAll('[', '').replaceAll(']', ''),
      tipo : json['tipo'].toString().replaceAll('[', '').replaceAll(']', ''),
      citta : json['citta'].toString().replaceAll('[', '').replaceAll(']', ''),
      provincia : json['provincia'].toString().replaceAll('[', '').replaceAll(']', ''),
      via : json['via'].toString().replaceAll('[', '').replaceAll(']', ''),
      email : json['email'].toString().replaceAll('[', '').replaceAll(']', ''),
      sito : json['sito'].toString().replaceAll('[', '').replaceAll(']', ''),
      immagine : json['immagine'].toString().replaceAll('[', '').replaceAll(']', ''),
    );
  }

  // Metodo per convertire il DTO in una mappa
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'nome': _nome,
      'descrizione': _descrizione,
      'tipo': _tipo,
      'citta': _citta,
      'provincia': _provincia,
      'via': _via,
      'email': _email,
      'sito': _sito,
      'immagine': _immagine,
    };
  }

  // Metodo factory per creare un'istanza del DTO da una mappa
  factory AlloggioTemporaneoDTO.fromMap(Map<String, dynamic> map) {
    return AlloggioTemporaneoDTO(
      id : map['id'] as int,
      nome : map['nome'] as String,
      descrizione : map['descrizione'] as String,
      tipo : map['tipo'] as String,
      citta : map['citta'] as String,
      provincia : map['provincia'] as String,
      via : map['via'] as String,
      email : map['email'] as String,
      sito : map['sito'] as String,
      immagine : map['immagine'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'nome': _nome,
      'descrizione': _descrizione,
      'tipo': _tipo,
      'citta': _citta,
      'provincia': _provincia,
      'via': _via,
      'email': _email,
      'sito': _sito,
      'immagine': _immagine,
    };
  }

  @override
  String toString() {
    return 'AlloggioTemporaneoDTO{id: $_id, nome: $_nome, descrizione: $_descrizione, tipo: $_tipo, citta: $_citta, provincia: $_provincia, via: $_via, email: $_email, sito: $_sito, immagine: $_immagine}';
  }
}

