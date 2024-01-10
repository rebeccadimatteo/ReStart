import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import '../../../model/entity/evento_DTO.dart';
import '../service/evento_service_impl.dart';

class GestioneEventoController {
  late final EventoServiceImpl _service;
  late final shelf_router.Router _router;

  GestioneEventoController() {
    _service = EventoServiceImpl();
    _router = shelf_router.Router();

    _router.post('/visualizzaEventi', _visualizzaEventi);
    _router.post('/addEvento', _addEvento);
    //_router.post('/dettagliEvento', _dettagliEvento);
    _router.post('/deleteEvento', _deleteEvento);
    _router.post('/modifyEvento' ,_modifyEvento);
    _router.all('/ignored|.*>', _notFound);
  }

  shelf_router.Router get router => _router;

  Future<Response> _visualizzaEventi(Request request) async {
    try {
      final List<EventoDTO> listaEventi = await _service.communityEvents();
      final responseBody = jsonEncode({'eventi': listaEventi});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: 'Errore durante la visualizzazione dei corsi: $e');
    }
  }
  Future<Response> _addEvento(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final int id_ca = params['id_ca'] ?? '';
      final String nomeEvento = params['nome'] ?? '';
      final String descrizione = params['descrizione'] ?? '';
      final DateTime date = params['data'] ?? '';
      final bool approvato = params['approvato'] ?? '';
      final String email = params['email'] ?? '';
      final String sito = params['sito'] ?? '';
      final String immagine = params['immagine'] ?? '';
      final String via = params['via'] ?? '';
      final String citta = params['citta'] ?? '';
      final String provincia = params['provincia'] ?? '';

      EventoDTO evento = EventoDTO(
          id_ca: id_ca,
          nomeEvento: nomeEvento,
          descrizione: descrizione,
          date: date,
          approvato: approvato,
          email: email,
          sito: sito,
          immagine: immagine,
          via: via,
          citta: citta,
          provincia: provincia);

      if (await _service.addEvento(evento)) {
        final responseBody = jsonEncode({'result': "Inserimento effettuato."});
        return Response.ok(responseBody,
            headers: {'Content-Type': 'application/json'});
      } else {
        final responseBody =
        jsonEncode({'result': 'Inserimento non effettuato'});
        return Response.badRequest(
            body: responseBody, headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante l\'inserimento del corso di formazione: $e');
    }
  }

  Future<Response> _deleteEvento(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final int id = params['id'] ?? '';

      if (await _service.deleteEvento(id)) {
        final responseBody = jsonEncode({'result': "Eliminazione effettuata."});
        return Response.ok(responseBody,
            headers: {'Content-Type': 'application/json'});
      } else {
        final responseBody =
        jsonEncode({'result': 'Eliminazione non effettuata.'});
        return Response.badRequest(
            body: responseBody, headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante l\'eliminazione dell\'evento: $e');
    }
  }
  Future<Response> _modifyEvento(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      var rawData = params['data'] ?? '';
      DateTime parsedDate;

      if (rawData is DateTime) {
        parsedDate = rawData;
      } else if (rawData is String) {
        parsedDate = DateTime.parse(rawData);
      } else {
        // Puoi gestire altri tipi o scenari a tua discrezione
        parsedDate = DateTime.now();

        final int id = params['id'] != null ? int.parse(params['id'].toString()) : 0;
        final int id_ca = params['id_ca'] != null ? int.parse(
            params['id_ca'].toString()) : 0;
        final String immagine = params['immagine'] ?? '';
        final String nomeEvento = params['nomeEvento'] ?? '';
        final String descrizione = params['descrizione'] ?? '';
        final bool approvato = params['approvato'] ?? 'false';
        final String email = params['email'] ?? '';
        final String sito = params['sito'] ?? '';
        final String via = params['via'] ?? '';
        final String citta = params['citta'] ?? '';
        final String provincia = params['provincia'] ?? '';
        EventoDTO evento = EventoDTO(
          id: id,
          id_ca: id_ca,
          immagine: immagine,
          nomeEvento: nomeEvento,
          descrizione: descrizione,
          approvato: approvato,
          email: email,
          sito: sito,
          via: via,
          citta: citta,
          provincia: provincia,
          date: parsedDate,
        );

        if (await _service.modifyEvento(evento)) {
          final responseBody = jsonEncode({'result': "Modifica effettuata."});
          return Response.ok(responseBody,
              headers: {'Content-Type': 'application/json'});
        } else {
          final responseBody = jsonEncode(
              {'result': 'Modifica non effettuata.'});
          return Response.badRequest(
              body: responseBody,
              headers: {'Content-Type': 'application/json'});
        }
      }
    } catch (e) {
      print(e);
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante la modifica dell\'evento: $e');
    }

  }

  Future<Response> _notFound(Request request) async {
    return Response.notFound('Endpoint non trovato',
        headers: {'Content-Type': 'text/plain'});
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