/// Questa classe rappresenta l'entity della Candidatura.
class CandidaturaDTO {
  ///Id univoco di un utente.
  late int? _id_utente;
  ///Id univoco di un lavoro.
  late int? _id_lavoro;

  ///Costruttore che permette di istanziare una nuova candidatura nel sistema.
  CandidaturaDTO({
    required int? id_lavoro,
    required int? id_utente
  })  : _id_lavoro = id_lavoro,
        _id_utente = id_utente;

  /// Factory method per la creazione del DTO da una mappa (solitamente utilizzato quando si deserializzano dati da JSON).
  factory CandidaturaDTO.fromJson(dynamic json) {
    return CandidaturaDTO(
      id_lavoro: json['id_lavoro'],
      id_utente: json['id_utente'],
    );
  }

///getters
  get id_utente => _id_utente;
  get id_lavoro => _id_lavoro;

  /// Metodo per convertire il DTO in una mappa (solitamente utilizzato quando si serializzano dati in JSON).
  Map<String, dynamic> toJson() {
    return {
      'id_lavoro': id_lavoro,
      'id_utente': id_utente,
    };
  }

}