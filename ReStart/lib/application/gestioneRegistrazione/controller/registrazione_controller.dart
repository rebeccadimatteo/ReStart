import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/form_data.dart';
import 'package:shelf_multipart/multipart.dart';

import '../../../model/entity/utente_DTO.dart';
import '../service/registrazione_service.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

import '../service/registrazione_service_impl.dart';

/// Controller per la gestione della registrazione degli utenti.
///
/// Gestisce le richieste HTTP relative alla registrazione degli utenti, inclusa l'aggiunta di immagini.
class RegistrazioneController {
  /// Service per gestire le operazioni relative alla registrazione.
  late final RegistrazioneService _service;

  /// Router per la gestione dei percorsi HTTP
  late final shelf_router.Router _router;

  RegistrazioneController() {
    _service = RegistrazioneServiceImpl();
    _router = shelf_router.Router();

    _router.post('/signup', _signup);
    _router.post('/addImage', _uploadImage);

    // Aggiungi la route di fallback per le richieste non corrispondenti
    _router.all('/<ignored|.*>', _notFound);
  }

  shelf_router.Router get router => _router;

  /// Gestisce la richiesta di registrazione di un nuovo utente.
  ///
  /// Decodifica i dati dell'utente dalla richiesta e li invia al servizio di registrazione.
  Future<Response> _signup(Request request) async {
    try {
      final String requestBody = await request.readAsString();
      final Map<String, dynamic> params = jsonDecode(requestBody);
      var rawData = params['data_nascita'] ?? '';

      DateTime parsedDate;

      if (rawData is DateTime) {
        parsedDate = rawData;
      } else if (rawData is String) {
        parsedDate = DateTime.parse(rawData);
      } else {
        // Puoi gestire altri tipi o scenari a tua discrezione
        parsedDate = DateTime.now();
      }
      final String nome = params['nome'] ?? '';
      final String cognome = params['cognome'] ?? '';
      final String codFiscale = params['cod_fiscale'] ?? '';
      final String luogoNascita = params['luogo_nascita'] ?? '';
      final String genere = params['genere'] ?? '';
      final String username = params['username'] ?? '';
      final String password = params['password'] ?? '';
      final String lavoroAdatto = params['lavoro_adatto'] ?? '';
      final String email = params['email'] ?? '';
      final String numTelefono = params['num_telefono'] ?? '';
      final String immagine = params['immagine'] ?? '';
      final String via = params['via'] ?? '';
      final String citta = params['citta'] ?? '';
      final String provincia = params['provincia'] ?? '';

      UtenteDTO utente = UtenteDTO(
          nome: nome,
          cognome: cognome,
          cod_fiscale: codFiscale,
          data_nascita: parsedDate,
          luogo_nascita: luogoNascita,
          genere: genere,
          username: username,
          password: password,
          lavoro_adatto: lavoroAdatto,
          email: email,
          num_telefono: numTelefono,
          immagine: immagine,
          via: via,
          citta: citta,
          provincia: provincia);

      if (await _service.signUp(utente)) {
        final responseBody =
            jsonEncode({'result': "Registrazione effettuata."});
        return Response.ok(responseBody,
            headers: {'Content-Type': 'application/json'});
      } else {
        final responseBody =
            jsonEncode({'result': 'Registrazione non effettuata'});
        return Response.badRequest(
            body: responseBody, headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      // Gestione degli errori durante la chiamata al servizio
      return Response.internalServerError(
          body: 'Errore durante l\'inserimento del utente: $e');
    }
  }

  /// Gestisce il caricamento dell'immagine per un utente.
  ///
  /// Riceve e salva l'immagine caricata dall'utente.
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

  /// Gestisce le richieste a percorsi non definiti.
  ///
  /// Restituisce una risposta di 'not found' per le richieste a percorsi non mappati.
  Future<Response> _notFound(Request request) async {
    return Response.notFound('Endpoint non trovato',
        headers: {'Content-Type': 'text/plain'});
  }

  /// Funzione ausiliaria per il parsing dei dati di form.
  ///
  /// Decodifica i dati di form inviati con la richiesta.
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
