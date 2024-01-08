import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../../model/entity/utente_DTO.dart';
import '../service/registrazione_service.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

import '../service/registrazione_service_impl.dart';

class RegistrazioneController {
  late final RegistrazioneService _service;
  late final shelf_router.Router _router;

  RegistrazioneController(){
    _service = RegistrazioneServiceImpl();
    _router = shelf_router.Router();
    
    _router.post('signup', _signup);

    // Aggiungi la route di fallback per le richieste non corrispondenti
    _router.all('/<ignored|.*>', _notFound);
  }

  shelf_router.Router get router => _router;

  Future<Response> _signup(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final String nome= params['nome_utente'] ?? '';
      final String cognome = params['cognome'] ?? '';
      final String cod_fiscale = params['cod_fiscale'] ?? '';
      final DateTime data_nascita = params['data_nascita'] ?? '';
      final String luogo_nascita = params['luogo_nascita'] ?? '';
      final String genere = params['genere'] ?? '';
      final String username = params['username'] ?? '';
      final String password = params['password'] ?? '';
      final String lavoro_adatto = params['lavoro_adatto'] ?? '';
      final String email = params['email'] ?? '';
      final String num_telefono = params['num_telefono'] ?? '';
      final String immagine = params['immagine'] ?? '';
      final String via = params['via'] ?? '';
      final String citta = params['citta'] ?? '';
      final String provincia = params['provincia'] ?? '';

      UtenteDTO utente = UtenteDTO(
          nome: nome,
          cognome: cognome,
          cod_fiscale: cod_fiscale,
          data_nascita: data_nascita,
          luogo_nascita: luogo_nascita,
          genere: genere,
          username: username,
          password: password,
          lavoro_adatto: lavoro_adatto,
          email: email,
          num_telefono: num_telefono,
          immagine: immagine,
          via: via,
          citta: citta,
          provincia: provincia
      );

      print(utente);

      if (await _service.signUp(utente)) {
        final responseBody = jsonEncode({'result': "Registrazione effettuata."});
        return Response.ok(responseBody,
            headers: {'Content-Type': 'application/json'});
      } else {
        final responseBody =
        jsonEncode({'result': 'Registrazione non effettuata'});
        return Response.badRequest(
            body: responseBody, headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante l\'inserimento del utente: $e');
    }
  }

  // Gestisci le richieste non corrispondenti
  Future<Response> _notFound(Request request) async {
    return Response.notFound('Endpoint non trovato',
        headers: {'Content-Type': 'text/plain'});
  }

  // Funzione per il parsing dei dati di form
  Map<String, dynamic> parseFormBody(String body) {
    final Map<String, dynamic> formData = {};
    final List<String> pairs = body.split("&");
    for (final String pair in pairs) {
      final List<String> keyValue = pair.split("=");
      if (keyValue.length == 2) {
        final String key = Uri.decodeQueryComponent(keyValue[0]);
        final String value = Uri.decodeQueryComponent(keyValue[1]);
        formData[key] = value;
      }
    }
    return formData;
  }
}