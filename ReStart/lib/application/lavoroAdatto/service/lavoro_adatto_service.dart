/// Interfaccia per il service di Lavoro Adatto.
///
/// Definisce il metodo per determinare il lavoro più adatto per un utente basandosi su specifici dati.
abstract class LavoroAdattoService {
  /// Determina il lavoro più adatto per un utente basandosi sui dati forniti.
  ///
  /// Accetta un [Map<String, dynamic>] contenente i dati necessari per valutare il lavoro adatto per un utente specifico,
  /// insieme all'ID dell'utente a cui il lavoro è destinato.
  ///
  /// Restituisce una [Future<String>] che rappresenta il titolo del lavoro più adatto calcolato in base ai dati forniti.
  Future<String> lavoroAdatto(Map<String, dynamic> form, int id);
}
