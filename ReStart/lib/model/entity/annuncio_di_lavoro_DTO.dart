/// Questa classe rappresenta un oggetto DTO (Data Transfer Object) per un annuncio di lavoro.
class AnnuncioDiLavoroDTO {
  int? _id;
  late int _id_ca;
  late String _nomeLavoro;
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
    int? id,
    required int id_ca,
    required String nomeLavoro,
    required String descrizione,
    required bool approvato,
    required String via,
    required String citta,
    required String provincia,
    required String immagine,
    required String email,
    required String numTelefono
  })  : _id = id,
        _id_ca = id_ca,
        _nomeLavoro = nomeLavoro,
        _descrizione = descrizione,
        _approvato = approvato,
        _via = via,
        _citta = citta,
        _provincia = provincia,
        _immagine = immagine,
        _email = email,
        _numTelefono = numTelefono;

  /// Getters e setters per accedere ai membri della classe.
  int? get id => _id;
  int get id_ca => _id_ca;
  String get nome => _nomeLavoro;
  String get descrizione => _descrizione;
  bool get approvato => _approvato;
  String get via => _via;
  String get citta => _citta;
  String get provincia => _provincia;
  String get immagine => _immagine;
  String get email => _email;
  String get numTelefono => _numTelefono;

  set id_ca(int value){
    _id_ca = value;
  }
  set nome(String value) {
    _nomeLavoro = value;
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
  /// Metodo toJson per la serializzazione dell'oggetto in formato JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'id_ca': _id_ca,
      'nome': _nomeLavoro,
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
        id: json['id'],
        id_ca: json['id_ca'],
        nomeLavoro: json['nome'].toString().replaceAll('[', '').replaceAll(']', ''),
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
    return 'AnnuncioDiLavoroDTO{id: $_id, id_ca: $id_ca, nome: $_nomeLavoro, descrizione: $_descrizione, approvato: $_approvato, via: $_via, citta: $_citta, provincia: $_provincia, immagine: $_immagine, email: $_email, numTelefono: $_numTelefono}';
  }
}