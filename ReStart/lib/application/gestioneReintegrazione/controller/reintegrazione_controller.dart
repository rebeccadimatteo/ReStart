import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/form_data.dart';
import 'package:shelf_multipart/multipart.dart';

import 'package:shelf_router/shelf_router.dart' as shelf_router;
import '../../../model/entity/alloggio_temporaneo_DTO.dart';
import '../../../model/entity/corso_di_formazione_DTO.dart';
import '../../../model/entity/supporto_medico_DTO.dart';
import '../service/reintegrazione/reintegrazione_service_impl.dart';

/// Controller per la gestione dei servizi di reintegrazione.
///
/// Gestisce le richieste HTTP relative ai corsi di formazione, alloggi temporanei
/// e supporti medici, inclusa l'aggiunta e la rimozione di tali elementi.
class ReintegrazioneController {
  late final ReintegrazioneServiceImpl _service;
  late final shelf_router.Router _router;

  ReintegrazioneController() {
    _service = ReintegrazioneServiceImpl();
    _router = shelf_router.Router();

    // Associa i vari metodi alle route
    _router.post('/visualizzaCorsi', _visualizzaCorsi);
    _router.post('/visualizzaAlloggi', _visualizzaAlloggi);
    _router.post('/visualizzaSupporti', _visualizzaSupporti);
    _router.post('/addCorso', _addCorso);
    _router.post('/addSupporto', _addSupporto);
    _router.post('/addAlloggio', _addAlloggio);
    _router.post('/addImage', _uploadImage);
    _router.post('/deleteCorso', _deleteCorso);
    _router.post('/deleteAlloggio', _deleteAlloggio);
    _router.post('/deleteSupporto', _deleteSupporto);

    // Aggiungi la route di fallback per le richieste non corrispondenti
    _router.all('/<ignored|.*>', _notFound);
  }

  shelf_router.Router get router => _router;

