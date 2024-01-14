import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lavoro_adatto_adapter.dart';

class LavoroAdattoAdapterImpl implements LavoroAdattoAdapter{
  LavoroAdattoAdapterImpl();
  @override
  Future<String> lavoroAdatto(Map<String, dynamic> data) async {
    final url = Uri.parse('http://127.0.0.1:5000/predict');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        return data['predicted_job_title'];
      } else {
        throw Exception('Errore del server: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Errore durante la comunicazione con il server: $e');
    }
  }

}