import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import '../../../model/entity/annuncio_di_lavoro_DTO.dart';
import '../service/lavoro_service_impl.dart';

/// Controller per la gestione degli annunci di lavoro.
///
/// Gestisce le richieste HTTP relative agli annunci di lavoro, includendo operazioni come
/// la visualizzazione, l'aggiunta, la modifica, l'approvazione, e la cancellazione degli annunci.
class GestioneLavoroController {
  late final LavoroServiceImpl _service;
  late final shelf_router.Router _router;

  GestioneLavoroController() {
    _service = LavoroServiceImpl();
    _router = shelf_router.Router();

    // Associazione dei metodi ai percorsi.
    _router.post('/visualizzaLavori', _visualizzaLavori);
    _router.post('/annunciApprovati', _annunciApprovati);
    _router.post('/addLavoro', _addLavoro);
    _router.post('/deleteLavoro', _deleteLavoro);
    _router.post('/modifyLavoro', _modifyLavoro);
    _router.post('/approveLavoro', _approveLavoro);
    _router.post('/rejectLavoro', _rejectLavoro);
    _router.post('/richiesteAnnunci', _richiesteAnnunci);
    _router.post('/annunciPubblicati', _annunciPubblicati);

    _router.all('/<ignored|.*>', _notFound);
  }

  shelf_router.Router get router => _router;

