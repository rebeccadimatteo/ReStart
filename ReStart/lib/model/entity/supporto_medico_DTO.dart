import 'dart:convert';

/// Questa classe rappresenta l'entity del Supporto Medico
class SupportoMedicoDTO {
  ///id univoco di un supporto medico
  late int? _id;
  ///immagine associata a un supporto medico
  late String _immagine;
  ///nome del medico
  late String _nomeMedico;
  ///cognome del medico
  late String _cognomeMedico;
  ///descrizione del supporto medico offerto
  late String _descrizione;
  ///contatti del medico di riferimento
  late String _email;
  late String _numTelefono;
  ///indirizzo dello studio medico
  late String _via;
  late String _citta;
  late String _provincia;

  ///costruttore che permette di istanziare un nuovo supporto medico nel sistema
  SupportoMedicoDTO({
    required int? id,
    required String nomeMedico,
    required String cognomeMedico,
    required String descrizione,
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
        _immagine = immagine,
        _email = email,
        _numTelefono = numTelefono,
        _via = via,
        _citta = citta,
        _provincia = provincia;

  ///getters e setters
  int get id => _id ?? -1; // -1 valore di default che non può essere un id

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

  ///metodo che permette di trasformare un ogetto [json] in un [SupportoMedicoDTO]
  factory SupportoMedicoDTO.fromJson(Map<String, dynamic> json) {
    return SupportoMedicoDTO(
      id: json['id'],
      nomeMedico: json['nome'].toString().replaceAll('[', '').replaceAll(']', ''),
      cognomeMedico: json['cognome'].toString().replaceAll('[', '').replaceAll(']', ''),
      descrizione: json['descrizione'].toString().replaceAll('[', '').replaceAll(']', ''),
      immagine: json['immagine'].toString().replaceAll('[', '').replaceAll(']', ''),
      email: json['email'].toString().replaceAll('[', '').replaceAll(']', ''),
      numTelefono: json['num_telefono'].toString().replaceAll('[', '').replaceAll(']', ''),
      via : json['via'].toString().replaceAll('[', '').replaceAll(']', ''),
      citta : json['citta'].toString().replaceAll('[', '').replaceAll(']', ''),
      provincia : json['provincia'].toString().replaceAll('[', '').replaceAll(']', ''),
    );
  }

  ///metodo che permette di trasformare un ogetto [SupportoMedicoDTO] in un [json]
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nomeMedico,
      'cognome': cognomeMedico,
      'descrizione': descrizione,
      'immagine': immagine,
      'email': email,
      'num_telefono': numTelefono,
      'via': via,
      'citta': citta,
      'provincia': provincia
    };
  }

  @override
  String toString() {
    return 'SupportoMedicoDTO{id: $_id, immagine: $_immagine, nomeMedico: $_nomeMedico, cognomeMedico: $_cognomeMedico, descrizione: $_descrizione, email: $_email, numTelefono: $_numTelefono, via: $_via, citta: $_citta, provincia: $_provincia}';
  }
}
