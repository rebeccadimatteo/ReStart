/// Questa classe rappresenta l'entity di un corso di formazione
class CorsoDiFormazioneDTO {
  ///id univoco di un corso di formazione
  late int? _id;
  ///nome del corso di formazione
  late String _nomeCorso;
  ///anagrafica del responsabile del corso
  late String _nomeResponsabile;
  late String _cognomeResponsabile;
  ///descrizione del croso di formazione
  late String _descrizione;
  ///url del sito web dove è possibile seguire il corso di formazione
  late String _urlCorso;
  ///immagine associata a un croso di formazione
  late String _immagine;

  ///costruttore che permette di istanziare un nuovo corso di formazione nel sistema
  CorsoDiFormazioneDTO({
    required int? id,
    required String nomeCorso,
    required String nomeResponsabile,
    required String cognomeResponsabile,
    required String descrizione,
    required String urlCorso,
    required String immagine,
  })  : _id = id,
        _nomeCorso = nomeCorso,
        _nomeResponsabile = nomeResponsabile,
        _cognomeResponsabile = cognomeResponsabile,
        _descrizione = descrizione,
        _immagine = immagine,
        _urlCorso = urlCorso;

  ///getters e setters
  String get immagine => _immagine;

  set immagine(String value) {
    _immagine = value;
  }

  int get id => _id ?? -1; // -1 valore di default che non può essere un id

  String get urlCorso => _urlCorso;

  set urlCorso(String value) {
    _urlCorso = value;
  }

  String get descrizione => _descrizione;

  set descrizione(String value) {
    _descrizione = value;
  }

  String get cognomeResponsabile => _cognomeResponsabile;

  set cognomeResponsabile(String value) {
    _cognomeResponsabile = value;
  }

  String get nomeResponsabile => _nomeResponsabile;

  set nomeResponsabile(String value) {
    _nomeResponsabile = value;
  }

  String get nomeCorso => _nomeCorso;

  set nomeCorso(String value) {
    _nomeCorso = value;
  }

/// Factory method per la creazione del DTO da una mappa (solitamente utilizzato quando si deserializzano dati da JSON).
  factory CorsoDiFormazioneDTO.fromJson(dynamic json) {
    return CorsoDiFormazioneDTO(
      id: json['id'],
      nomeCorso:
          json['nome_corso'].toString().replaceAll('[', '').replaceAll(']', ''),
      nomeResponsabile: json['nome_responsabile']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      cognomeResponsabile: json['cognome_responsabile']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      descrizione: json['descrizione']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''),
      urlCorso:
          json['url_corso'].toString().replaceAll('[', '').replaceAll(']', ''),
      immagine:
          json['immagine'].toString().replaceAll('[', '').replaceAll(']', ''),
    );
  }

  /// Metodo per convertire il DTO in una mappa (solitamente utilizzato quando si serializzano dati in JSON).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome_corso': nomeCorso,
      'nome_responsabile': nomeResponsabile,
      'cognome_responsabile': cognomeResponsabile,
      'descrizione': descrizione,
      'url_corso': urlCorso,
      'immagine': immagine,
    };
  }

  @override
  String toString() {
    return 'CorsoDiFormazioneDTO{id: $_id, nomeCorso: $_nomeCorso, nomeResponsabile: $_nomeResponsabile, cognomeResponsabile: $_cognomeResponsabile, descrizione: $_descrizione, urlCorso: $_urlCorso, immagine: $_immagine}';
  }
}