  /// Gestisce la richiesta per visualizzare tutti gli annunci di lavoro.
  ///
  /// Decodifica la richiesta e invoca il service per ottenere un elenco di annunci di lavoro.
  Future<Response> _visualizzaLavori(Request request) async {
    try {
      final List<AnnuncioDiLavoroDTO> listaLavori =
          await _service.offerteLavoro();
      final responseBody = jsonEncode({'annunci': listaLavori});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'apllication/json'});
    } catch (e) {
      return Response.internalServerError(
          body: 'Errore durante la visualizzazzione della richiesta');
    }
  }

  /// Gestisce la richiesta per aggiungere un nuovo annuncio di lavoro.
  ///
  /// Decodifica la richiesta e invoca il service per aggiungere un nuovo annuncio di lavoro.
  Future<Response> _addLavoro(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      // Ottieni i valori dei parametri
      final int idCa = params['id_ca'] ?? '';
      final String nomeLavoro = params['nome'] ?? '';
      final String descrizione = params['descrizione'] ?? '';
      final bool approvato = params['approvato'] == 'true';
      final String via = params['via'] ?? '';
      final String citta = params['citta'] ?? '';
      final String provincia = params['provincia'] ?? '';
      final String immagine = params['immagine'] ?? '';
      final String email = params['email'] ?? '';
      final String numTelefono = params['num_telefono'] ?? '';

      //capire il noid come si utilizza
      AnnuncioDiLavoroDTO lavoro = AnnuncioDiLavoroDTO(
          id_ca: idCa,
          nomeLavoro: nomeLavoro,
          descrizione: descrizione,
          approvato: approvato,
          via: via,
          citta: citta,
          provincia: provincia,
          immagine: immagine,
          email: email,
          numTelefono: numTelefono);

      if (await _service.addLavoro(lavoro)) {
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
      // Gestione degli errori durante la chiamata al Service
      return Response.internalServerError(
          body: 'Errore durante la visualizzazione dei supporti medici: $e');
    }
  }

  /// Gestisce la richiesta per eliminare un annuncio di lavoro.
  ///
  /// Decodifica l'ID dell'annuncio dalla richiesta e invoca il service per eliminarlo.
  Future<Response> _deleteLavoro(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final int id = params['id'] ?? '';

      if (await _service.deleteLavoro(id)) {
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
      // Gestione degli errori durante la chiamata al Service
      return Response.internalServerError(
          body: 'Errore durante l\'eliminazione del lavoro: $e');
    }
  }

  /// Gestisce la richiesta per ottenere gli annunci di lavoro approvati.
  ///
  /// Invoca il Service per ottenere un elenco di annunci di lavoro approvati.
  Future<Response> _annunciApprovati(Request request) async {
    try {
      final List<AnnuncioDiLavoroDTO> listaAnnunci =
          await _service.annunciApprovati();
      final responseBody = jsonEncode({'annunci': listaAnnunci});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body:
              'Errore durante la visualizzazione degli annunci di lavoro: $e');
    }
  }

  /// Gestisce la richiesta per modificare un annuncio di lavoro esistente.
  ///
  /// Decodifica i dettagli dell'annuncio dalla richiesta e invoca il service per modificarlo.
  Future<Response> _modifyLavoro(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);

      final int id =
          params['id'] != null ? int.parse(params['id'].toString()) : 0;
      final int idCa =
          params['id_ca'] != null ? int.parse(params['id_ca'].toString()) : 0;
      final String nomeLavoro = params['nome'] ?? '';
      final String descrizione = params['descrizione'] ?? '';
      final bool approvato = params['approvato'] ?? 'false';
      final String via = params['via'] ?? '';
      final String citta = params['citta'] ?? '';
      final String provincia = params['provincia'] ?? '';
      final String email = params['email'] ?? '';
      final String immagine = params['immagine'] ?? '';
      final String numTelefono = params['num_telefono'] ?? '';
      AnnuncioDiLavoroDTO lavoro = AnnuncioDiLavoroDTO(
        id: id,
        id_ca: idCa,
        nomeLavoro: nomeLavoro,
        descrizione: descrizione,
        approvato: approvato,
        via: via,
        citta: citta,
        provincia: provincia,
        email: email,
        immagine: immagine,
        numTelefono: numTelefono,
      );

      if (await _service.modifyLavoro(lavoro)) {
        final responseBody = jsonEncode({'result': "Modifica effettuata."});
        return Response.ok(responseBody,
            headers: {'Content-Type': 'application/json'});
      } else {
        final responseBody = jsonEncode({'result': 'Modifica non effettuata.'});
        return Response.badRequest(
            body: responseBody, headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      // Gestione degli errori durante la chiamata al Service
      return Response.internalServerError(
          body: 'Errore durante la modifica del lavoro: $e');
    }
  }

  /// Gestisce la richiesta per approvare un annuncio di lavoro.
  ///
  /// Decodifica l'ID dell'annuncio dalla richiesta e invoca il Service per approvarlo.
  Future<Response> _approveLavoro(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final int id = params['id'] ?? '';

      String result = await _service.approveLavoro(id);

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
      // Gestione degli errori durante la chiamata al Service
      return Response.internalServerError(
          body: 'Errore durante l\'inserimento della Candidatura: $e');
    }
  }

  /// Gestisce la richiesta per rifiutare un annuncio di lavoro.
  ///
  /// Decodifica l'ID dell'annuncio dalla richiesta e invoca il Service per rifiutarlo.
  Future<Response> _rejectLavoro(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final int id = params['id'] ?? '';

      String result = await _service.rejectLavoro(id);

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
      // Gestione degli errori durante la chiamata al Service
      return Response.internalServerError(
          body: 'Errore durante il rifiuto dell\'annuncio: $e');
    }
  }

  /// Gestisce la richiesta per ottenere gli annunci di lavoro pubblicati da un CA specifico.
  ///
  /// Decodifica lo username del ca dalla richiesta e invoca il Service per ottenere gli annunci pubblicati.
  Future<Response> _annunciPubblicati(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final String username = params['username'] ?? '';
      final List<AnnuncioDiLavoroDTO> listaAnnunci =
          await _service.offertePubblicate(username);

      final responseBody = jsonEncode({'annunci': listaAnnunci});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body:
              'Errore durante la visualizzazione degli annunci pubblicati: $e');
    }
  }

  /// Gestisce la richiesta per ottenere gli annunci di lavoro pubblicati da un CA specifico.
  ///
  /// Decodifica lo username del ca dalla richiesta e invoca il Service per ottenere gli annunci pubblicati.
  Future<Response> _richiesteAnnunci(Request request) async {
    try {
      final List<AnnuncioDiLavoroDTO> listaAnnunci =
          await _service.richiesteAnnunci();

      final responseBody = jsonEncode({'annunci': listaAnnunci});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(
          body:
              'Errore durante la visualizzazione degli annunci da approvare: $e');
    }
  }

  // Gestisci le richieste non corrispondenti
  Future<Response> _notFound(Request request) async {
    return Response.notFound('Endpoint non trovato',
        headers: {'Content-Type': 'text/plain'});
  }

  /// Gestisce le richieste a percorsi non definiti.
  ///
  /// Restituisce una risposta di 'not found' per le richieste a percorsi non mappati.
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
