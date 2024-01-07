import 'dart:convert';
import 'package:restart_all_in_one/model/entity/alloggio_temporaneo_DTO.dart';
import 'package:restart_all_in_one/model/entity/corso_di_formazione_DTO.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import '../../../model/entity/supporto_medico_DTO.dart';
import '../service/reintegrazione/reintegrazione_service_impl.dart';

class ReintegrazioneController {
  late final ReintegrazioneServiceImpl _service;
  late final shelf_router.Router _router;

  ReintegrazioneController() {
    _service = ReintegrazioneServiceImpl();
    _router = shelf_router.Router();

    // Associa i vari metodi alle route
    _router.post('/visualizzaCorsi', _visualizzaCorsi);
   // _router.post('/addCorso', _addCorso);
   // _router.post('/visualizzaAlloggi', _visualizzaAlloggi);
    _router.post('/visualizzaSupporti', _visualizzaSupporti);

    // Aggiungi la route di fallback per le richieste non corrispondenti
    _router.all('/<ignored|.*>', _notFound);
  }

  shelf_router.Router get router => _router;

  Future<Response> _visualizzaCorsi(Request request) async {
    try {
      // Chiamata al servizio per ottenere la lista di corsi
      final List<CorsoDiFormazioneDTO> listaCorsi =
      await _service.getListaCorsi();
      // Creazione della risposta con il corpo JSON contenente la lista di corsi
      final responseBody = jsonEncode({'corsi': listaCorsi});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante la visualizzazione dei corsi: $e');
    }
  }

  Future<Response> _visualizzaSupporti(Request request) async {
    try {
      // Chiamata al servizio per ottenere la lista di alloggi
      final List<SupportoMedicoDTO> listaSupporti =
      await _service.supportiMedici();
      // Creazione della risposta con il corpo JSON contenente la lista di supporti
      final responseBody = jsonEncode({'supporti': listaSupporti});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante la visualizzazione dei supporti medici: $e');
    }
  }

  // Gestisci le richieste non corrispondenti
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
