/// Questa classe rappresenta un oggetto DTO (Data Transfer Object) per un annuncio di lavoro.
class AnnuncioDiLavoroDTO {
  late int? _id;
  late String _nome;
  late String _descrizione;
  late bool _approvato;
  late String _via;
  late String _citta;
  late String _provincia;
  late String _immagine;
  late String _email;
  late String _numTelefono;
  /// Costruttore che richiede tutti i parametri necessari per un annuncio di lavoro.
  AnnuncioDiLavoroDTO({
    required int id,
    required String nome,
    required String descrizione,
    required bool approvato,
    required String via,
    required String citta,
    required String provincia,
    required String immagine,
    required String email,
    required String numTelefono
  })  : _id = id,
        _nome = nome,
        _descrizione = descrizione,
        _approvato = approvato,
        _via = via,
        _citta = citta,
        _provincia = provincia,
        _immagine = immagine,
        _email = email,
        _numTelefono = numTelefono;
  /// Getters e setters per accedere ai membri della classe.
  int get id => _id ?? -1;
  String get nome => _nome;
  String get descrizione => _descrizione;
  bool get approvato => _approvato;
  String get via => _via;
  String get citta => _citta;
  String get provincia => _provincia;
  String get immagine => _immagine;
  String get email => _email;
  String get numTelefono => _numTelefono;

  set nome(String value) {
    _nome = value;
  }

  set descrizione(String value) {
    _descrizione = value;
  }

  set approvato(bool value) {
    _approvato = value;
  }

  set via(String value) {
    _via = value;
  }

  set citta(String value) {
    _citta = value;
  }

  set provincia(String value) {
    _provincia = value;
  }

  set immagine(String value) {
    _immagine = value;
  }

  set email(String value){
    _email = value;
  }

  set numTelefono(String value){
    _numTelefono = value;
  }
  /// Metodo per convertire l'oggetto in una mappa.
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'nome': _nome,
      'descrizione': _descrizione,
      'approvato': _approvato,
      'via': _via,
      'citta': _citta,
      'provincia': _provincia,
      'immagine': _immagine,
      'email': _email,
      'num_telefono': _numTelefono
    };
  }
  /// Metodo toJson per la serializzazione dell'oggetto in formato JSON.
  factory AnnuncioDiLavoroDTO.fromMap(Map<String, dynamic> map) {
    return AnnuncioDiLavoroDTO(
        id: map['id'] as int,
        nome: map['nome'] as String,
        descrizione: map['descrizione'] as String,
        approvato: map['approvato'] as bool,
        via: map['via'] as String,
        citta: map['citta'] as String,
        provincia: map['provincia'] as String,
        immagine: map['immagine'] as String,
        email: map['email'] as String,
        numTelefono: map['num_telefono'] as String
    );
  }
  /// Metodo toJson per la serializzazione dell'oggetto in formato JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'nome': _nome,
      'descrizione': _descrizione,
      'approvato': _approvato,
      'via': _via,
      'citta': _citta,
      'provincia': _provincia,
      'immagine': _immagine,
      'email': _email,
      'num_telefono': _numTelefono
    };
  }
  /// Metodo factory per deserializzare un oggetto JSON in un AnnuncioDiLavoroDTO.
  factory AnnuncioDiLavoroDTO.fromJson(Map<String, dynamic> json) {
    return AnnuncioDiLavoroDTO(
        id: json['id'] as int,
        nome: json['nome'].toString().replaceAll('[', '').replaceAll(']', ''),
        descrizione: json['descrizione'].toString().replaceAll('[', '').replaceAll(']', ''),
        approvato: json['approvato'] as bool,
        via: json['via'].toString().replaceAll('[', '').replaceAll(']', ''),
        citta: json['citta'].toString().replaceAll('[', '').replaceAll(']', ''),
        provincia: json['provincia'].toString().replaceAll('[', '').replaceAll(']', ''),
        immagine: json['immagine'].toString().replaceAll('[', '').replaceAll(']', ''),
        email: json['email'].toString().replaceAll('[', '').replaceAll(']', ''),
        numTelefono: json['num_telefono'].toString().replaceAll('[', '').replaceAll(']', '')
    );
  }
  /// Override del metodo toString per ottenere una rappresentazione testuale dell'oggetto.
  @override
  String toString() {
    return 'AnnuncioDiLavoroDTO{id: $_id, nome: $_nome, descrizione: $_descrizione, approvato: $_approvato, via: $_via, citta: $_citta, provincia: $_provincia, immagine: $_immagine, email: $_email, numTelefono: $_numTelefono}';
  }
}
