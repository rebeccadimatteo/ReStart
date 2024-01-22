import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import '../../../model/entity/evento_DTO.dart';
import '../service/evento_service_impl.dart';

/// Controller per la gestione degli eventi.
///
/// Gestisce le richieste HTTP relative agli eventi, come la visualizzazione,
/// l'aggiunta, la modifica e l'eliminazione degli eventi.
class GestioneEventoController {
  /// Service per la gestione degli eventi.
  late final EventoServiceImpl _service;

  /// Router per la gestione dei percorsi HTTP.
  late final shelf_router.Router _router;

  /// Costruttore che inizializza il servizio di gestione eventi e configura i percorsi.
  GestioneEventoController() {
    _service = EventoServiceImpl();
    _router = shelf_router.Router();

    // Associazione dei metodi ai percorsi.
    _router.post('/visualizzaEventi', _visualizzaEventi);
    _router.post('/eventiApprovati', _eventiApprovati);
    _router.post('/addEvento', _addEvento);
    _router.post('/eventiPubblicati', _eventiPubblicati);
    _router.post('/eventiSettimanali', _eventiSettimanali);
    _router.post('/deleteEvento', _deleteEvento);
    _router.post('/modifyEvento', _modifyEvento);
    _router.post('/approveEvento', _approveEvento);
    _router.post('/rejectEvento', _rejectEvento);
    _router.post('/rejectEvento', _richiesteEventi);
    _router.all('/ignored|.*>', _notFound);
  }

  /// Fornisce l'accesso al router.
  shelf_router.Router get router => _router;

  /// Gestisce la visualizzazione degli eventi.
  ///
  /// Recupera e restituisce un elenco di eventi.
  Future<Response> _visualizzaEventi(Request request) async {
    try {
      final List<EventoDTO> listaEventi = await _service.communityEvents();
      final responseBody = jsonEncode({'eventi': listaEventi});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: 'Errore durante la visualizzazione degli eventi: $e');
    }
  }

  /// Aggiunge un nuovo evento.
  ///
  /// Decodifica i dettagli dell'evento dalla richiesta e li passa al service per l'aggiunta.
  Future<Response> _addEvento(Request request) async {
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
        parsedDate = DateTime.now();
      }
      final int idCa = params['id_ca'] ?? '';
      final String nomeEvento = params['nome'] ?? '';
      final String descrizione = params['descrizione'] ?? '';
      final bool approvato = params['approvato'] ?? '';
      final String email = params['email'] ?? '';
      final String immagine = params['immagine'] ?? '';
      final String via = params['via'] ?? '';
      final String citta = params['citta'] ?? '';
      final String provincia = params['provincia'] ?? '';

      EventoDTO evento = EventoDTO(
          id_ca: idCa,
          nomeEvento: nomeEvento,
          descrizione: descrizione,
          date: parsedDate,
          approvato: approvato,
          email: email,
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
          body: 'Errore durante l\'inserimento dell\'evento: $e');
    }
  }

  /// Elimina un evento.
  ///
  /// Decodifica l'ID dell'evento dalla richiesta e lo passa al service per l'eliminazione.
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

  /// Approva un evento.
  ///
  /// Decodifica l'ID dell'evento dalla richiesta e lo passa al service per l'approvazione.
  Future<Response> _approveEvento(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final int id = params['id'];
      String result = await _service.approveEvento(id);

      String responseBody;

      switch (result) {
        case "Approvazione effettuata":
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
          body: 'Errore durante l\'approvazione dell\'evento: $e');
    }
  }

  /// Rifiuta un evento.
  ///
  /// Decodifica l'ID dell'evento dalla richiesta e lo passa al service per il rifiuto.
  Future<Response> _rejectEvento(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final int id = params['id'] ?? '';
      String result = await _service.rejectEvento(id);
      String responseBody;

      switch (result) {
        case "Rifiuto effettuato":
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
          body: 'Errore durante il rifiuto dell\'evento: $e');
    }
  }

  /// Gestisce la richiesta per ottenere gli eventi approvati.
  Future<Response> _eventiApprovati(Request request) async {
    try {
      final List<EventoDTO> listaEventi = await _service.eventiApprovati();
      final responseBody = jsonEncode({'eventi': listaEventi});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: 'Errore durante la visualizzazione degli eventi: $e');
    }
  }

  /// Gestisce la richiesta per modificare un evento.
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
      }

      final int id =
          params['id'] != null ? int.parse(params['id'].toString()) : 0;
      final int idCa =
          params['id_ca'] != null ? int.parse(params['id_ca'].toString()) : 0;
      final String immagine = params['immagine'] ?? '';
      final String nomeEvento = params['nome'] ?? '';
      final String descrizione = params['descrizione'] ?? '';
      final bool approvato = params['approvato'] ?? 'false';
      final String email = params['email'] ?? '';
      final String via = params['via'] ?? '';
      final String citta = params['citta'] ?? '';
      final String provincia = params['provincia'] ?? '';
      EventoDTO evento = EventoDTO(
        id: id,
        id_ca: idCa,
        immagine: immagine,
        nomeEvento: nomeEvento,
        descrizione: descrizione,
        approvato: approvato,
        email: email,
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
        final responseBody = jsonEncode({'result': 'Modifica non effettuata.'});
        return Response.badRequest(
            body: responseBody, headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante la modifica dell\'evento: $e');
    }
  }

  /// Gestisce la richiesta per ottenere gli eventi pubblicati da un CA.
  Future<Response> _eventiPubblicati(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);

      final String username = params['username'] ?? '';
      final List<EventoDTO> listaEventi =
          await _service.eventiPubblicati(username);
      final responseBody = jsonEncode({'eventi': listaEventi});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body:
              'Errore durante la visualizzazione degli eventi pubblicati: $e');
    }
  }

  /// Gestisce la richiesta per ottenere le richieste di eventi.
  Future<Response> _richiesteEventi(Request request) async {
    try {
      final List<EventoDTO> listaEventi = await _service.richiesteEventi();

      final responseBody = jsonEncode({'eventi': listaEventi});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body:
              'Errore durante la visualizzazione degli eventi da approvare: $e');
    }
  }

  /// Gestisce la richiesta per ottenere gli eventi settimanali.
  Future<Response> _eventiSettimanali(Request request) async {
    try {
      final List<EventoDTO> listaEventi = await _service.eventiSettimanali();
      final responseBody = jsonEncode({'eventi': listaEventi});

      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body: 'Errore durante la visualizzazione degli eventi: $e');
    }
  }

  /// Gestisce le richieste a percorsi non definiti.
  Future<Response> _notFound(Request request) async {
    return Response.notFound('Endpoint non trovato',
        headers: {'Content-Type': 'text/plain'});
  }

  /// Funzione per il parsing dei dati di form
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
