class CandidaturaDTO {
  late int? _id_utente;
  late int? _id_lavoro;

  /// Costruttore di [CandidaturaDTO].
  ///
  /// Inizializza un'istanza di [CandidaturaDTO] con valori per id_utente e id_lavoro.
  CandidaturaDTO({required int? id_lavoro, required int? id_utente})
      : _id_lavoro = id_lavoro,
        _id_utente = id_utente;

  /// Factory method per creare un'istanza di [CandidaturaDTO] da una mappa JSON.
  ///
  /// Il metodo prende in input una mappa (json) e restituisce un'istanza di [CandidaturaDTO].
  factory CandidaturaDTO.fromJson(dynamic json) {
    return CandidaturaDTO(
      id_lavoro: json['id_lavoro'],
      id_utente: json['id_utente'],
    );
  }

  get id_utente => _id_utente;

  get id_lavoro => _id_lavoro;

  /// Metodo per convertire il DTO in una mappa JSON.
  ///
  /// Restituisce una mappa JSON rappresentante l'istanza corrente.
  Map<String, dynamic> toJson() {
    return {
      'id_lavoro': id_lavoro,
      'id_utente': id_utente,
    };
  }

  /// Metodo per convertire il DTO in una mappa.
  ///
  /// Restituisce una mappa rappresentante l'istanza corrente.
  Map<String, dynamic> toMap() {
    return {
      'id_lavoro': id_lavoro,
      'id_utente': id_utente,
    };
  }

  /// Factory method per creare un'istanza di [CandidaturaDTO] da una mappa.
  ///
  /// Prende in input una mappa e restituisce un'istanza di [CandidaturaDTO].
  factory CandidaturaDTO.fromMap(Map<String, dynamic> map) {
    return CandidaturaDTO(
      id_lavoro: map['id_lavoro'] as int,
      id_utente: map['id_utente'] as int,
    );
  }

  /// Metodo per rappresentare l'istanza come stringa.
  ///
  /// Restituisce una stringa che rappresenta l'istanza corrente.
  @override
  String toString() {
    return 'CandidaturaDTO{id_utente: $_id_utente, id_lavoro: $_id_lavoro}';
  }
}
