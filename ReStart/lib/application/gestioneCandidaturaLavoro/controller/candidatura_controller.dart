import 'dart:convert';
import '../../../model/entity/utente_DTO.dart';
import '../service/candidatura_service_impl.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

/// Controller per la gestione delle candidature.
///
/// Questa classe si occupa della gestione delle richieste HTTP relative
/// alle candidature di lavoro, come l'applicazione a un lavoro e la ricerca
/// dei candidati.
class CandidaturaController {
  /// Service per gestire le operazioni relative alle candidature.
  late final CandidaturaServiceImpl _service;

  /// Router per la gestione dei percorsi HTTP.
  late final shelf_router.Router _router;

  /// Costruttore che inizializza il servizio di candidatura e configura i percorsi.
  CandidaturaController() {
    _service = CandidaturaServiceImpl();
    _router = shelf_router.Router();

    // Associa i vari metodi alle route
    _router.post('/apply', _candidatura);
    _router.post('/listaCandidati', _findCandidati);

    // Aggiungi la route di fallback per le richieste non corrispondenti.
    _router.all('/<ignored|.*>', _notFound);
  }

  /// Fornisce l'accesso al router.
  shelf_router.Router get router => _router;

  /// Gestisce la candidatura a un lavoro.
  ///
  /// Accetta una richiesta con i dettagli della candidatura e invoca il service
  /// per registrare la candidatura. Restituisce una risposta basata sull'esito dell'operazione.
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

  /// Trova e restituisce una lista di candidati per un determinato lavoro.
  ///
  /// Accetta una richiesta con l'ID del lavoro e restituisce la lista dei candidati.
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
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante la visualizzazione dei candidati: $e');
    }
  }

  /// Gestisce le richieste non corrispondenti.
  ///
  /// Restituisce una risposta 404 per qualsiasi richiesta non corrispondente alle route definite.
  Future<Response> _notFound(Request request) async {
    return Response.notFound('Endpoint non trovato',
        headers: {'Content-Type': 'text/plain'});
  }

  /// Analizza il corpo di una richiesta form-encoded e lo trasforma in un dizionario.
  ///
  /// Utilizzata per processare i dati form-encoded nelle richieste POST.
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