  /// Gestisce la richiesta per visualizzare tutti i corsi di formazione.
  Future<Response> _visualizzaCorsi(Request request) async {
    try {
      // Chiamata al servizio per ottenere la lista di corsi
      final List<CorsoDiFormazioneDTO> listaCorsi =
          await _service.corsiDiFormazione();
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

  /// Gestisce la richiesta per visualizzare tutti i supporti medici.
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

  /// Gestisce la richiesta per visualizzare tutti gli alloggi temporanei.
  Future<Response> _visualizzaAlloggi(Request request) async {
    try {
      // Chiamata al servizio per ottenere la lista di alloggi
      final List<AlloggioTemporaneoDTO> listaAlloggi =
          await _service.alloggiTemporanei();
      // Creazione della risposta con il corpo JSON contenente la lista di alloggi
      final responseBody = jsonEncode({'alloggi': listaAlloggi});
      return Response.ok(responseBody,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante la visualizzazione degli alloggi: $e');
    }
  }

  /// Gestisce la richiesta per aggiungere un nuovo corso di formazione.
  Future<Response> _addCorso(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final String nomeCorso = params['nome_corso'] ?? '';
      final String nomeResponsabile = params['nome_responsabile'] ?? '';
      final String cognomeResponsabile = params['cognome_responsabile'] ?? '';
      final String descrizione = params['descrizione'] ?? '';
      final String urlCorso = params['url_corso'] ?? '';
      final String immagine = params['immagine'] ?? '';

      CorsoDiFormazioneDTO corso = CorsoDiFormazioneDTO(
          nomeCorso: nomeCorso,
          nomeResponsabile: nomeResponsabile,
          cognomeResponsabile: cognomeResponsabile,
          descrizione: descrizione,
          urlCorso: urlCorso,
          immagine: immagine);

      if (await _service.addCorso(corso)) {
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

  /// Gestisce la richiesta per aggiungere un nuovo alloggio temporaneo.
  Future<Response> _addAlloggio(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      final String nome = params['nome'] ?? '';
      final String descrizione = params['descrizione'] ?? '';
      final String tipo = params['tipo'] ?? '';
      final String citta = params['citta'] ?? '';
      final String via = params['via'] ?? '';
      final String provincia = params['provincia'] ?? '';
      final String email = params['email'] ?? '';
      final String sito = params['sito'] ?? '';
      final String immagine = params['immagine'] ?? '';

      AlloggioTemporaneoDTO alloggio = AlloggioTemporaneoDTO(
        nome: nome,
        descrizione: descrizione,
        tipo: tipo,
        citta: citta,
        via: via,
        provincia: provincia,
        email: email,
        sito: sito,
        immagine: immagine,
      );

      if (await _service.addAlloggio(alloggio)) {
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

  /// Gestisce la richiesta per caricare un'immagine.
  Future<Response> _uploadImage(Request request) async {
    try {
      if (!request.isMultipartForm) {
        return Response.badRequest(body: 'Tipo di contenuto non valido.');
      }

      final parts = request.parts;
      String? nome;
      List<int>? imageData;

      await for (final part in parts) {
        if (part.headers.containsKey('content-disposition')) {
          final contentDisposition =
              HeaderValue.parse(part.headers['content-disposition']!);
          final name = contentDisposition.parameters['name'];

          if (name == 'nome') {
            nome = await part
                .toList()
                .then((value) => utf8.decode(value.expand((i) => i).toList()));
          } else if (name == 'immagine') {
            imageData = await part
                .toList()
                .then((value) => value.expand((i) => i).toList());
          }
        }
      }

      if (nome != null && imageData != null) {
        final imagePath = 'images/image_$nome.jpg';
        final imageFile = File(imagePath);
        if (await imageFile.exists()) {
          // Elimina il file esistente
          await imageFile.delete();
        }
        await imageFile.writeAsBytes(imageData);

        return Response.ok('Immagine caricata con successo');
      } else {
        return Response.badRequest(body: 'Dati mancanti nella richiesta');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Errore server: $e');
    }
  }

  /// Gestisce la richiesta per aggiungere un nuovo supporto medico.
  Future<Response> _addSupporto(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);

      final String nomeMedico = params['nome'] ?? '';
      final String cognomeMedico = params['cognome'] ?? '';
      final String numTelefono = params['num_telefono'] ?? '';
      final String descrizione = params['descrizione'] ?? '';
      final String tipo = params['tipo'] ?? '';
      final String via = params['via'] ?? '';
      final String citta = params['citta'] ?? '';
      final String provincia = params['provincia'] ?? '';
      final String immagine = params['immagine'] ?? '';
      final String email = params['email'] ?? '';

      SupportoMedicoDTO supporto = SupportoMedicoDTO(
          nomeMedico: nomeMedico,
          cognomeMedico: cognomeMedico,
          descrizione: descrizione,
          tipo: tipo,
          immagine: immagine,
          email: email,
          numTelefono: numTelefono,
          via: via,
          citta: citta,
          provincia: provincia);

      if (await _service.addSupportoMedico(supporto)) {
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
          body: 'Errore durante l\'inserimento del supporto medico: $e');
    }
  }

  /// Gestisce la richiesta per eliminare un corso di formazione.
  Future<Response> _deleteCorso(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);

      final int idCorso =
          params['id'] != null ? int.parse(params['id'].toString()) : 0;

      if (await _service.deleteCorso(idCorso)) {
        final responseBody = jsonEncode({'result': "Eliminazione effettuata."});
        return Response.ok(responseBody,
            headers: {'Content-Type': 'application/json'});
      } else {
        final responseBody =
            jsonEncode({'result': 'Eliminazione non effettuata'});
        return Response.badRequest(
            body: responseBody, headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante l\'eliminazione del corso: $e');
    }
  }

  /// Gestisce la richiesta per eliminare un alloggio temporaneo.
  Future<Response> _deleteAlloggio(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);

      final int idAlloggio =
          params['id'] != null ? int.parse(params['id'].toString()) : 0;

      if (await _service.deleteAlloggio(idAlloggio)) {
        final responseBody = jsonEncode({'result': "Eliminazione effettuata."});
        return Response.ok(responseBody,
            headers: {'Content-Type': 'application/json'});
      } else {
        final responseBody =
            jsonEncode({'result': 'Eliminazione non effettuata'});
        return Response.badRequest(
            body: responseBody, headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante l\'eliminazione dell\'alloggio: $e');
    }
  }

  /// Gestisce la richiesta per eliminare un supporto medico.
  Future<Response> _deleteSupporto(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);

      final int idSupporto =
          params['id'] != null ? int.parse(params['id'].toString()) : 0;

      if (await _service.deleteSupporto(idSupporto)) {
        final responseBody = jsonEncode({'result': "Eliminazione effettuata."});
        return Response.ok(responseBody,
            headers: {'Content-Type': 'application/json'});
      } else {
        final responseBody =
            jsonEncode({'result': 'Eliminazione non effettuata'});
        return Response.badRequest(
            body: responseBody, headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante l\'eliminazione del supporto medico: $e');
    }
  }

  /// Metodo per la gestione delle richieste non corrispondenti
  Future<Response> _notFound(Request request) async {
    return Response.notFound('Endpoint not found',
        headers: {'Content-Type': 'text/plain'});
  }

// Funzione ausiliaria per il parsing dei dati di form.
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
