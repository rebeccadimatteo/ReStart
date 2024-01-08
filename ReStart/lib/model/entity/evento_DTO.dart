/// Entity class dell'evento
class EventoDTO {
  int? _id;
  late String _usernameCa;
  late String _immagine;
  late String _nomeEvento;
  late String _descrizione;
  late DateTime _date;
  late bool _approvato;
  late String _email;
  late String _sito;
  late String _via;
  late String _citta;
  late String _provincia;

  /// Costruttore che permette di istanziare un nuovo evento
  EventoDTO({
    int? id,
    required String usernameCa,
    required String immagine,
    required String nomeEvento,
    required String descrizione,
    required DateTime date,
    required bool approvato,
    required String email,
    required String sito,
    required String via,
    required String citta,
    required String provincia,
  })  : _id = id,
        _usernameCa = usernameCa,
        _immagine = immagine,
        _nomeEvento = nomeEvento,
        _descrizione = descrizione,
        _date = date,
        _approvato = approvato,
        _email = email,
        _sito = sito,
        _via = via,
        _citta = citta,
        _provincia = provincia;

  /// Getter e setter dei vari attributi
  int? get id => _id;
  String get usernameCa => _usernameCa;
  String get immagine => _immagine;

  set usernameCa(String value){
    _usernameCa = value;
  }
  set immagine(String value) {
    _immagine = value;
  }

  String get nomeEvento => _nomeEvento;

  set nomeEvento(String value) {
    _nomeEvento = value;
  }

  String get provincia => _provincia;

  set provincia(String value) {
    _provincia = value;
  }

  String get citta => _citta;

  set citta(String value) {
    _citta = value;
  }

  String get via => _via;

  set via(String value) {
    _via = value;
  }

  String get sito => _sito;

  set sito(String value) {
    _sito = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  bool get approvato => _approvato;

  set approvato(bool value) {
    _approvato = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get descrizione => _descrizione;

  set descrizione(String value) {
    _descrizione = value;
  }

  /// Mapping di un oggetto json in un oggetto EventoDTO
  factory EventoDTO.fromJson(dynamic json) {
    var rawData = json['data'];
    DateTime parsedDate;

    if (rawData is DateTime) {
      parsedDate = rawData;
    } else if (rawData is String) {
      parsedDate = DateTime.parse(rawData);
    } else {
      // Puoi gestire altri tipi o scenari a tua discrezione
      parsedDate = DateTime.now();
    }
    return EventoDTO(
      id: json['id'],
      usernameCa: json['usernameCa'].toString().replaceAll('[', '').replaceAll(']', ''),
      nomeEvento: json['nome'].toString().replaceAll('[', '').replaceAll(']', ''),
      descrizione: json['descrizione'].toString().replaceAll('[', '').replaceAll(']', ''),
      date: parsedDate,
      approvato: json['approvato'],
      email: json['email'].toString().replaceAll('[', '').replaceAll(']', ''),
      sito: json['sito'].toString().replaceAll('[', '').replaceAll(']', ''),
      immagine: json['immagine'].toString().replaceAll('[', '').replaceAll(']', ''),
      via: json['via'].toString().replaceAll('[', '').replaceAll(']', ''),
      citta: json['citta'].toString().replaceAll('[', '').replaceAll(']', ''),
      provincia: json['provincia'].toString().replaceAll('[', '').replaceAll(']', ''),
    );
  }

  /// Mapping di un oggetto EventoDTO in un oggetto json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usernameCa': usernameCa,
      'nome': nomeEvento,
      'descrizione': descrizione,
      'data': date.toIso8601String(),
      'approvato': approvato,
      'email': email,
      'sito': sito,
      'immagine': immagine,
      'via': via,
      'citta': citta,
      'provincia': provincia
    };
  }

  /// Metodo che permette una stampa più pulita dell'entity utente
  @override
  String toString() {
    return 'EventoDTO{id: $_id, usernameCa: $_usernameCa, immagine: $_immagine, nomeEvento: $_nomeEvento, descrizione: $_descrizione, data: $_date, approvato: $_approvato, email: $_email, sito: $_sito, via: $_via, citta: $_citta, provincia: $_provincia}';
  }
}