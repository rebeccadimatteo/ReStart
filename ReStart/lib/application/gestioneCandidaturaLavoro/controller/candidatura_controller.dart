import 'dart:convert';

import '../../../model/entity/utente_DTO.dart';
import '../service/candidatura_service_impl.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

class CandidaturaController {
  late final CandidaturaServiceImpl _service;
  late final shelf_router.Router _router;

  CandidaturaController() {
    _service = CandidaturaServiceImpl();
    _router = shelf_router.Router();

    // Associa i vari metodi alle route
    _router.post('/apply', _candidatura);
    _router.post('/listaCandidati', _findCandidati);

    // Aggiungi la route di fallback per le richieste non corrispondenti
    _router.all('/<ignored|.*>', _notFound);
  }

  shelf_router.Router get router => _router;

  Future<Response> _candidatura(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final int idLavoro = int.parse(params['idLavoro']);
      final String username = params['username'] ?? '';

      String result = await _service.candidatura(username, idLavoro);

      String responseBody;

      switch (result) {
        case "Candidatura effettuata":
          {
            responseBody = jsonEncode({'result': result});
            return Response.ok(responseBody,
                headers: {'Content-Type': 'application/json'});
          }

        default:
          {
            responseBody = jsonEncode({'result': result});
            return Response.badRequest(
                body: responseBody,
                headers: {'Content-Type': 'application/json'});
          }
      }
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante l\'inserimento della Candidatura: $e');
    }
  }

  Future<Response> _findCandidati(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final int idLavoro = params['id'];

      final List<UtenteDTO> listaCandidati =
      await _service.listaCandidati(idLavoro);

      // Creazione della risposta con il corpo JSON contenente la lista di candidati
      final responseBody = jsonEncode({'candidati': listaCandidati});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      print(e);
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante la visualizzazione dei candidati: $e');
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

