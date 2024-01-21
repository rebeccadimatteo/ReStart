import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lavoro_adatto_adapter.dart';

/// Implementazione dell'adapter di Lavoro Adatto.
///
/// Utilizza un servizio esterno per determinare il lavoro più adatto basandosi sui dati forniti.
class LavoroAdattoAdapterImpl implements LavoroAdattoAdapter {
  LavoroAdattoAdapterImpl();

  /// Implementa il metodo per determinare il lavoro più adatto.
  ///
  /// Effettua una richiesta POST a un servizio esterno, inviando i dati dell'utente.
  /// In base alla risposta del servizio, restituisce il titolo del lavoro più adatto.
  ///
  /// Accetta un [Map<String, dynamic>] contenente i dati necessari per la valutazione.
  /// Restituisce una [Future<String>] che rappresenta il lavoro calcolato come più adatto.
  ///
  /// Solleva un'eccezione in caso di errore nella comunicazione con il servizio o se la risposta non è quella attesa.
  @override
  Future<String> lavoroAdatto(Map<String, dynamic> data) async {
    final url = Uri.parse('http://127.0.0.1:5000/predict');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['predicted_job_title'];
      } else {
        throw Exception('Errore del server: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Errore durante la comunicazione con il server: $e');
    }
  }
}
