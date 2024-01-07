import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../../model/entity/corso_di_formazione_DTO.dart';
import '../service/reintegrazione/reintegrazione_service_impl.dart';

class ReintegrazioneController {
  late final ReintegrazioneServiceImpl _service;

  ReintegrazioneController() {
    _service = ReintegrazioneServiceImpl();
  }

  Future<Response> handleRequest(Request request) async {
    print("ciao mamma");

    try {
      final Map<String, dynamic> requestBody =
          await request.readAsString().then((body) => parseFormBody(body));
      final String action = request.url.pathSegments.last;

      switch (action) {
        case 'visualizzaCorsi':
          return _visualizzaCorsi(request);
        /*      case 'create_user':
          return _createUser(request);
        case 'update_user':
          return _updateUser(request);
        case 'delete_user':
          return _deleteUser(request);
    */
        default:
          return Response.notFound('Endpoint non trovato');
      }
    } catch (e) {
      return Response.internalServerError(
          body: 'Errore durante l\'elaborazione della richiesta: $e');
    }
  }

  Future<Response> _visualizzaCorsi(Request request) async {
    try {
      // Chiamata al servizio per ottenere la lista di eventi
      final List<CorsoDiFormazioneDTO> listaCorsi =
          await _service.getListaCorsi();
      // Creazione della risposta con il corpo JSON contenente la lista di eventi
      final responseBody = jsonEncode({'corsi': listaCorsi});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante la visualizzazione dei corsi: $e');
    }
  }
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
