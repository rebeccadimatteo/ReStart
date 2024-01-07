import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
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
    //_router.post('/addEvento', _addEvento);
    //_router.post('/dettagliEvento', _dettagliEvento);

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