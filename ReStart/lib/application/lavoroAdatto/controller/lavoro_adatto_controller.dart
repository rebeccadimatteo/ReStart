import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../service/lavoro_adatto_service.dart';
import '../service/lavoro_adatto_service_impl.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

/// Controller per la gestione delle richieste relative al Lavoro Adatto.
///
/// Gestisce le richieste HTTP relative alla determinazione del lavoro più adatto per un utente.
class LavoroAdattoController {
  late final LavoroAdattoService _service;
  late final shelf_router.Router _router;

  LavoroAdattoController() {
    _service = LavoroAdattoServiceImpl();
    _router = shelf_router.Router();

    // Associa i vari metodi alle route
    _router.post('/findLavoroAdatto', _findLavoroAdatto);

    // Aggiungi la route di fallback per le richieste non corrispondenti
    _router.all('/<ignored|.*>', _notFound);
  }

  /// Gestisce la richiesta per trovare il lavoro più adatto in base ai dati forniti.
  ///
  /// Decodifica i dati dall'utente dalla richiesta e li invia al servizio di Lavoro Adatto.
  /// Restituisce il titolo del lavoro adatto calcolato o un messaggio di errore.
  Future<Response> _findLavoroAdatto(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      int id = params['id'];
      Map<String, dynamic> data = params['form'];

      String lavoroAdatto = await _service.lavoroAdatto(data, id);
      if (lavoroAdatto != '') {
        final responseBody = jsonEncode({'result': lavoroAdatto});
        return Response.ok(responseBody,
            headers: {'Content-Type': 'application/json'});
      } else {
        final responseBody =
            jsonEncode({'result': 'Lavoro adatto non trovato'});
        return Response.badRequest(
            body: responseBody, headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante la chiamata al modulo: $e');
    }
  }

  /// Gestisce le richieste a percorsi non definiti.
  ///
  /// Restituisce una risposta di 'not found' per le richieste a percorsi non mappati.
  Future<Response> _notFound(Request request) async {
    return Response.notFound('Endpoint not found',
        headers: {'Content-Type': 'text/plain'});
  }

  shelf_router.Router get router => _router;

  /// Funzione ausiliaria per il parsing dei dati di form.
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
